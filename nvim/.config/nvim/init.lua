-- ~/.config/nvim/init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings (sane defaults)
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"

-- Plugins
require("lazy").setup({
  -- File icons (recommended for file trees)
  { "nvim-tree/nvim-web-devicons" },

  -- nvim-tree (stable, simple, VS Code–like)
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Reveal current file" },
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = { width = 34, preserve_window_proportions = true },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        git = { enable = true, ignore = false },
        actions = { open_file = { quit_on_open = false } },
      })
      -- Auto-open tree when starting in a directory: `nvim .`
      local function open_if_directory(data)
        local is_dir = vim.fn.isdirectory(data.file) == 1
        if is_dir then
          require("nvim-tree.api").tree.open()
        end
      end
      vim.api.nvim_create_autocmd("VimEnter", { callback = open_if_directory })
    end,
  },
})

-- Keymaps quality-of-life
local map = vim.keymap.set
map("n", "<leader>qq", "<cmd>qa!<cr>", { desc = "Quit all" })
map("n", "<leader>w", "<cmd>w<cr>",   { desc = "Save" })

