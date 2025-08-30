-- Bootstrap Lazy.nvim 
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "javascript", "typescript", "vue", "python", "html", "c",
          "lua", "rust", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = false,
        }
      }
    end
  },

  -- Fugitive
  { "tpope/vim-fugitive" },

  --[[
  -- Rose pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "main",
        dark_variant = "main",
        extend_background_behind_borders = true,
        enable = {
          terminal = true,
          legacy_highlights = true,
          migrations = true,
        },
        styles = {
          bold = true,
          italic = false,
          transparency = true,
        }
      })
      vim.cmd("colorscheme rose-pine")
    end
  },
  ]]

  -- LSP config
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = function() require("mason").setup() end },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls", "vue_ls", "eslint",
          "pyright", "gopls", "clangd",
          "rust_analyzer", "html", "tailwindcss"
        },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      lspconfig.ts_ls.setup({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        init_options = { provideFormatter = false },
      })

      lspconfig.eslint.setup({ settings = { format = true } })

      for _, server in ipairs({ "pyright", "gopls", "clangd", "rust_analyzer", "html", "tailwindcss" }) do
        lspconfig[server].setup({})
      end
    end
  },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "L3MON4D3/LuaSnip" },
  { "onsails/lspkind-nvim" },

  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })
    end
  },
})

-- ?
vim.cmd("syntax off")
vim.cmd("hi Normal guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Comment guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Constant guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Identifier guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Statement guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi PreProc guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Type guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Special guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Underlined guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Todo guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi String guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi Function guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi StatusLine guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi StatusLineNC guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi CursorLine guibg=#2b2b2b")
vim.cmd("hi CursorLineNr guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi SignColumn guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi ModeMsg guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi MsgArea guifg=#e0e0e0 guibg=#2b2b2b")
vim.cmd("hi VertSplit guifg=#e0e0e0 guibg=#2b2b2b")

-- Vim settings
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.mouse = ""
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.shadafile = "NONE"
vim.g.netrw_banner = 0

-- Keybindings
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>i", vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)

-- Harpoon keybindings
local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)

-- Telescope keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

