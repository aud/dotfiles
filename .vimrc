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
nmap <C-w>+ :resize +15<CR>
nmap <C-w>- :resize -15<CR>
nmap <C-w>> :vertical resize +15<CR>
nmap <C-w>< :vertical resize -15<CR>

" Toggle line numbers
set invnumber
nmap <leader>L :set invnumber<CR>

" Encoding UTF
set encoding=utf-8

" Change dotted split seperator to solid line.
set fillchars+=vert:│

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

" Remap keys for vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>

" FZF remappings
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>f :Files<CR>

" Prefer tmux panes instead of vim
let g:fzf_prefer_tmux = 1

" Set fzf height to 20%
let g:fzf_layout = { 'down': '20%' }

" Map to fold everything except current visual selection into folds.
vnoremap <leader>zz <Esc>`<kzfgg`>jzfG`<

" Map to unfold all active folds in file.
nmap <leader>zZ <Esc>zRzz

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
Plug 'tpope/vim-obsession'

" Tsuquyomi doesn't talk to TsServer using jobs (vim 8), so any compiler checks
" are often pretty slow as they are not async. For example, this was after
" browsing a couple files:
" count  total (s)   self (s)  function
" 13  5.084426   4.754910  tsuquyomi#tsClient#sendRequest()
" 3   4.772378   0.000136  tsuquyomi#reloadAndGeterr()
" 3   4.772092   0.000148  tsuquyomi#geterr()
" 3   4.771944   0.000648  tsuquyomi#createFixlist()
" 4   4.549294   0.000810  tsuquyomi#tsClient#sendCommandSyncEvents()
" 3   4.547639   0.000237  tsuquyomi#tsClient#tsGeterr()
" Plug 'quramy/tsuquyomi', { 'for': 'typescript' }

Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }
call plug#end()

" Register lsp for typescript-language-server
" (https://github.com/theia-ide/typescript-language-server)
if executable('typescript-language-server')
  let g:LanguageClient_serverCommands = {
        \ 'typescript': ['typescript-language-server', '--stdio']
        \ }

  " Alias for language definition lookup.
  nnoremap <leader>Ld :call LanguageClient_textDocument_definition()<cr>

  " 0.5 seconds delay of `textDocument_didChange` before text is sent to the
  " language server. Sending the entire document everytime the document is
  " changed causes some slowdown in vim, and is unnecessary.
  let g:LanguageClient_changeThrottle = 0.5

  " Completely remove the gutter, resizing is distracting and the optional
  " quickfix list is a much less intrusive workflow.
  let g:LanguageClient_diagnosticsSignsMax = 0
endif

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

" Create file (&&|| directories recursively) relative to the current working
" directory. This is an alternative to the `autochdir` vim setting, which isn't
" ideal when attempting to open files outside of the relative directory.
command! -nargs=1 Cwd :call NewFileInCwd(<q-args>)
function! NewFileInCwd(path)
  let cwd = expand('%:h')
  let path = a:path

  let splitArgs = split(path, '/')

  if len(splitArgs) == 1
    let name = splitArgs[0]
    let cmd = 'e ' . cwd . '/' . name
  else
    let name = splitArgs[-1]

    " Extract all arguments except for last elm and join back into list.
    let pathToBeCreated = join(splitArgs[0:-2], '/')
    let dirFullPathToBeCreated = cwd . '/' . pathToBeCreated

    if !isdirectory(dirFullPathToBeCreated)
      call mkdir(dirFullPathToBeCreated, 'p')
    end

    let cmd = 'e ' . dirFullPathToBeCreated . '/' . name
  end

  execute cmd
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

" Swap splits, credit to: https://stackoverflow.com/a/4903681/
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction
noremap <silent> <leader>mw :call MarkWindowSwap()<CR>
noremap <silent> <leader>pw :call DoWindowSwap()<CR>

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
