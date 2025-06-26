# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a LazyVim-based Neovim configuration that extends the LazyVim starter template. The configuration follows LazyVim's plugin architecture and conventions.

**Core Structure:**
- `init.lua` - Entry point that bootstraps lazy.nvim and loads the configuration
- `lua/config/` - Core configuration files (options, keymaps, autocmds, highlights)
- `lua/plugins/` - Plugin specifications and customizations
- `lazy-lock.json` - Lock file for plugin versions

**Key Architecture Patterns:**
- Plugin configurations are modular files in `lua/plugins/` that return plugin specs
- LazyVim's plugin system automatically loads all specs from the plugins directory
- Custom keymaps, options, and highlights extend LazyVim defaults
- The configuration uses OSC 52 clipboard integration for SSH/remote usage

## Development Commands

**Code Formatting:**
```bash
# Format Lua code (uses stylua with 2-space indentation, 120 column width)
stylua .

# Lint markdown files
markdownlint-cli2 "**/*.md"
```

**Plugin Management:**
```bash
# Inside Neovim
:Lazy                    # Open lazy.nvim plugin manager
:Lazy update            # Update all plugins
:Lazy clean             # Remove unused plugins
:Lazy sync              # Update and clean plugins
```

**Testing Configuration:**
```bash
# Test configuration in isolation
nvim --clean -u init.lua

# Check for Lua syntax errors
luacheck lua/
```

## Key Configuration Details

**Custom Keymaps (`lua/config/keymaps.lua`):**
- Terminal: `<leader>tt` (toggle), `<leader>tf` (float)
- Comments: `<leader>c/` (toggle comments)
- Movement: `j`/`k` auto-center, `<C-j>`/`<C-u>` for half-page with centering
- Git pickers via Snacks.nvim: `<leader>gb` (branches), `<leader>gl` (log), `<leader>gf` (file log)

**Special Features:**
- OSC 52 clipboard support for SSH/remote usage (configured in `lua/config/options.lua`)
- Custom vim-illuminate highlighting (configured in `lua/config/highlights.lua`)
- Snacks terminal integration with float/toggle modes
- Git integration through Snacks picker functionality

**Plugin Organization:**
- `example.lua` - Contains LazyVim plugin configuration examples (disabled with early return)
- `snacks.lua` - Snacks.nvim configuration with git pickers
- Other plugin files follow LazyVim's plugin spec format

**Disabled Default Keymaps:**
- `<leader>ft` and `<leader>fT` (default terminal keymaps) are disabled in favor of Snacks terminal

When modifying this configuration, maintain compatibility with LazyVim's plugin system and follow the existing patterns for plugin specifications and keymaps.