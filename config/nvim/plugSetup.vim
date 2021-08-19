"---- vim-plug setup  ----
let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')
if has('win32')&&!has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif
"-------- end vim-plug setup ----
call plug#begin('~/.config/nvim/plugged')

" Sensible default
Plug 'tpope/vim-sensible'

" Color schemes
Plug 'sainnhe/edge'
Plug 'sainnhe/gruvbox-material'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'tpope/vim-surround'
"LSP:
Plug 'neovim/nvim-lspconfig'
"Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'cohama/lexima.vim'
"Plug 'norcalli/snippets.nvim'
Plug 'hrsh7th/vim-vsnip'

"lsp stufff
" show type hints in f# and ocaml
Plug 'jubnzv/virtual-types.nvim'
"show rust type inlay and various other sextensions
Plug 'nvim-lua/lsp_extensions.nvim'
"signature help for compe
Plug 'ray-x/lsp_signature.nvim'
"fuzzy finding--
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
"----utility
"sets the root of vim to be th project root
Plug 'airblade/vim-rooter'
Plug 'ojroques/nvim-hardline'
Plug 'mbbill/undotree'
"---
"file browser
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'LnL7/vim-nix'

"====
""language support:
Plug 'adelarsq/neofsharp.vim' 
Plug 'ionide/Ionide-vim', {
      \ 'do':  'make fsautocomplete',
      \}

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
