set nocompatible

" Remap leader to ,
let mapleader=","

" Change netrw browser to tree
let g:netrw_liststyle = 3

" Disable netrw banner
let g:netrw_banner = 0

" Set scroll in all modes
set mouse=a

" Per default, netrw leaves unmodified buffers open. This autocommand deletes
" netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

" Auto update cwd
" set autochdir

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
" Plug 'andrewradev/splitjoin.vim'

" TypeScript
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" Plug 'Shougo/deoplete.nvim'
" Plug 'Shougo/denite.nvim'
call plug#end()

" vim-test output to vimux
let test#strategy = 'vimux'

imap <tab> <c-r>=InsertTabWrapper()<cr>
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

" let g:dracula_italic = 1
" colorscheme dracula

colorscheme space-vim-dark
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE

" color gruvbox
" colorscheme PaperColor

" Change dashed seperator to line. This needs to run after the colorscheme is
" set, otherwise it will be clobbered.
set fillchars+=vert:│
" hi VertSplit ctermbg=NONE guibg=NONE cterm=NONE

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

" " Use sewing-kit runner in athena*
" let parent_cwd = split(getcwd(), '/')[-1]
" if parent_cwd == 'athena-flex' || parent_cwd == 'athena'
"   let g:test#javascript#jest#executable = "yarn run sewing-kit test --no-graphql --no-watch"
" endif

" Custom strategy for vim-test to allow jest to recognize `debugger`.
command! TestDebug :call ExecuteTestDebug()
function! ExecuteTestDebug()
  let jest = test#javascript#jest#executable()
  let g:test#javascript#jest#executable = 'node inspect ' . jest

  execute ':TestNearest'

  let g:test#javascript#jest#executable = jest
endfunction

" Temp disable gopls
let g:go_gopls_enabled = 0

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

" function! HandleCompletion()
"   call deoplete#enable()
"   set signcolumn=yes
" endfunction
" autocmd FileType typescript call HandleCompletion()

" FZF remappings
nnoremap <leader>f :Files<CR>

" Prefer tmux panes instead of vim
let g:fzf_prefer_tmux = 1

" Disable preview window (for builtin :Files command)
let g:fzf_preview_window = ''

" Set fzf height to 20%
let g:fzf_layout = { 'down': '20%' }

function! RgContents(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --ignore-case --hidden %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, options, a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RgContents(<q-args>, <bang>0)
nnoremap <leader>g :Rg<CR>
