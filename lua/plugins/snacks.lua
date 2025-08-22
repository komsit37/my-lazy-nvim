return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      previewers = {
        diff = {
          builtin = false, -- use Neovim for previewing diffs (true) or use an external tool (false)
          cmd = { "delta" }, -- example to show a diff with delta
        },
        git = {
          builtin = false, -- use Neovim for previewing git output (true) or use git (false)
          args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
        },
      },
      layout = {
        preset = function()
          return "ivy_split"
        end,
      },
      layouts = {
        --   default = { layout = { width = 0.9 } },
        --   vertical = { layout = { width = 0.9 } },
        ivy_split = { layout = { height = 0.2 } },
      },
      sources = {
        grep = {
          -- {
          --   layout = {
          --     box = "vertical",
          --     backdrop = false,
          --     row = -1,
          --     width = 0,
          --     height = 0.4,
          --     border = "top",
          --     title = " {title} {live} {flags}",
          --     title_pos = "left",
          --     { win = "input", height = 1, border = "bottom" },
          --     {
          --       box = "horizontal",
          --       { win = "list", border = "none" },
          --       { win = "preview", title = "{preview}", width = 0.6, border = "left" },
          --     },
          --   },
          -- },
        },
        files = {},
        git_status = {},
        git_diff = {},
        git_log = {},
        git_log_file = {},
        explorer = {
          layout = { layout = { position = "right" } },
        },
      },
    },
  },
}
