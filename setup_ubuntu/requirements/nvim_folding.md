# Neovim Tree-sitter Folding

## Goal
Enable structure-aware folding for JSON/JSONC, YAML, and Markdown using Tree-sitter.

## Implementation

### Parsers Required
```lua
ensure_installed = { "json", "jsonc", "yaml", "markdown", "markdown_inline" }
```

### Folding Configuration
Add to `init.lua`:
```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "yaml", "markdown" },
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldenable = true
    vim.opt_local.foldlevel = 99        -- Start with all folds open
    vim.opt_local.foldlevelstart = 99   -- Default fold level on open
    vim.opt_local.foldcolumn = "1"      -- Show fold column indicator
  end,
})
```

## Usage (Native Vim Keys)

| Key | Action |
|-----|--------|
| `zc` | Close fold at cursor |
| `zo` | Open fold at cursor |
| `za` | Toggle fold at cursor |
| `zM` | Close all folds |
| `zR` | Open all folds |

## Expected Behavior
- JSON/YAML: Fold objects, arrays, and mappings
- Markdown: Fold by headings and code blocks
- Instant folding, no lag on large files
- Works automatically on file open

## Verification
```bash
# Open JSON file in nvim
nvim package.json

# Try folding
# - Place cursor on an object/array
# - Press zc (should close fold)
# - Press zo (should open fold)
# - Press zM (should close all folds)
```

## Notes for Claude
- Use `v:lua.vim.treesitter.foldexpr()` (modern Neovim API)
- `foldlevel = 99` prevents auto-folding on file open
- Only applies to JSON/YAML/Markdown (not global)
