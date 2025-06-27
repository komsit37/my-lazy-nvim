return {
  {
    "ledger/vim-ledger",
    version = false,
    ft = "ledger",
    init = function()
      vim.g.ledger_bin = "hledger"
      vim.g.ledger_fuzzy_account_completion = 1
      vim.g.ledger_date_format = "%Y-%m-%d"
      vim.g.ledger_align_at = 70
      vim.cmd([[
        function LedgerSort() range
          execute a:firstline .. ',' .. a:lastline .. '! hledger -f - -I print'
          execute a:firstline .. ',' .. a:lastline .. 's/^    /  /g'
          execute a:firstline .. ',' .. a:lastline .. 'LedgerAlign'
        endfunction
        command -range LedgerSort :<line1>,<line2>call LedgerSort()
      ]])
    end,
    opt = {},
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        compat = {},
        default = { "lsp", "path", "snippets", "buffer", "omni" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "ledger",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        ledger = { "hledger" },
      },
      linters = {},
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ledger = { "trim_newlines", "trim_whitespace" },
      },
    },
  },
}
