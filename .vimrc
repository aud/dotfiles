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

" Remap gq to gw (LSP overrides formatexpr, breaking gq for text wrapping)
nnoremap gq gw
xnoremap gq gw

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

" =====================================
" Plugin mgmt
" =====================================
lua <<EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
  { 'junegunn/fzf', build = './install --all', commit = '18315000185a6e6461b9b4aa4a4cb6cd164e0e35' },
  { 'ibhagwan/fzf-lua', commit = '9f0432fdd7825ab163520045831a40b6df82ea28' },
  { 'tpope/vim-commentary', commit = '64a654ef4a20db1727938338310209b6a63f60c9' },
  { 'janko-m/vim-test', commit = '6eb2e5e7b32c321d373d2954199f4510be804713' },
  { 'benmills/vimux', commit = 'd6cb7f63a8bb428ffc27060b7f83c77fb115589c' },
  { 'christoomey/vim-tmux-navigator', commit = 'e41c431a0c7b7388ae7ba341f01a0d217eb3a432' },
  { 'aud/strip-trailing-whitespace.vim', commit = '83c4f33272cb555e49b12befc99577df0c18a63d' },
  { 'justinmk/vim-dirvish', commit = '6be56227a4207c93cd8b607f52f567a1e13dddb1' },
  { 'roginfarrer/vim-dirvish-dovish', commit = '04c77b6010f7e45e72b4d3c399c120d42f7c5d47' },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
      local parsers = {
        "bash", "c", "cpp", "css", "diff", "git_config", "git_rebase",
        "gitcommit", "gitignore", "go", "html", "javascript", "json",
        "lua", "markdown", "markdown_inline", "python", "regex", "ruby",
        "rust", "sql", "toml", "typescript", "vim", "yaml",
      }
      local installed = require('nvim-treesitter.config').get_installed()
      local to_install = vim.iter(parsers):filter(function(p)
        return not vim.tbl_contains(installed, p)
      end):totable()
      if #to_install > 0 then
        require('nvim-treesitter').install(to_install)
      end
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main', commit = '93d60a475f0b08a8eceb99255863977d3a25f310' },
  { 'RRethy/nvim-treesitter-endwise', commit = '8fe8a95630f4f2c72a87ba1927af649e0bfaa244' },
  { 'Wansmer/treesj', commit = '26bc2a8432ba3ea79ed6aa346fba780a3d372570' },
  { 'ibhagwan/smartyank.nvim', commit = 'c4e53e0d9316ca790a6f5d78aad73206a763873b' },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    commit = '334d5fd49fc8033f26408425366c66c6390c57bb',
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
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
        inverse = true,
        contrast = "",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.o.background = "dark"
      vim.cmd.colorscheme('gruvbox')
    end
  }
})
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
" Lsp
" =====================================
lua <<EOF
vim.lsp.config('ruby-lsp', {
  cmd = {'/Users/elliot/.gem/ruby/4.0.1/bin/ruby-lsp'},
  filetypes = {'ruby', 'eruby'},
})

vim.lsp.enable('ruby-lsp')

vim.lsp.config('copilot', {
  cmd = { 'bun', 'run', 'copilot-language-server', '--stdio' },
})

vim.lsp.enable('copilot')

vim.diagnostic.config({
  virtual_text = true,  -- Show errors inline
  signs = true,         -- Show signs in gutter (the red E)
  underline = true,     -- Underline errors
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})
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
  -- fzf_bin = "fzf-tmux",
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
