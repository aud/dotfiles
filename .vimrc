set nocompatible

" Remap leader to ,
let mapleader=","

" Change netrw browser to tree
" let g:netrw_liststyle = 3

" Disable netrw banner
" let g:netrw_banner = 0

" Set scroll in all modes
set mouse=a

" Per default, netrw leaves unmodified buffers open. This autocommand deletes
" netrw's buffer once it's hidden (using ':q', for example)
" autocmd FileType netrw setl bufhidden=delete

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
Plug 'tpope/vim-eunuch'
" Plug 'liuchengxu/space-vim-dark'
" Plug 'rakr/vim-one'
" Plug 'morhetz/gruvbox'
" Plug 'dracula/vim'
" Plug 'nlknguyen/papercolor-theme'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'andrewradev/splitjoin.vim'
" Plug 'ajmwagar/vim-deus'
" Plug 'sainnhe/sonokai'

" Plug 'joshdick/onedark.vim'
" Plug 'yashguptaz/calvera-dark.nvim'
" Plug 'sainnhe/everforest'
" Plug 'marko-cerovac/material.nvim'

Plug 'morhetz/gruvbox'

" Plug 'Rigellute/shades-of-purple.vim'
Plug 'aud/strip-trailing-whitespace.vim'
Plug 'rhysd/git-messenger.vim'

" TypeScript
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" Plug 'Shougo/deoplete.nvim'
" Plug 'Shougo/denite.nvim'

Plug 'justinmk/vim-dirvish'
Plug 'roginfarrer/vim-dirvish-dovish', {'branch': 'main'}

Plug 'neovim/nvim-lspconfig'
" Test the LSP UI thing
Plug 'glepnir/lspsaga.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Test out Github Copilot
Plug 'github/copilot.vim'
call plug#end()

" https://github.com/rhysd/git-messenger.vim#ggit_messenger_always_into_popup-default-vfalse
let g:git_messenger_always_into_popup = v:true

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

syntax enable


" " For dark version.
" set background=dark
" " For light version.
" " set background=light
" " Set contrast.
" " This configuration option should be placed before `colorscheme everforest`.
" " Available values: 'hard', 'medium'(default), 'soft'
" let g:everforest_background = 'hard'
" colorscheme everforest

" let g:material_style = 'oceanic'
" " let g:material_style = 'darker'
" let g:material_italic_comments = 1
" let g:material_italic_keywords = 1
" let g:material_italic_functions = 1
" let g:material_contrast = 1
" colorscheme material

set background=dark
colorscheme gruvbox

if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Change dashed seperator to line. This needs to run after the colorscheme is
" set, otherwise it will be clobbered.
set fillchars+=vert:│

" Custom strategy for vim-test to allow jest to recognize `debugger`.
command! TestDebug :call ExecuteTestDebug()
function! ExecuteTestDebug()
  let jest = test#javascript#jest#executable()
  let g:test#javascript#jest#executable = 'node inspect ' . jest

  execute ':TestNearest'

  let g:test#javascript#jest#executable = jest
endfunction


" Handle portal
let parent_cwd = split(getcwd(), "/")[-1]
if parent_cwd == "help"
  let g:test#ruby#minitest#executable = "components/portal/bin/rails test"
  let g:test#ruby#rails#executable = "components/portal/bin/rails test"
endif


" Temp disable gopls
let g:go_gopls_enabled = 0

" Disable status bar by default, as it's rarely useful.
nnoremap <leader>S :call ToggleStatusBar()<CR>
let g:status_hidden = 0

set laststatus=2
set noruler

function! ToggleStatusBar()
  if g:status_hidden
    let g:status_hidden = 0
    set laststatus=0
  else
    let g:status_hidden = 1
    set laststatus=2
  endif
endfunction

" fzf remappings
nnoremap <leader>f :Files<CR>

" Prefer tmux panes instead of vim
let g:fzf_prefer_tmux = 1

" Disable preview window (for builtin :Files command)
let g:fzf_preview_window = ''

" Set fzf height to 20%
let g:fzf_layout = { 'down': '20%' }

autocmd FileType typescript setlocal ts=2 sts=2 sw=2
au BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

function! RgContents(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --ignore-case --hidden %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, options, a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RgContents(<q-args>, <bang>0)
nnoremap <leader>g :Rg<CR>

" Dirvish aliases
let g:loaded_netrwPlugin = 1
command Explore execute "normal \<Plug>(dirvish_up)"
command Exp execute "normal \<Plug>(dirvish_up)"
command Ex execute "normal \<Plug>(dirvish_up)"

" Treesitter config
lua <<EOF
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  }
}
EOF

" LSP config
lua << EOF
local nvim_lsp = require('lspconfig')
nvim_lsp.tsserver.setup {}
nvim_lsp.solargraph.setup{}


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "solargraph", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 100,
    }
  }
end
EOF
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> gs :Lspsaga signature_help<CR>
