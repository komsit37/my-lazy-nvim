-- lua/plugins/image.lua
return {
  "3rd/image.nvim",
  -- load it where you want images (markdown is common)
  ft = { "markdown", "norg", "help" },
  opts = {
    backend = "kitty", -- use Kitty Graphics Protocol
    kitty_method = "unicode", -- works reliably through tmux
    integrations = {
      markdown = { enabled = true, clear_in_insert_mode = true },
      neorg = { enabled = true },
      cmp = { enabled = false },
      telescope = { enabled = false },
    },
    -- scaling/limits (tweak to taste)
    max_width = 60,
    max_height = 40,
    max_width_window_percentage = 0.6,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs" },

    -- tmux-specific niceties
    tmux_show_only_in_active_window = true,
    editor_only_render_when_focused = true,

    -- converter (ImageMagick CLI is the most hassle-free)
    processor = "magick_cli",
  },
}
