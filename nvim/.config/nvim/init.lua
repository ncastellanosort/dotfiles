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
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end
      
      configs.setup {
        ensure_installed = {
          "javascript", "typescript", "vue", "python", "html", "c", "java",
          "lua", "rust", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        }
      }
    end
  },

  -- Rose pine
  { "rose-pine/neovim",
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
  end },

  -- Fugitive
  { "tpope/vim-fugitive" },

  -- LSP config
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = function() require("mason").setup() end },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "jdtls",  
          "ts_ls", "vue_ls", "eslint",
          "pyright", "gopls", "clangd",
          "rust_analyzer", "html", "tailwindcss"
        },
        automatic_installation = true,
      })

      local lsp = vim.lsp

      -- TypeScript
      lsp.config["ts_ls"] = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        init_options = { provideFormatter = false },
      }
      lsp.enable("ts_ls")

      -- ESLint
      lsp.config["eslint"] = {
        settings = { format = true },
      }
      lsp.enable("eslint")

      -- Tailwind
      lsp.config["tailwindcss"] = {
        filetypes = {
          "html", "css", "javascript", "javascriptreact",
          "typescript", "typescriptreact", "vue", "svelte", "astro"
        },
        init_options = {
          userLanguages = {
            eelixir = "html-eex",
            eruby = "erb",
            javascript = "javascript",
            javascriptreact = "javascriptreact",
            typescript = "typescript",
            typescriptreact = "typescriptreact",
          },
        },
      }
      lsp.enable("tailwindcss")

      for _, server in ipairs({ "pyright", "gopls", "clangd", "rust_analyzer", "html" }) do
        lsp.enable(server)
      end
    end
  },

  -- Java LSP (jdtls)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls = require("jdtls")
      
      local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
      local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      
      local config = {
        cmd = {
          "/usr/lib/jvm/java-21-openjdk/bin/java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration", jdtls_path .. "/config_linux",
          "-data", workspace_dir,
        },
        
        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
        
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-1.8",
                  path = "/usr/lib/jvm/java-8-openjdk", 
                  default = true,
                },
                {
                  name = "JavaSE-21",
                  path = "/usr/lib/jvm/java-21-openjdk",
                },
              },
            },
            
            maven = {
              downloadSources = true,
            },
            
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            
            format = {
              enabled = true,
            },
            
            imports = {
              gradle = {
                enabled = true,
              },
              maven = {
                enabled = true,
              },
            },
          },
        },
        
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        
        init_options = {
          bundles = {},
        },
      }
      
      jdtls.start_or_attach(config)
      
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set("n", "<leader>co", jdtls.organize_imports, opts)
      vim.keymap.set("n", "<leader>cv", jdtls.extract_variable, opts)
      vim.keymap.set("v", "<leader>cv", [[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]], opts)
      vim.keymap.set("n", "<leader>cc", jdtls.extract_constant, opts)
      vim.keymap.set("v", "<leader>cc", [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]], opts)
      vim.keymap.set("v", "<leader>cm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
    end,
  },

  -- Autocomplete
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
vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end)
vim.diagnostic.config({
  virtual_text = true,  
  signs = true,        
  underline = true,    
  update_in_insert = false, 
})

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

-- Git status
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
