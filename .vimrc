set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
 set rtp+=~/.vim/bundle/Vundle.vim
 call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
 Plugin 'VundleVim/Vundle.vim'
"
 Plugin 'Valloric/YouCompleteMe'
 Plugin 'vim-syntastic/syntastic'
 Plugin 'scrooloose/nerdtree'
 Plugin 'vim-scripts/DrawIt'
 Plugin 'vim-scripts/vim-auto-save'
 Plugin 'scrooloose/nerdcommenter'
 Plugin 'vim-python/python-syntax'
 Plugin 'vim-airline/vim-airline'
 Plugin 'vim-airline/vim-airline-themes'
 Plugin 'lervag/vimtex'
 Plugin 'vim-scripts/DoxygenToolkit.vim'
 Plugin 'octol/vim-cpp-enhanced-highlight'
 Plugin 'fatih/vim-go'
 Plugin 'Konfekt/FastFold'
 call vundle#end()            " required
 filetype plugin indent on    " required
 " To ignore plugin indent changes, instead use:
 "filetype plugin on
 "
 " Brief help
 " :PluginList       - lists configured plugins
 " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line
set encoding=utf-8
set number
set tabstop=2
set shiftwidth=2
set expandtab
set hlsearch
set nowrap
set foldmethod=syntax
set foldnestmax=3


syntax enable
set autoindent
set showmatch
let python_highlight_all = 1
set cursorline
set nobackup
set noswapfile
scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8

let g:auto_save = 1

color elflord

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" ycm config
let g:ycm_python_binary_path = 'python'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" nerdtree config
nnoremap tn :NERDTreeToggle<CR>
" close vim if last window is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" syntastic 
let g:syntastic_cpp_compiler_options = ' -std=c++11'
let g:syntastic_python_checkers=['flake8']

" cpp highlight
let g:cpp_class_scope_highlight = 1

" go to last opened position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif 
