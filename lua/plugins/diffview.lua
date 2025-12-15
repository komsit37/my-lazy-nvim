-- Get formatted git status file list
local function get_git_status_view()
  local function run_git(args)
    local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
    return result.stdout or ""
  end

  local function status_hl(status)
    local s = vim.trim(status):sub(1, 1)
    local hls = {
      ["A"] = "SnacksPickerGitStatusAdded",
      ["M"] = "SnacksPickerGitStatusModified",
      ["D"] = "SnacksPickerGitStatusDeleted",
      ["R"] = "SnacksPickerGitStatusRenamed",
      ["C"] = "SnacksPickerGitStatusCopied",
      ["?"] = "SnacksPickerGitStatusUntracked",
    }
    local hl = hls[s] or "SnacksPickerGitStatus"
    hl = status:sub(1, 1) == "M" and "SnacksPickerGitStatusStaged" or hl
    return hl
  end

  local function add_path_hls(hls, line, col, path)
    local dir, base = path:match("^(.*)/([^/]+)$")
    if not dir then
      table.insert(hls, { line = line, col_start = col, col_end = col + #path, group = "SnacksPickerFile" })
      return
    end
    table.insert(hls, { line = line, col_start = col, col_end = col + #dir + 1, group = "SnacksPickerDir" })
    table.insert(hls, { line = line, col_start = col + #dir + 1, col_end = col + #path, group = "SnacksPickerFile" })
  end

  local function add_section(lines, hls, title, items)
    if vim.tbl_isempty(items) then
      return
    end
    local title_line = #lines
    table.insert(lines, title)
    table.insert(hls, { line = title_line, col_start = 0, col_end = -1, group = "SnacksPickerTitle" })

    for _, item in ipairs(items) do
      local indent = "  "
      local status = item.status
      local line = indent .. status .. " "
      local line_idx = #lines

      if item.rename then
        line = line .. item.rename .. " -> " .. item.file
      else
        line = line .. item.file
      end

      table.insert(lines, line)

      local status_col = #indent
      table.insert(
        hls,
        { line = line_idx, col_start = status_col, col_end = status_col + 2, group = status_hl(status) }
      )

      local path_col = status_col + 3
      if item.rename then
        add_path_hls(hls, line_idx, path_col, item.rename)
        local arrow_col = path_col + #item.rename + 1
        table.insert(
          hls,
          { line = line_idx, col_start = arrow_col, col_end = arrow_col + 2, group = "SnacksPickerDelim" }
        )
        add_path_hls(hls, line_idx, arrow_col + 3, item.file)
      else
        add_path_hls(hls, line_idx, path_col, item.file)
      end
    end
  end

  local status_out = run_git({ "-c", "core.quotepath=false", "--no-pager", "status", "-uall", "--porcelain=v1", "-z" })
  local staged_diff = vim.trim(run_git({ "--no-pager", "diff", "--cached" }))

  local entries = {} ---@type {status:string,file:string,rename?:string}[]
  local prev ---@type {status:string,file:string,rename?:string}?
  for _, chunk in ipairs(vim.split(status_out, "\0", { plain = true, trimempty = true })) do
    local status, file = chunk:match("^(..) (.+)$")
    if status and file then
      local entry = { status = status, file = file }
      table.insert(entries, entry)
      prev = entry
    elseif prev and prev.status:find("R") then
      prev.rename = chunk
    end
  end

  local staged_items, unstaged_items = {}, {}
  for _, e in ipairs(entries) do
    local x, y = e.status:sub(1, 1), e.status:sub(2, 2)

    if e.status == "??" or e.status == "!!" then
      table.insert(unstaged_items, e)
    else
      if x ~= " " then
        table.insert(staged_items, { status = x .. " ", file = e.file, rename = e.rename })
      end
      if y ~= " " then
        table.insert(unstaged_items, { status = " " .. y, file = e.file, rename = e.rename })
      end
    end
  end

  local lines, hls = { "", "" }, {}

  add_section(lines, hls, "Staged changes:", staged_items)

  add_section(lines, hls, "Unstaged changes:", unstaged_items)

  if staged_diff ~= "" then
    if #lines > 4 then
      table.insert(lines, "")
    end
    local title_line = #lines
    table.insert(lines, "Staged diff:")
    table.insert(hls, { line = title_line, col_start = 0, col_end = -1, group = "SnacksPickerTitle" })
    for _, l in ipairs(vim.split(staged_diff, "\n", { plain = true })) do
      table.insert(lines, l)
    end
  end

  if #lines == 4 then
    table.insert(lines, "No changes to commit")
    table.insert(hls, { line = #lines - 1, col_start = 0, col_end = -1, group = "SnacksPickerComment" })
  end

  return lines, hls
end

-- Git commit utility function
local function git_commit()
  local win = Snacks.win({
    ft = "diff",
    width = 0.9,
    height = 0.9,
    border = "hpad",
    on_buf = function(self)
      local lines, hls = get_git_status_view()
      vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
      for _, hl in ipairs(hls) do
        vim.api.nvim_buf_add_highlight(self.buf, -1, hl.group, hl.line, hl.col_start, hl.col_end)
      end
    end,
  })

  require("snacks").input({
    prompt = "git commit -m ",
    on_cancel = function()
      win:close()
    end,
  }, function(msg)
    -- Close the status notifier when input finishes
    -- require("snacks").notifier.hide(1)
    win:close()

    if not msg or msg == "" then
      return
    end

    local result = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()
    if result.code ~= 0 then
      Snacks.notify.error(
        "Commit failed:\n" .. vim.trim(result.stdout .. "\n" .. result.stderr),
        { title = "Git Commit" }
      )
    else
      Snacks.notify.info(result.stdout, { title = "Git Commit" })
    end
  end)
end

-- Git commit amend utility function
local function git_commit_amend()
  local win = Snacks.win({
    ft = "diff",
    width = 0.9,
    height = 0.9,
    border = "hpad",
    on_buf = function(self)
      local lines, hls = get_git_status_view()
      vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
      for _, hl in ipairs(hls) do
        vim.api.nvim_buf_add_highlight(self.buf, -1, hl.group, hl.line, hl.col_start, hl.col_end)
      end
    end,
  })

  Snacks.input({
    prompt = "Amend message (leave empty to reuse): ",
    on_cancel = function()
      win:close()
    end,
  }, function(msg)
    -- Close the status window when input finishes
    win:close()

    if msg == nil then
      return
    end

    local cmd = { "git", "commit", "--amend" }
    if msg == "" then
      table.insert(cmd, "--no-edit")
    else
      table.insert(cmd, "-m")
      table.insert(cmd, msg)
    end

    local result = vim.system(cmd, { text = true }):wait()
    if result.code ~= 0 then
      vim.notify(
        "Amend failed:\n" .. vim.trim(result.stdout .. "\n" .. result.stderr),
        vim.log.levels.ERROR,
        { title = "Git Commit Amend" }
      )
    else
      vim.notify(result.stdout, vim.log.levels.INFO, { title = "Git Commit Amend" })
    end
  end)
end

return {
  "sindrets/diffview.nvim",
  dependencies = { "ray-x/snacks.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>" },

    {
      "<leader>gV",
      function()
        require("snacks.picker").git_branches({
          prompt = "Select branch to diff with",
          confirm = function(picker, item)
            picker:close()
            vim.cmd("DiffviewOpen " .. item.text)
          end,
        })
      end,
    },

    { "<leader>gO", "<cmd>DiffviewFileHistory %<cr>" },
    { "<leader>gU", "<cmd>DiffviewFileHistory<cr>" },
    { "<leader>gx", "<cmd>DiffviewClose<cr>" },
    { "<leader>gc", git_commit },
    { "<leader>gC", git_commit_amend },
  },
  config = function()
    require("diffview").setup({
      keymaps = {
        file_panel = {
          { "n", "cc", git_commit, desc = "Commit (custom)" },
          { "n", "ca", git_commit_amend, desc = "Commit Amend (custom)" },
        },
      },
    })
  end,
}
