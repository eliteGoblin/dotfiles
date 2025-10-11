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

-- Ensure proper encoding for icons over SSH
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Plugins
require("lazy").setup({
  -- File icons (recommended for file trees)
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {},
        default = true,
        strict = true,
      })
    end,
  },

  -- nvim-tree (file explorer)
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
      local function open_if_directory(data)
        local is_dir = vim.fn.isdirectory(data.file) == 1
        if is_dir then
          require("nvim-tree.api").tree.open()
        end
      end
      vim.api.nvim_create_autocmd("VimEnter", { callback = open_if_directory })
    end,
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fa", function() require("telescope.builtin").find_files({hidden=true}) end, desc = "Find all files (including hidden)" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "%.git/", "node_modules/" },
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = false, -- Default: don't show hidden files
            find_command = vim.fn.executable("fd") == 1 and { "fd", "--type", "f", "--strip-cwd-prefix" }
              or vim.fn.executable("fdfind") == 1 and { "fdfind", "--type", "f", "--strip-cwd-prefix" }
              or { "find", ".", "-type", "f" },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load fzf extension if available
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "json", "yaml", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "typescript-language-server" },
        handlers = {
          function(server_name)
            -- Map typescript-language-server to tsserver for lspconfig
            if server_name == "typescript-language-server" then
              require("lspconfig").tsserver.setup({})
            else
              require("lspconfig")[server_name].setup({})
            end
          end,
        },
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto" },
      })
    end,
  },

  -- Comment plugin
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Terminal (like VSCode)
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-`>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<C-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal (alternative)" },
    },
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-t>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },
})

-- Keymaps quality-of-life
local map = vim.keymap.set
map("n", "<leader>qq", "<cmd>qa!<cr>", { desc = "Quit all" })
map("n", "<leader>w", "<cmd>w<cr>",   { desc = "Save" })

-- Terminal keymaps
map("t", "<esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Go to left window" })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Go to lower window" })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Go to upper window" })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Go to right window" })

