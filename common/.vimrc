" This is in response to issue: https://github.com/vim/vim/issues/3117. Vim
" version `8.1.0150` builds with Python 3, and uses the `imp` Python module,
" which was deprecated in Python 3.4 in favour of `importlib`. As a result of
" this deprecation, everytime vim is started this error appears:
" ============================================================================
" Error detected while processing
" /Users/elliotdohm/.vim/plugged/vim-autotag/plugin/autotag.vim:
" DeprecationWarning: the imp module is deprecated in favour of importlib; see
" the module's documentation for alternative uses
" ============================================================================
" This is pretty annoying, so this silences it if vim is build with Python 3.
" Once this is fixed upstream, this hack should be removed.
if has('python3')
  silent! python3 1
endif

set nocompatible

" Remap leader to ,
let mapleader=","

" Security
set modelines=0

" 256 colours
set termguicolors
set t_Co=256

" Turn on syntax
syntax on

" Disable annoying fucking visual bell
set belloff=all

" Increase vim pane resizing size, as the default is quite low.
nmap <C-w>+ :resize +10<CR>
nmap <C-w>- :resize -10<CR>
nmap <C-w>> :vertical resize +10<CR>
nmap <C-w>< :vertical resize -10<CR>

" Temporarily disable, screen space is valuable!
" Display line numbers
" set number

" Toggle line numbers
nmap <leader>L :set invnumber<CR>

" Display ruler on status line
" set ruler

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

" FIXME: This doesn't work.
" Remap C-w-T to C-T (Move current in context split into a new tab)
" inoremap <C-T> <C-w>T

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
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise', { 'for': 'ruby' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-eunuch'
Plug 'danchoi/ri.vim', { 'for': 'ruby' }
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'andrewradev/splitjoin.vim'

" Typescript
Plug 'quramy/tsuquyomi', { 'for': 'typescript' }
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
    let _s=@/
    let l = line(".")
    let c = col(".")

    %s/\s\+$//e

    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Quick execution commands for commonly used filetypes.
command! Run :call ExecuteByFileType()
function! ExecuteByFileType()
  let currentFileType = &filetype

  if currentFileType == 'ruby'
     execute '!clear && ruby %'
   elseif currentFileType == 'go'
     execute '!clear && go run %'
   elseif currentFileType == 'c'
     execute '!clear && clang % && ./a.out'
   elseif currentFileType == 'cpp'
     execute '!clear && g++ % -o output && ./output'
   elseif currentFileType == 'lua'
     execute '!clear && lua %'
   else
     echo 'Unknown file type. Reminder: If commonly used, add to vimrc.'
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

" Basic tab autocomplete instead of using a third party package, like Supertab.
imap <tab> <c-r>=InsertTabWrapper()<cr>
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

" Disable status bar by default, as it's rarely useful.
nnoremap <leader>S :call ToggleStatusBar()<CR>
let s:statusHidden = 0
function! ToggleStatusBar()
    if s:statusHidden == 0
        let s:statusHidden = 1

        set laststatus=0
        set noruler
    else
        let s:statusHidden = 0

        set laststatus=2
        set ruler
    endif
endfunction

" Paste without identation in insert mode.
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" Use ripgrep for fzf and alias to <leader>g. Credit to:
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Rgrep call fzf#vim#grep(s:rgoptions.shellescape(<q-args>), 1, <bang>0)
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

" Set 256 colors for dracula colour scheme
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

color dracula
