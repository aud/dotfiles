set nocompatible

" Remap leader to ,
let mapleader=","

" Security
set modelines=0

" Display line numbers
set number

" Display ruler on status line
set ruler

" Encoding UTF
set encoding=utf-8

" Highlight search matches
set hlsearch

" Start searching immediately
set incsearch

" Case sensitive searches
set ignorecase
set smartcase

" Highlight matching braces
set showmatch

" Text wrapping
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motions
set scrolloff=3
set backspace=indent,eol,start

" Hidden buffers
set hidden

" Vim fast rendering
set ttyfast

" Always display status line
set laststatus=2

" Vim lightline already displays mode, remove the superfluous default text
set noshowmode

" Display command output
set showcmd

" Set tabstop/shiftwidth to 4 for Go
autocmd Filetype go setlocal ts=4 sw=4

" Remap ESC to kj
inoremap kj <Esc>

" Remap tab pane switching to ctrl
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Remap keys for vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>

" FZF remappings
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>f :Files<CR>

" Plug
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'janko-m/vim-test'
Plug 'craigemery/vim-autotag'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-eunuch'
Plug 'danchoi/ri.vim'
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" vim-test output to vimux
let test#strategy = 'vimux'

" Custom aliases
" Replace all matches in project. Syntax: ReplaceAll foo bar
command! -nargs=+ ReplaceAll :call ReplaceFunc(<f-args>)
function! ReplaceFunc(arg1, arg2)
  execute "vimgrep /" . a:arg1 . "/gj **/* | cfdo %s/" . a:arg1 . "/" . a:arg2 . "/g | update"
endfunction

" Strip trailing whitespace automatically
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Set lightline colorscheme and display full path
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
      \ }
      \ }

" Set 256 colors
set t_Co=256
set termguicolors
let g:onedark_termcolors=256
syntax on
set background=dark
colorscheme onedark
