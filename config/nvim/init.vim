source $HOME/.config/nvim/plugSetup.vim
source $HOME/.config/nvim/colemak.vim
" Persistent undo
if has('persistent_undo')
        let vimDir= expand("~/.vim")
  if !isdirectory(vimDir)
        call mkdir(vimDir)
  endif
  " Just make sure you don't run 'sudo vim' right out of the gate and make
  " ~/.vim/undos owned by root.root (should probably use sudoedit anyhow)
  let swap_base = expand("~/.vim/swap")
  if !isdirectory(swap_base)
    call mkdir(swap_base)
  endif
  let userDir = expand("~/.vim/swap/$USER")
  if !isdirectory(userDir)
    call mkdir(userDir)
  endif

  let undoDir = expand("~/.vim/swap/$USER/undo")
  if !isdirectory(undoDir)
    call mkdir(undoDir)
  endif
  
  let backupDir = expand("~/.vim/swap/$USER/backup")
  if !isdirectory(backupDir)
    call mkdir(backupDir)
  endif
  set undodir=~/.vim/swap/$USER/undo
  set undofile
  set backupdir=~/.vim/swap/$USER/backup
  set backup
endif

set clipboard+=unnamedplus
if exists('g:vscode')
nmap cqp :call VSCodeNotify('calva.jackIn')<CR>
nmap cqq :call VSCodeNotify('calva.disconnect')<CR>
nmap cpr :call VSCodeNotify('calva.loadFile')<CR>
nmap cpR :call VSCodeNotify('calva.loadNamespace')<CR>
nmap cpp :call VSCodeNotify('calva.evaluateSelection')<CR>
nmap cqc :call VSCodeNotify('calva.evalCurrentFormInREPLWindow')<CR>
endif

set nocompatible

if has('termguicolors')
  set termguicolors
endif

"let g:edge_style = 'aura'
"let g:edge_enable_italic = 1
"let g:edge_disable_italic_comment = 1
"colorscheme edge

colorscheme gruvbox-material
let g:gruvbox_material_palette ='original'

"set background=dark " or light if you want light mode
"colorscheme gruvbox
"let g:gruvbox_contrast_dark = 'hard'
syntax enable
filetype plugin indent on

set nu rnu
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set expandtab
set smartindent
set tabstop=4 softtabstop=4
set cmdheight=2
set updatetime=50
set signcolumn=yes

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" -------------------- LSP ---------------------------------
:lua require('myComplete')

" Completion
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" -------------------- LSP ---------------------------------
" ------===My custom stuff:===--------
let mapleader = " " " map leader to Space

autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp
"-------fuzzy finder------
" Find files using Telescope command-line sugar.
lua require'telescope'.load_extension('project')
nnoremap <leader>fp <cmd>Telescope project<cr>
nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fl <cmd>Telescope git_files<cr>
"------fileTree--------
nnoremap <leader>tt :NvimTreeToggle<CR>
nnoremap <leader>tr :NvimTreeRefresh<CR>
nnoremap <leader>tn :NvimTreeFindFile<CR>
" NvimTreeOpen and NvimTreeClose are also available if you need them
"lspSettings:
"-------vim roooter'------
"patters for finding the project root
let g:rooter_patterns = ['.git', 'Makefile', '*.sln', 'build/env.sh','*.fsproj','*.csproj',"cargo.toml"]


lua require('hardline').setup {}
"-----undoTree----
nnoremap <F5> :UndotreeToggle<CR>
"
autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
