" Plugins
call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'vim-airline/vim-airline'
Plug 'aklt/plantuml-syntax'
Plug 'vim-airline/vim-airline-themes'
Plug 'fatih/molokai'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'rust-lang/rust.vim', {'do': 'cargo +nightly install racer -f; rustup component add rls rust-analysis rust-src'}
Plug 'neovimhaskell/haskell-vim'
Plug 'leafgarland/typescript-vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'elixir-editors/vim-elixir'
Plug 'JulesWang/css.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'tbastos/vim-lua'
Plug 'dense-analysis/ale'
Plug 'vim-syntastic/syntastic'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rhysd/vim-grammarous'
Plug 'preservim/nerdtree'
Plug 'psf/black'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'jiangmiao/auto-pairs'
Plug 'tomlion/vim-solidity'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-vividchalk'
Plug 'nanotech/jellybeans.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

call plug#end()

" Termdebug
packadd! termdebug
let g:termdebug_wide=1

set nocompatible
set noswapfile
set ttyfast

" Visual preferences
let g:airline_theme='minimalist'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:molokai_original = 0
let g:rehash256 = 0

set relativenumber
set number
set number relativenumber
set showcmd
set background=dark

" Show indentations
set listchars=tab:\|\ 
set list

set t_Co=256
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
syntax on

" Use truecolor
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif

let g:gruvbox_italic=1
colorscheme gruvbox

" Nerdtree preferences

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif


" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" enter/C-m to toggle nerdtree and move cursor back to prev position
map <C-m> :NERDTreeToggle<CR><C-w>l


" <3 fzf
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout=  { 'down': '~20%' }

map <C-b> :FZF<CR>

" Vim hotkeys
map H ^
map L $

map <C-c> :noh<cr>:call clearmatches()<cr>

set backspace=indent,eol,start

" C-t open new tab
map <C-t> :Te<CR>

" C-r replace visual-mode highlighted text
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

" Open termdebug and move source code to the right
nnoremap <F6> :Termdebug<CR><c-w>h<c-w>L


" LaTeX hotkeys
map <C-A-s> :! pdflatex % && pkill -HUP mupdf-gl<CR><CR>
map <C-A-o> :! mupdf $(echo % \| sed 's/tex$/pdf/') & disown<CR><CR>
map <C-A-r> :! pkill -HUP mupdf<CR><CR>

" Panes, but better
set splitright
set splitbelow

nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-j>
nnoremap <C-K> <C-W><C-k>
nnoremap <C-L> <C-W><C-l>

" Syntax fixing with ALE
let g:ale_linters = {'javascript': ['eslint'], 'typescriptreact': ['eslint'], 'vue': ['eslint'], 'python': ['flake8', 'pylint'], 'rust': ['analyzer']}
let g:ale_fixers = {'javascript': ['eslint'], 'typescriptreact': ['eslint'], 'vue': ['eslint'], 'python': ['black']}
let g:ale_rust_rls_toolchain = 'stable'
let g:ale_fix_on_save = 1

let g:LanguageClient_serverCommands = {
\ 'rust': ['rust-analyzer'],
\ }

" Syntax for dart
let g:dart_style_guide = 1
let g:dart_format_on_save = 1

" Filetype detection
filetype plugin indent on

au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
au! BufNewFile,BufReadPost *.{tsx,jsx}  set filetype=typescriptreact

augroup filetypedetect
  autocmd BufNewFile,BufRead *.js  setlocal noexpandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.sol setlocal noexpandtab  shiftwidth=4 tabstop=4

  autocmd FileType rust       		setlocal noexpandtab  shiftwidth=4 tabstop=4
  autocmd FileType vue        		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType json       		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType go         		setlocal noexpandtab  shiftwidth=4 tabstop=4
  autocmd FileType scss       		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType css        		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType java       		setlocal noexpandtab  shiftwidth=4 tabstop=4
  autocmd FileType js         		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType typescript 		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType svelte     		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType tex        		setlocal noexpandtab  shiftwidth=4 tabstop=4
  autocmd FileType haskell    		setlocal noexpandtab  shiftwidth=8 tabstop=8
  autocmd FileType sh         		setlocal noexpandtab  shiftwidth=4 tabstop=4
  autocmd FileType yaml       		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType c          		setlocal noexpandtab  shiftwidth=4 tabstop=4
  autocmd FileType dart       		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType html       		setlocal noexpandtab  shiftwidth=2 tabstop=2
  autocmd FileType typescriptreact	setlocal noexpandtab  shiftwidth=2 tabstop=2


augroup autorun
	autocmd filetype c nnoremap <C-x> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
	autocmd filetype rust nnoremap <C-x> :w <bar> exec '!rustc '.shellescape('%').' && ./'.shellescape('%:r')<CR>

" Prefer rust-analyzer over syntastic
let g:syntastic_mode_map = { 'passive_filetypes': ['rust'] }

" mouse mode
set mouse=a 
