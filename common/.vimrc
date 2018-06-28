set nocompatible

" Remap leader to ,
let mapleader=","

" Security
set modelines=0

" Disable annoying fucking visual bell
set belloff=all

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

" Remap split switching
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Remap C-w-T to C-T (Move current in context split into a new tab)
nmap <C-T> <C-w>T

" Remap keys for vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>

" FZF remappings
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>f :Files<CR>

" Ripgrep remappings
nnoremap <leader>g :Rgrep<CR>

" " Moving around in insert mode
" inoremap <C-h> <C-o>h
" inoremap <C-l> <C-o>a
" inoremap <C-j> <C-o>j
" inoremap <C-k> <C-o>k

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
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-rails'
Plug 'ervandew/supertab'

" Typescript
Plug 'quramy/tsuquyomi'
call plug#end()

" Disable new line by default after choosing an option on tab completion with supertab
" let g:SuperTabCrMapping = 1

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

command! Run :call ExecuteByFileType()
function! ExecuteByFileType()
  let current_filetype = &filetype

  if current_filetype == 'ruby'
     execute '!clear && ruby %'
   elseif current_filetype == 'go'
     execute '!clear && go run %'
   elseif current_filetype == 'c'
     execute '!clear && clang % && ./a.out'
   else
     echo 'Unknown file type'
   end
endfunction

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

" source: https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Rgrep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Set lightline colorscheme and display full path
" let g:lightline = {
"       \ 'colorscheme': 'onedark',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
"       \ }
"       \ }

" Set 256 colors for dracula colour scheme
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" Paste without identation in insert more
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

set termguicolors
set t_Co=256
syntax on
color dracula
