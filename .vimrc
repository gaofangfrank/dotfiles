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
Plugin 'preservim/tagbar'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'tpope/vim-fugitive'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'Konfekt/FastFold'
Plugin 'chrisbra/csv.vim'
Plugin 'fidian/hexmode'
Plugin 'azabiong/vim-highlighter'
call vundle#end()            " required
filetype plugin indent on    " required
" " Put your non-Plugin stuff after this line
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
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

set background=dark
colorscheme PaperColor
syntax enable
scriptencoding utf-8

" Tagbar config
let g:tagbar_ctags_options=['NONE', '~/.config/ctags/options.ctags']
let g:tagbar_ctags_bin='~/.local/bin/ctags'

inoremap <CR> <CR>x<BS>
inoremap {<CR> {}<left><CR><up><end><CR>x<BS>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
set splitbelow
set splitright
set backspace=indent,eol,start

autocmd BufNewFile,BufRead *.cce set syntax=cpp

" Highlight trailing whitespace and lines longer than 80 columns.
highlight LongLine ctermbg=DarkYellow guibg=DarkYellow
highlight WhitespaceEOL ctermbg=DarkYellow guibg=DarkYellow
if v:version >= 702
  " Lines longer than 80 columns.
  "au BufWinEnter * let w:m0=matchadd('LongLine', '\%>80v.\+', -1)

  " Whitespace at the end of a line. This little dance suppresses
  " whitespace that has just been typed.
  au BufWinEnter * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
  au InsertEnter * call matchdelete(w:m1)
  au InsertEnter * let w:m2=matchadd('WhitespaceEOL', '\s\+\%#\@<!$', -1)
  au InsertLeave * call matchdelete(w:m2)
  au InsertLeave * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
else
  au BufRead,BufNewFile * syntax match LongLine /\%>80v.\+/
  au InsertEnter * syntax match WhitespaceEOL /\s\+\%#\@<!$/
  au InsertLeave * syntax match WhitespaceEOL /\s\+$/
endif

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

" ycm config
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_clangd_binary_path = exepath("~/FIXME/build-clangd/bin/clangd")
let g:ycm_clangd_uses_ycmd_caching = 0
map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>i :YcmCompleter FixIt<CR>

" tagbar
nmap <leader>f :TagbarToggle<CR>

" nerdtree config
nnoremap tn :NERDTreeToggle<CR>
" close vim if last window is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_check_on_open=1
"let g:syntastic_check_on_wq=0

" cpp highlight
let g:cpp_class_scope_highlight = 1

" go to last opened position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

packadd termdebug
let g:termdebug_wide = 110

" json formatting
com! JSON %!python -m json.tool

let g:hexmode_xxd_options = '-g 1'
