set nocompatible

" Remap leader to ,
let mapleader=","

" Change netrw browser to tree
let g:netrw_liststyle = 3

" Disable netrw banner
let g:netrw_banner = 0

" Set scroll in all modes
set mouse=a

" Disable vim-go warning (https://github.com/fatih/vim-go/issues/2301)
let g:go_null_module_warning = 0

" Per default, netrw leaves unmodified buffers open. This autocommand deletes
" netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

set modelines=0

" 256 colours
set termguicolors

hi LineNr ctermbg=NONE guibg=NONE

" Disable warning message on swp files
set shortmess+=A

" Turn on syntax
syntax on

" Disable visual bell
set belloff=all

set backspace=indent,eol,start

" Increase vim pane resizing size, as the default is quite low.
nmap <C-w>+ :resize +15<CR>
nmap <C-w>- :resize -15<CR>
nmap <C-w>> :vertical resize +15<CR>
nmap <C-w>< :vertical resize -15<CR>

" Toggle line numbers
set invnumber
nmap <leader>L :set invnumber<CR>

" Highlight search matches
set hlsearch

" Start searching immediately
set incsearch

" Case sensitive searches
set ignorecase
set smartcase

" Highlight matching braces
set showmatch

" Hidden buffers
set hidden

" Vim fast rendering
set ttyfast

" Display command output
set showcmd

" Indentation rules
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Set tabstop/shiftwidth to 4 for Go
autocmd Filetype go setlocal ts=4 sw=4

" Remap ESC to kj
inoremap kj <Esc>

" Remap keys for vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>

" FZF remappings
nnoremap <leader>f :Files<CR>

" Prefer tmux panes instead of vim
let g:fzf_prefer_tmux = 1

" Set fzf height to 20%
let g:fzf_layout = { 'down': '20%' }

" Install vim plug if not already installed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'janko-m/vim-test'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'tpope/vim-endwise', { 'for': 'ruby' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-eunuch'
Plug 'liuchengxu/space-vim-dark'
" Plug 'morhetz/gruvbox'
" Plug 'dracula/vim'
" Plug 'nlknguyen/papercolor-theme'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif
call plug#end()

let g:LanguageClient_echoProjectRoot = 0
let g:LanguageClient_serverCommands = {
      \ 'ruby': ['solargraph',  'stdio'],
      \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
      \ 'javascript.jsx': ['/usr/local/bin/javascript-typescript-stdio'],
      \ 'typescript': ['/usr/local/bin/javascript-typescript-stdio'],
      \ 'typescript.tsx': ['/usr/local/bin/javascript-typescript-stdio'],
      \ }
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

" Only use deoplete in neovim
if has('nvim')
  let g:deoplete#enable_at_startup = 1
  call deoplete#custom#option('auto_complete', v:false)

  " Open deoplete on tab
  function! s:is_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction
  inoremap <silent><expr> <tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>is_back_space() ? "\<tab>" :
        \ deoplete#mappings#manual_complete()
endif

" vim-test output to vimux
let test#strategy = 'vimux'

" let g:dracula_italic = 0
" color dracula

colorscheme space-vim-dark
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE

" color gruvbox
" colorscheme PaperColor

" Change dashed seperator to line. This needs to run after the colorscheme is
" set, otherwise it will be clobbered.
set fillchars+=vert:│
hi VertSplit ctermbg=NONE guibg=NONE cterm=NONE

" Strip trailing whitespace automatically
function! <SID>StripTrailingWhitespaces()
  let _s=@/
  let l = line(".")
  let c = col(".")

  %s/\s\+$//e

  let @/=_s
  call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Custom strategy for vim-test to allow jest to recognize `debugger`.
" More specifically, this prefixes the jest call with node inspect,
" then resets after the test is complete.
command! TestDebug :call ExecuteTestDebug()
function! ExecuteTestDebug()
  let jest = test#javascript#jest#executable()
  let g:test#javascript#jest#executable = 'node inspect ' . jest

  execute ':TestNearest'

  let g:test#javascript#jest#executable = jest
endfunction

" Disable status bar by default, as it's rarely useful.
nnoremap <leader>S :call ToggleStatusBar()<CR>
let g:statusHidden = 0

set laststatus=0
set noruler

function! ToggleStatusBar()
  if g:statusHidden
    let g:statusHidden = 0

    set laststatus=0
    set noruler
  else
    let g:statusHidden = 1

    set laststatus=2
    set ruler
  endif
endfunction

" Use ripgrep for fzf and alias to <leader>g. Modified version of:
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Rgrep call fzf#vim#grep(s:rgoptions.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
nnoremap <leader>g :Rgrep<CR>
let s:rgoptions='rg
      \ --column
      \ --line-number
      \ --no-heading
      \ --fixed-strings
      \ --ignore-case
      \ --hidden
      \ --follow
      \ --glob "!.git/*"
      \ --color "always" '
