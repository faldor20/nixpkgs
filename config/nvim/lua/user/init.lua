return {
  -- colorscheme	="monokai-pro",
  mappings = {
    n = {
      ["n"] = { "h" },
      ["e"] = { "j" },
      ["i"] = { "k" },
      ["o"] = { "l" },

      ["<C-w>n"] = { "<C-w>h" },
      ["<C-w>e"] = { "<C-w>j" },
      ["<C-w>i"] = { "<C-w>k" },
      ["<C-w>o"] = { "<C-w>l" },

      ["l"] = { "o" },
      ["L"] = { "O" },

      ["h"] = { "i" },
      ["H"] = { "I" },

      ["j"] = { "n" },
      ["J"] = { "N" },

      ["k"] = { "e" },
      ["K"] = { "E" },

      ["d"] = { "d" },
      ["D"] = { "D" },
      ["c"] = { "c" },
    },
    v = {
      ["h"] = { "i" },
      ["H"] = { "I" },
      ["n"] = { "h" },
      ["e"] = { "j" },
      ["i"] = { "k" },
      ["o"] = { "l" },
    },
    x = {
      ["p"] = { "pgvy" },
    }
  }, options = { opt = {
    clipboard = 'unnamedplus'
  },
    g = { tabstop = 4,
      shiftwidth = 4
    }
  },
  --   shiftwidth=4
  -- }
  lsp = {
    servers = {
      "nimls",
      "omnisharp",
      "tsserver",
      "nil_ls"
    },
    config = {
      nimls = {
        cmd = { "nimlangserver" }
      },
      omnisharp = {
        cmd = { "OmniSharp" }
      }
    }
  },
  plugins = {
    {
      "alaviss/nim.nvim",
      event = "User AstroFile",
    },
    {
      "dundalek/lazy-lsp.nvim", dependency = { 'neovim/nvim-lspconfig' },
      event = "User AstroFile",
      config = function()
        require('lazy-lsp').setup {
          excluded_servers = {
            "denols",
          },
        }
      end,

    },
    {
      "mbbill/undotree",
      event = "User AstroFile",
      config = function()

        local target_path = vim.fn.expand('~/.undodir')
        -- " create the directory and any parent directories
        -- " if the location does not exist.
        if vim.fn.isdirectory(target_path) ~= 0 then
          vim.fn.mkdir(target_path, "p", 0700)
        end
        vim.o.undodir = target_path
        vim.bo.undofile = true
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      config = function(plugin, opts)
        require "plugins.configs.luasnip" (plugin, opts) -- include the default astronvim config that calls the setup call
        require("neo-tree").setup({
          window = {
            mappings = {

              ["e"] = false,
            },
          },
        })
      end,
    },
    { -- override nvim-cmp plugin
      "hrsh7th/nvim-cmp",
      -- override the options table that is used in the `require("cmp").setup()` call
      opts = function(_, opts)
        -- opts parameter is the default options table
        -- the function is lazy loaded so cmp is able to be required
        local cmp = require "cmp"
        local compare = require('cmp.config.compare')
        local function props(entry1,entry2)
          local kind1= entry1:get_kind()
          local kind2= entry2:get_kind()
          print(kind1+":"+kind2)
          --1=text
          --2=method
          --3=function
          --5=field
          --6=variable
          --10=property
          if kind1 ~= kind2 then
          	if kind1 ==10 then
            	return true
          	elseif kind1 ==5 then
            	return true
          	elseif kind1 ==2 then
            	return true
            end
          end
        end
        local function non_props(entry1,entry2)
          local kind1= entry1:get_kind()
          local kind2= entry2:get_kind()
          print(kind1+":"+kind2)
          --1=text
          --2=method
          --3=function
          --5=field
          --6=variable
          --10=property
          if kind1 ~= kind2 then
          	if kind1 ==6 then
            	return true
          	elseif kind1 ==3 then
            	return true
            end
          end
        end
        -- modify the mapping part of the table

        --This enables autoselecting the first option
        cmp.setup {
          completion = {
            completeopt = 'menu,menuone,noinsert'



          },
          sorting = {
            priority_weight = 2,
            comparators = {
              --compare.sort_text,
              --compare.exact,
              compare.kindCompare,
              compare.non_props
              --compare.locality,
              --compare.score,
            },
          },

        }

        -- return the new table to be used
        return opts
      end,
    },
    {
      "loctvl842/monokai-pro.nvim", lazy = false,
      -- config=function()
      --   require("monokai-pro").setup()
      --  end
    },
    {
      "folke/tokyonight.nvim", lazy = false,
      -- config=function()
      --   require("monokai-pro").setup()
      --  end
    },
    {
      "morhetz/gruvbox", lazy = false,
      -- config=function()
      --   require("gruvbox").setup()
      --  end
    },
  }
}
