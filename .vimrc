set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
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
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
Plugin 'ycm-core/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'yegappan/taglist'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bfrg/vim-cpp-modern'
Plugin 'tpope/vim-fugitive'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'Rigellute/rigel'
Plugin 'Konfekt/FastFold'
Plugin 'chrisbra/csv.vim'
Plugin 'fidian/hexmode'
Plugin 'azabiong/vim-highlighter'
Plugin 'MTDL9/vim-log-highlighting'
call vundle#end()            " required
filetype plugin indent on    " required
" " Put your non-Plugin stuff after this line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Variables of all sorts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number
set tabstop=2
set shiftwidth=2
set expandtab
set hlsearch
set nowrap
set autoindent
set showmatch
set cursorline
set encoding=utf-8
set fileencoding=utf-8
set tags=tags;
set foldmethod=syntax
set foldnestmax=5
let python_highlight_all = 1
set noeb vb t_vb=
set colorcolumn=+1
set splitbelow
set splitright
set backspace=indent,eol,start
scriptencoding utf-8
syntax enable

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom key bindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap <CR> <CR>x<BS>
inoremap {<CR> {}<left><CR><up><end><CR>x<BS>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" clang format
map <C-I> :py3f ~/.vim/clang-format.py<cr>
imap <C-I> <c-o>:py3f ~/.vim/clang-format.py<cr>
:function FormatFile()
:  let l:lines="all"
:  if has('python')
:    pyf ~/.vim/clang-format.py
:  elseif has('python3')
:    py3f ~/.vim/clang-format.py
:  endif
:endfunction
map <C-P> :call FormatFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pretty colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
"set termguicolors
"colorscheme PaperColor
colorscheme rigel
let g:rigel_airline = 1
let g:airline_theme = 'rigel'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configurations
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ycm config
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_clangd_binary_path = exepath("/usr/local/bin/clangd")
let g:ycm_clangd_uses_ycmd_caching = 0
map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>i :YcmCompleter FixIt<CR>
nmap <leader>D <plug>(YCMHover)
let g:ycm_language_server = [
      \{ 'name': 'mlir-lsp-server',
        \'filetypes': [ 'mlir' ],
        \'cmdline': [ '/usr/local/bin/mlir-lsp-server' ] },
\]

" taglist
nmap <leader>f :TlistToggle<CR>
let Tlist_Use_Right_Window=1
let Tlist_Exit_OnlyWindow=1

" nerdtree config
nnoremap tn :NERDTreeToggle<CR>
" close vim if last window is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" commenter
let NERDCommentWholeLinesInVMode=1
let NERDSpaceDelims=1
let NERDTrimTrailingWhitespace=1

" Hexmode config
let g:hexmode_xxd_options = '-g 1'

" go to last opened position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Enable in-editor debugger
packadd termdebug
let g:termdebug_wide = 110

" json formatting
com! JSON %!python -m json.tool
