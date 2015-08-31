"-----------------------------------------------------------
" Features 
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc

" Don't initialize NeoBundle if using vim-tiny or vim-small
if 0 | endif

" Also initialize NeoBundle
if has('vim_starting')
    if &compatible
        set nocompatible
    endif
    
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Run NeoBundle
call neobundle#begin(expand('~/.vim/bundle/'))

" Have NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" PLUG INS/BUNDLES
NeoBundle "altercation/vim-colors-solarized"
NeoBundle "bling/vim-airline"
NeoBundle "scrooloose/nerdtree"
NeoBundle "jistr/vim-nerdtree-tabs"
NeoBundle "scrooloose/syntastic"
NeoBundle "xolox/vim-misc"
NeoBundle "xolox/vim-easytags"
NeoBundle "majutsushi/tagbar"
NeoBundle "Shougo/unite.vim"
NeoBundle "tpope/vim-projectionist"
NeoBundle "airblade/vim-gitgutter"
NeoBundle "tpope/vim-fugitive"
NeoBundle "Raimondi/DelimitMate"
NeoBundle "vim-latex/vim-latex"
NeoBundle "xuhdev/vim-latex-live-preview.git"

call neobundle#end()

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for 
filetype indent plugin on

" Install uninstalled bundles
NeoBundleCheck

" Enable syntax highlighting
syntax on

" Colorscheme & Font
if has('gui_running')
    set guioptions=egmrt

    try
        colorscheme solarized 
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme ron 
    endtry
else
    colorscheme ron
endif

set guifont=Consolas:h11:cANSI
"------------------------------------------------------------
" Plug in options

" --------vim-airline--------
" Show statusbar
set laststatus=2

" Paste mode display
let g:airline_detect_past=1

" Airline for tabs
let g:airline#extensions#tabline#enabled=1

" --------vim-nerdtree--------
"  Open=close NERDTree with \t
nmap <silent><leader>t :NERDTreeTabsToggle<CR>

" Alway have NERDTree open on startup
let g:nerdtree_tabs_open_on_console_startup = 0

" --------syntastic-------
let g:syntastic_error_symbol = 'x'
let g:syntastic_warning_symbol = 'o'
 
augroup mySyntastic
    au!
    au FileType tex let b:syntastic_mode = "passive"
augroup END

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

let g:syntastic_c_checkers = ['gcc', 'make']

"-------vim-easytags--------
" Look for tag endings 
set tags=./tags;,~/.vimtags

" Defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

"--------tagbar--------
" Close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>

"--------vim-gitgutter--------
" Colorscheme
hi clear SignColumn

" Display hunks of diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

"--------delimitMate--------
let delimitMate_expand_cr = 1
augroup mydelimitMate
    au!
    au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
    au FileType tex let b:delimitMate_quotes = ""
    au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
    au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

"--------VIM_LaTeX--------
let g:tex_flavor='latex'
"--------vim-latex-live-preview--------
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Preview'

"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Incremental search to search for every key press
set incsearch

" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Get rid of flashing and noises
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" two characters wide.
"set shiftwidth=4
"set tabstop=4


"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Map Shift enter make space above without going to insert mode
nmap <S-Enter> O<Esc>
" Map Enter make space under without going to insert mode
nmap <CR> o<esc>

" Map Backspace to delete line
nmap <bs> dd k

" Map tab in normal mode to move through windows 
nmap <Tab> <C-w><C-w>
" Default vim start up location
:cd C:\Users\Conan\Programming
"------------------------------------------------------------
