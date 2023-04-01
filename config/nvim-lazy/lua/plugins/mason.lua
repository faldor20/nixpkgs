return{
{
    'williamboman/mason-lspconfig.nvim',
    opts={
	    ensure_installed = { "lua_ls", "rust_analyzer" },
		  automatic_installation=false
    }
		
},
  {"alaviss/nim.nvim",},
	{ "folke/tokyonight.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "dundalek/lazy-lsp.nvim",
    dependency={'neovim/nvim-lspconfig'},
    config=function(_,opts)
      require('lazy-lsp').setup{}
    end,
    
   },
  {
    "nvim-treesitter/nvim-treesitter",
  config = function(_, opts)
      -- SHould solve problems with nixos
    require("nvim-treesitter.install").compilers = { 'clang++'} 
  end,
    
   }, 
    
    {
    "neovim/nvim-lspconfig",
    dependencies = {
    },
    ---@class PluginLspOpts
    opts = {
      diagnostics={
        
    update_in_insert = true, 
        severity_sort=true,
        underline=true,
        virtural_text=true,
             },

          servers={
        tsserver={
          mason=false
        },
        eslint={
          mason=false,
        },
        jsonls={
          mason=false,
        },
           nimls={
          mason=false,
          settings={
          cmd={"nimlangserver"}
            }
        }
        }
    },
}      
 --      {

 --      ---@type lspconfig.options
 --      servers = {
 --      },
 --      -- you can do any additional lsp server setup here
 --      -- return true if you don't want this server to be setup with lspconfig
 --      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
 --      setup = {
 --        -- example to setup with typescript.nvim
 --        nimls = function(_, opts)
 --          config={
 --  					cmd={"nimlangserver"}
 --          }
 --        end,
 -- eslint = function()
 --        require("lazyvim.util").on_attach(function(client)
 --          if client.name == "eslint" then
 --            client.server_capabilities.documentFormattingProvider = true
 --          elseif client.name == "tsserver" then
 --            client.server_capabilities.documentFormattingProvider = false
 --          end
 --        end)
 --      end,        -- Specify * to use this function as a fallback for any server
 --        -- ["*"] = function(server, opts) end,
 --      },
 --    },
 --  },
}
