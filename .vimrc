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

let g:status_hidden = 0
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

function! ExecuteTestDebug()
  let jest = test#javascript#jest#executable()
  let g:test#javascript#jest#executable = 'node inspect ' . jest

  execute ':TestNearest'

  let g:test#javascript#jest#executable = jest
endfunction

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
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'ibhagwan/fzf-lua'
Plug 'tpope/vim-commentary'
Plug 'janko-m/vim-test'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'aud/strip-trailing-whitespace.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'rebelot/kanagawa.nvim'
Plug 'justinmk/vim-dirvish'
Plug 'roginfarrer/vim-dirvish-dovish', {'branch': 'main'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'RRethy/nvim-treesitter-endwise'
Plug 'Wansmer/treesj'
Plug 'ibhagwan/smartyank.nvim'

" LSP config.. Again
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Autocompletion
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

" Manager for LSP
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'williamboman/mason.nvim'

" Copilot
Plug 'zbirenbaum/copilot.lua'
Plug 'zbirenbaum/copilot-cmp'
call plug#end()

" =====================================
" Theme
" =====================================
lua <<EOF
require('kanagawa').setup({
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  }
})

vim.cmd("colorscheme kanagawa")
EOF
" vim.g.lua_embark_transparent = true
" vim.cmd("colorscheme lua-embark")

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
" Pass in config for vitest
let test#javascript#vitest#options = '--config=config/vitest.config.ts'

" =====================================
" Treesitter config
" =====================================
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",

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
-- LSP config
-- =====================================
local lang_servers = {
  'tsserver',
  'ruby_ls',
  'terraformls',
  'bashls',
  'cssls',
  'gopls',
  'vimls',
  'sqlls',
  'jsonls',
  'graphql',
  'dockerls',
  'clangd',
  'yamlls',
}

-- Configure Mason
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = lang_servers
})

-- Configure lspconfig
local lspconfig = require('lspconfig')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

-- =====================================
-- Copilot
-- =====================================
require('copilot_cmp').setup()

require('copilot').setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

-- =====================================
-- Smartyank
-- =====================================
-- https://github.com/ibhagwan/smartyank.nvim
require('smartyank').setup({
  highlight = {
    enabled = false,
  },
})

-- =====================================
-- Cmp [tab complete]
-- =====================================
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
  -- Disable lsp formatexpr (use the internal one)
  -- This allows `gq` to work when the lsp is attached
  vim.opt.formatexpr = ""
end

-- Finally, setup each lang server
for _, lsp in ipairs(lang_servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end
EOF

lua <<EOF
-- =====================================
-- Treesitter [splitjoin]
-- =====================================
require('treesj').setup({
  max_join_length = 120,
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
