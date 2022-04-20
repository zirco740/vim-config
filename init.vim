set number
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
set guifont=VictorMono\ Nerd\ Font:h13.5
set showtabline=2
set termguicolors
set encoding=utf-8
syntax on

call plug#begin('~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig' "nvim-lspconfig
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'} "coq-auto-completion
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'} "coq-snippets
Plug 'morhetz/gruvbox' "Gruvbox
Plug 'sts10/vim-pink-moon' "Pinkmoon
Plug 'MunifTanjim/nui.nvim' "NeoVim UI
Plug 'http://github.com/tpope/vim-surround' " Surrounding
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'kyazdani42/nvim-web-devicons' "Developer Icons
Plug 'kyazdani42/nvim-tree.lua' "Tree
Plug 'nvim-lualine/lualine.nvim' "Status bar
Plug 'andweeb/presence.nvim' "Discord Presence
Plug 'akinsho/bufferline.nvim' "Bufferline
Plug 'famiu/bufdelete.nvim' "Keep Buffer Layout
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'mg979/vim-visual-multi' "Multiple cursors
Plug 'jiangmiao/auto-pairs' " Auto Pairs 
Plug 'github/copilot.vim' "Copilot
Plug 'https://github.com/sbdchd/neoformat' "formatter
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' } "Regular scrollbar
Plug 'rcarriga/nvim-notify' "Notification
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim' "Asynchronous Programming
Plug 'nvim-telescope/telescope.nvim' "Telescope
Plug 'puremourning/vimspector' "vimspector
if has('nvim') "command fuzzy
  function! UpdateRemotePlugins(...)
    "Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction
  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'
endif
call plug#end()

"===Themes and Visuals===

colorscheme gruvbox
highlight Comment gui=italic cterm=italic

"Line Number Bold
set cursorline
set cursorlineopt=number
autocmd ColorScheme * highlight CursorLineNr cterm=bold gui=bold

"Neovide
let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_remember_window_size = v:true
let g:neovide_transparency=0.9
let g:neovide_cursor_antialiasing=v:true

"===Plugin Variables===

"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()

"Coq
let g:coq_settings = { 'auto_start': 'shut-up' }

"Wilder
call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'next_key': '<Tab>',
      \ 'previous_key': '<S-Tab>',
      \ 'accept_key': '<Down>',
      \ 'reject_key': '<Up>',
      \ })
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ 'left': [
	  \   ' ', wilder#popupmenu_devicons(),
      \ ],
      \ 'right': [
      \   ' ', wilder#popupmenu_scrollbar(),
      \ ],
      \ }))

"CHADTree


"Neoformat
let g:neoformat_enabled_cpp = ['astyle']

"Vimspector
let g:vimspector_base_dir= '/Users/zirco740/.config/nvim/plugged/vimspector'

"===Lua===
lua << END

require('lualine').setup{
options = {
	theme = 'auto',
	globalstatus = true,
	},
extensions = {
	'nvim-tree'
	},
sections = {
    lualine_a = {'mode'},
	lualine_b = {'branch', {'diff', symbols = {added = ' ', modified = ' ', removed = ' '}}, 'diagnostics'},
    lualine_c = {{'filename',
	path = 2,
	symbols = {
        modified = ' ',
        readonly = ' ',      
        unnamed = '[No Name]'
		}},{'filesize',icons_enabled = true, icon = ''}},
	lualine_x = {'encoding', 'fileformat', 'filetype'},
	lualine_y = {{'progress',icons_enabled = true, icon = 'ﮆ'}},
    lualine_z = {{'location',icons_enabled = true,icon = ''}}
	}
}
require('bufferline').setup{
options = {
close_command = function(bufnum)
   require('bufdelete').bufdelete(bufnum, true)
end,
diagnostics = "nvim_lsp",
diagnostics_update_in_insert = false,
numbers = function(opts)
 return string.format('%s|%s ', opts.id, opts.raise(opts.ordinal))
end,
 }
}
require('nvim-tree').setup{
 renderer = {
    indent_markers = {
      enable = true,
	   },
   },
}
require('nvim-treesitter.configs').setup {
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
}
require('telescope').setup{}
require('telescope').load_extension('notify')
require('notify').setup{
  timeout =4000,
}
vim.notify = require("notify")
local Path = require('plenary.path')
local coq = require "coq"
require'lspconfig'.clangd.setup(coq.lsp_ensure_capabilities())
local signs = { Error = "", Warn = "", Hint =  "ﯦ", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
END

"===Extra Functions===

"Config Reload On Write 
augroup myvimhooks
    au!
	autocmd! BufWritePost $MYVIMRC source $MYVIMRC | lua require('notify')("init.vim is reloaded.")
augroup END

"Format on Write
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

"Auto Change Directory
autocmd BufEnter * silent! lcd %:p:h

"Restore Cursor Shape
autocmd VimLeave * set guicursor=a:ver90

"Tree Auto Close
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

"===Keybindings===

"Telescope
inoremap <C-f> :Telescope current_buffer_fuzzy_find<CR>
nnoremap <C-f> :Telescope current_buffer_fuzzy_find<CR>

"Notification
nnoremap <f3> :Telescope<CR>

"Tree
nnoremap <f2> :NvimTreeToggle<CR>

"Buffer
nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
nnoremap <silent><leader>8 <Cmd>BufferLineGoToBuffer 8<CR>
nnoremap <silent><leader>9 <Cmd>BufferLineGoToBuffer 9<CR>

"Copilot
let g:copilot_no_tab_map = v:true 
inoremap <silent><script><expr> <C-\> copilot#Accept("\<CR>")

"Vimspector
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
nmap <Leader>di <Plug>VimspectorBalloonEval
xmap <Leader>di <Plug>VimspectorBalloonEval
nmap <Leader>db <Plug>VimspectorBreakpoints
