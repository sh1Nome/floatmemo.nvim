# floatmemo.nvim

A Neovim plugin to manage notes in a floating window. Keep your memo in one place across all projects.

## Features

- 📝 Simple floating window for taking notes
- 💾 Auto-save to a single memo file
- 📍 Consistent memo file location across projects
- ⚙️ Customizable window size and appearance

## Installation

Use your favorite package manager.

## Usage

### Commands

- `:FloatmemoOpen` - Open the floating memo window
- `:FloatmemoClose` - Close the floating memo window
- `:FloatmemoToggle` - Toggle the floating memo window

### Configuration

```lua
require('floatmemo').setup({
  -- Path to memo file (default: plugin root + /memo.txt)
  memo_path = nil,
  
  -- Window width as percentage (0 < value <= 100)
  width = 80,
  
  -- Window height as percentage (0 < value <= 100)
  height = 80,
  
  -- Save on close (true: save, false: discard changes)
  save_on_close = true,
  
  -- Border style ("single", "double", "shadow", "rounded", etc.)
  border = "rounded",
})
```

## Example Setup

```lua
require('floatmemo').setup({
  width = 90,
  height = 85,
  border = "rounded",
})

-- Toggle memo with <leader>m
vim.keymap.set('n', '<leader>m', ':FloatmemoToggle<CR>', { noremap = true })
```
