:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set guifont=VictorMono\ NF:h12
:set showtabline=2
:set termguicolors

call plug#begin('C:/Users/ZIRCO/AppData/Local/nvim/plugged')

Plug 'arcticicestudio/nord-vim' "nord
Plug 'ayu-theme/ayu-vim' "Ayu
Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'kyazdani42/nvim-web-devicons' "Developer Icons
Plug 'nvim-lualine/lualine.nvim' " Status bar
Plug 'akinsho/bufferline.nvim' "Bufferline
Plug 'famiu/bufdelete.nvim' "Keep Buffer Layout
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'voldikss/vim-floaterm' " Vim Terminal
Plug 'mg979/vim-visual-multi' "Multiple cursors
Plug 'jiangmiao/auto-pairs' " Auto Pairs
Plug 'neoclide/coc.nvim', {'branch': 'release'} "CoC
Plug 'github/copilot.vim' "Copilot
Plug 'weilbith/nvim-code-action-menu' "Code Action
Plug 'honza/vim-snippets' "Snippets
Plug 'https://github.com/sbdchd/neoformat' "formatter
Plug 'rcarriga/nvim-notify' "Notification
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim' "Asynchronous Programming
Plug 'nvim-telescope/telescope.nvim' "Telescope
Plug 'cdelledonne/vim-cmake' "CMake
Plug 'jbyuki/instant.nvim' "Collaboration
Plug 'sts10/vim-pink-moon' "Pink Theme
Plug 'dstein64/nvim-scrollview' "Scrollbar
Plug 'puremourning/vimspector' "vimspector
if has('nvim') "command fuzzy
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction
  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'
endif

call plug#end()

:set encoding=utf-8

"theme, visuals and neovide
colorscheme pink-moon
let ayucolor = "light"
let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_remember_window_size = v:true
let g:neovide_refresh_rate=144
let g:neovide_transparency=0.95
:highlight Comment gui=italic, cterm=italic

"command line
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



"lua
:lua << END
require('lualine').setup{
options = {theme = 'auto'},
sections = {
    lualine_a = {'mode'},
	lualine_b = {'branch', {'diff', symbols = {added = ' ', modified = ' ', removed = ' '}}, 'diagnostics'},
    lualine_c = {{'filename',symbols = {
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
diagnostics = "coc",
numbers = function(opts)
 return string.format('%s|%s ', opts.id, opts.raise(opts.ordinal))
end,
 }
}
require'nvim-treesitter.configs'.setup {
  sync_install = false,
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
}
require('telescope').setup{}
require('telescope').load_extension('notify')
require('notify').setup{
  timeout =4000,
}
vim.notify = require("notify")
local Path = require('plenary.path')
END


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

"CocExplorer
au VimEnter * CocCommand explorer --no-focus
"instant collab
let g:instant_username = "zirco740"

"Cmake
"set makeprg=cmake\ %:p:h


"KEYBINDINGS

"Change theme
function! ChangeTheme()
	if g:colors_name == 'nord'		
		:colorscheme pink-moon
        :highlight Comment gui=italic, cterm=italic
        :lua << END
		 local thch = "Theme Changed"
	     require('notify')("Current Theme: PINK MOON.")
END
	elseif g:colors_name == 'pink-moon'
		:colorscheme ayu
		:highlight Comment gui=italic, cterm=italic
        :lua << END
		 local thch = "Theme Changed"
	  require('notify')("Current Theme: AYU LIGHT.")
END
	elseif g:colors_name == 'ayu'
		:colorscheme nord 
		:highlight Comment gui=italic, cterm=italic
        :lua << END
		 local thch = "Theme Changed"
	  require('notify')("Current Theme: NORD.")
END
	endif
endfunction

nnoremap <silent> <f3> :call ChangeTheme() <Enter>
"Explorer
nnoremap <A-f> <Cmd>CocCommand explorer<CR>
"Telescope
inoremap <C-f> :Telescope current_buffer_fuzzy_find <Enter> 
nnoremap <C-f> :Telescope current_buffer_fuzzy_find <Enter> 
inoremap <C-f1> :Telescope keymaps <Enter>
nnoremap <C-f1> :Telescope keymaps <Enter>

"Notification
nnoremap <f2> :Telescope notify<CR>

"Fullscreen
function! Fullscreen()
    if g:neovide_fullscreen == v:false
	     :let g:neovide_fullscreen=v:true
	 elseif g:neovide_fullscreen == v:true
		 :let g:neovide_fullscreen=v:false
	 endif
 endfunction
nnoremap <silent> <f11> :call Fullscreen() <Enter>

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
inoremap <silent><script><expr> <C-Tab> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

"vimspector
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

"CMake
let g:cmake_default_config = 'Release'

"Create_project
"function! CreateProject()
"    if &filetype ==# 'c' || &filetype ==# 'cpp'
"		:CMake create_project
"	 endif
" endfunction
"nnoremap <silent> <f7> :call CreateProject() <Enter>

"Configure
"function! Configure()
"    if &filetype ==# 'c' || &filetype ==# 'cpp'
"		:CMake configure
"	 endif
" endfunction
"nnoremap <silent> <C-f7> :call Configure() <Enter>

"Select Target
"function! SelectTarget()
"    if &filetype ==# 'c' || &filetype ==# 'cpp'
"		:CMake select_target
"	 endif
" endfunction
"nnoremap <silent> <C-s-f7> :call SelectTarget() <Enter>

"Build
"function! Build()
"   if &filetype ==# 'c' || &filetype ==# 'cpp'
"		:CMake build
"	 endif
" endfunction
"nnoremap <silent> <f8> :call Build() <Enter>

"Build All
function! BuildAll()
    if &filetype ==# 'c' || &filetype ==# 'cpp'
		:CMake build_all
	 endif
 endfunction
nnoremap <silent> <C-f8> :call BuildAll() <Enter>

"Copy. paste and cut
vnoremap <C-c> "+yi
vnoremap <C-x> "+c'
vnoremap <C-v> c<ESC>"+p
inoremap <C-v> <ESC>"+pa
vnoremap <backspace> d
"Completion List
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"Completion Confirm
" use <tab> for trigger completion and navigate to the next item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<space>" :
      \ coc#refresh()

"Snippets
" Use <C-l> for trigger snippet expand.
imap <c-space> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <c-space> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-space>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <c-space> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

"C++
:let g:cmake_link_compile_commands = 1
