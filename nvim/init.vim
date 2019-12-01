" define plugins
call plug#begin('~/.vim/plugged')
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'christoomey/vim-tmux-navigator'
Plug 'ekalinin/Dockerfile.vim' "color scheme for dockerfiles
Plug 'fatih/vim-go' "gives several new commands useful when writing in GO
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim' "Enables 'Ag' ang 'Rg' commands as well as many others.
Plug 'majutsushi/tagbar' "Easy use of CTAGS
Plug 'scrooloose/nerdcommenter' "allows to easily define indentation size
Plug 'scrooloose/nerdtree' "visually browse complex directory hierarchies
"Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-fugitive' "use Git commands in vim
Plug 'tpope/vim-surround' "helps you to surround text with (), {}, '', etc...
Plug 'vim-airline/vim-airline' "status bar at the bottom of the window
Plug 'w0rp/ale' "syntax checking and semantic errors
"Plug 'zchee/deoplete-clang'
"Plug 'zchee/deoplete-jedi'
"Plug 'thaerkh/vim-workspace'
"" == color schemes ==
"Plug 'morhetz/gruvbox'
Plug 'fcpg/vim-orbital'
call plug#end()

set number          " show line numbers
set laststatus=2    " always show status line
set background=dark
syntax on
colorscheme orbital
set cursorline

" navigation
" treat long lines as break lines
map j gj
map k gk

" indentation
set expandtab       " replace tab with spaces
set tabstop=4       " number of spaces for tab
set autoindent      " copy indent from current line
set shiftwidth=4    " number of spaces for autoindent step

" search
set hlsearch    " highlight search results
set incsearch   " incremental search
set ignorecase  " ignore case
set smartcase   " don't ignore case when pattern contains uppercase letters

" disable backup
set nobackup
set nowritebackup
set noswapfile

" misc
set wildmenu                    " enhanced command-line completion
set wildignore=*.o,*~,*.pyc     " ignore compiled files

" fzf
"nmap <c-p> :Files<cr>
"nmap <c-n> :Buffers<cr>

" ack
let g:ackprg = "ag --vimgrep"

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-6.0/lib/libclang.so.1'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang/6.0/include/'
let g:deoplete#sources#clang#clang_complete_database = '.'

" airline
let g:airline_extensions = []       " disable all extensions
let g:airline_section_x = ""        " hide file type
let g:airline_section_y = ""        " hide file encoding

" cscope
if has("cscope")
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
endif



"TROUBLESHOOTING:
"- Exception thrown when opening C files: disable 'deoplete' plugin
"- VIM warn version is too old: disable 'vim-go' plugin (unusable unless you write in GO)
"- fzf plugin not working ('Ag' command not found): run 'sudo apt-get install silversearcher-ag' and try again
