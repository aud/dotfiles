" =====================================
" Basic config
" =====================================
set nocompatible

" Set scroll in all modes
set mouse=a

set modelines=0

" 256 colours
set termguicolors

hi LineNr ctermbg=NONE guibg=NONE

" Disable warning message on swp files
set shortmess+=A

" Disable visual bell
set belloff=all

set backspace=indent,eol,start

" Toggle line numbers
set invnumber

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

syntax enable

let g:status_hidden = 2
set noruler
set laststatus=2

autocmd FileType typescript setlocal ts=2 sts=2 sw=2
au BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

" =====================================
" Key mappings
" =====================================

" Remap leader to ,
let mapleader=","

" Remap ESC to kj
inoremap kj <Esc>

" Remap W to w
command! W w
" Remap Noh to noh
command! Noh noh

" Remap keys for vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>

" ,L to toggle line numbers
nmap <leader>L :set invnumber<CR>

" Increase vim pane resizing size, as the default is quite low.
nmap <C-w>+ :resize +15<CR>
nmap <C-w>- :resize -15<CR>
nmap <C-w>> :vertical resize +15<CR>
nmap <C-w>< :vertical resize -15<CR>

" Fzf-lua remappings
nnoremap <leader>f :lua require("fzf-lua").files()<CR>
nnoremap <leader>g :lua require("fzf-lua").grep_project()<CR>
command! Buffers :lua require("fzf-lua").buffers()<CR>

" Remap gS to toggle split/join
nnoremap gS :TSJToggle<CR>

" Disable status bar by default, as it's rarely useful.
nnoremap <leader>S :call ToggleStatusBar()<CR>

" Custom strategy for vim-test to allow jest to recognize `debugger`.
command! TestDebug :call ExecuteTestDebug()

" Dirvish aliases
let g:loaded_netrwPlugin = 1
command Explore execute "normal \<Plug>(dirvish_up)"
command Exp execute "normal \<Plug>(dirvish_up)"
command Ex execute "normal \<Plug>(dirvish_up)"

" =====================================
" Custom funcs
" =====================================

function! ToggleStatusBar()
  if g:status_hidden
    let g:status_hidden = 0
    set laststatus=0
  else
    let g:status_hidden = 1
    set laststatus=2
  endif
endfunction

" llama.vim
" https://github.com/ggml-org/llama.vim/blob/master/doc/llama.txt
" let g:llama_config = { "show_info": 0 }

" =====================================
" Plugin mgmt
" =====================================
lua <<EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable", -- latest stable release
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { 'junegunn/fzf', build = './install --all' },
  'ibhagwan/fzf-lua',
  'tpope/vim-commentary',
  'janko-m/vim-test',
  'benmills/vimux',
  'christoomey/vim-tmux-navigator',
  'aud/strip-trailing-whitespace.vim',
  'justinmk/vim-dirvish',
  { 'roginfarrer/vim-dirvish-dovish', branch = 'main' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'RRethy/nvim-treesitter-endwise',
  'Wansmer/treesj',
  'ibhagwan/smartyank.nvim',

  { 'github/copilot.vim', branch = 'release' },

  -- Theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
    opts = ...,
  }
})
EOF

" MITM debug
" let g:copilot_proxy = 'http://localhost:8080'
" let g:copilot_proxy_strict_ssl = v:false
let g:copilot_settings = #{ selectedCompletionModel: 'gpt-4o-copilot' }
let g:copilot_integration_id = 'vscode-chat'

" =====================================
" Theme
" =====================================

lua <<EOF
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")
EOF

" Change dashed seperator to line. This needs to run after the colorscheme is
" set, otherwise it will be clobbered.
set fillchars+=vert:│

" =====================================
" Plugin configuration
" =====================================

" git-messenger:
"
" https://github.com/rhysd/git-messenger.vim#ggit_messenger_always_into_popup-default-vfalse
let g:git_messenger_always_into_popup = v:true

" vim-test:
"
" Output to vimux
let test#strategy = 'vimux'

" =====================================
" Treesitter config
" =====================================
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",

  ignore_install = { "norg" },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
  },

  endwise = {
    enable = true,
  },
}
EOF

lua <<EOF
-- =====================================
-- Smartyank
-- =====================================
-- https://github.com/ibhagwan/smartyank.nvim
require('smartyank').setup({
  highlight = {
    enabled = false,
  },
})
EOF

lua <<EOF
-- =====================================
-- Treesitter [splitjoin]
-- =====================================
require('treesj').setup({
  max_join_length = 500,
})
EOF

lua <<EOF
-- =====================================
-- Fzf lua
-- =====================================
require("fzf-lua").setup({
  fzf_bin = "fzf-tmux",
  -- Docs: `fzf-tmux --help`
  fzf_tmux_opts = {
    -- We need to reset `-p`, as the default from the fzf-lua plugin conflicts
    -- when the `-d` option is set. See
    -- https://github.com/ibhagwan/fzf-lua/issues/865
    ["-p"] = false,
    ["-d"] = "20%",
  },
  winopts = {
    preview = {
      hidden = "hidden"
    }
  },
  -- https://github.com/ibhagwan/fzf-lua/wiki#how-do-i-get-maximum-performance-out-of-fzf-lua
  files = {
    git_icons = false,
    file_icons = false,
  }
})
EOF

lua <<EOF
-- Ensure we reset the cursor to blinking line on exit. Otherwise we get into
-- a weird case where the bar seems to clobber the $TERM (ghostty) bar.
vim.api.nvim_create_autocmd("VimLeave", {
  command = "set guicursor=a:ver25-blinkon1"
})
EOF
