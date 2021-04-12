" let mapleader = ","

call plug#begin(' ~/.local/share/nvim/site/plugged')

 " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Initialize plugin system
call plug#end()

" " Colorscheme
" call minpac#add('morhetz/gruvbox')
" call minpac#add('arcticicestudio/nord-vim')
" call minpac#add('flazz/vim-colorschemes')
"
" " Status line
" call minpac#add('itchyny/lightline.vim')
"
" " Quickly switch between buffers
" call minpac#add('jlanzarotta/bufexplorer')
"
" " Vim/Tmux integration
" call minpac#add('christoomey/vim-tmux-navigator')
" call minpac#add('roxma/vim-tmux-clipboard')
"
" " Git
" call minpac#add('tpope/vim-git')
" call minpac#add('tpope/vim-fugitive')
" call minpac#add('tpope/vim-rhubarb')
" call minpac#add('gregsexton/gitv')
" call minpac#add('airblade/vim-gitgutter')
"
" " Nerd Tree file management
" call minpac#add('scrooloose/nerdtree')
" call minpac#add('taiansu/nerdtree-ag')
" call minpac#add('Xuyuanp/nerdtree-git-plugin')
"
" " Fuzzy Finder
" call minpac#add('junegunn/fzf.vim')
"
" " Tim Pope's good stuff
" call minpac#add('tpope/vim-sensible')
" call minpac#add('tpope/vim-obsession')
" call minpac#add('tpope/vim-surround')
" call minpac#add('tpope/vim-unimpaired')
" call minpac#add('tpope/vim-endwise')
" call minpac#add('tpope/vim-repeat')
"
" " Ruby/Rails 
" call minpac#add('tpope/vim-rails')
" call minpac#add('tpope/vim-rake')
" call minpac#add('tpope/vim-bundler')
"
" " Auto-close brackets, quotes, etc
" call minpac#add('Raimondi/delimitMate')
"
" " Command line mode mappings
" call minpac#add('vim-utils/vim-husk')
"
" " Find and Replace
" call minpac#add('brooth/far.vim')
"
" " Silver Searcher
" call minpac#add('rking/ag.vim')
"
" " Grep
" call minpac#add('mhinz/vim-grepper')
"
" " Undo tool
" call minpac#add('sjl/gundo.vim')
"
" " Easier cursor movement
" call minpac#add('justinmk/vim-sneak')
" call minpac#add('bkad/CamelCaseMotion')
" call minpac#add('henrik/vim-indexed-search')
"
" " Code commenter
" call minpac#add('tomtom/tcomment_vim')
"
" " Auto cd to project root
" call minpac#add('airblade/vim-rooter')
"
" " :Align
" call minpac#add('tsaleh/vim-align')
"
" " Syntax errors
" call minpac#add('vim-syntastic/syntastic')
"
" " Syntax colors
" call minpac#add('othree/html5.vim')
" call minpac#add('blueyed/smarty.vim')
" call minpac#add('lumiliet/vim-twig')
" call minpac#add('vim-scripts/jade.vim')
" call minpac#add('kchmck/vim-coffee-script')
" call minpac#add('lchi/vim-toffee')
" call minpac#add('vim-scripts/jQuery')
" call minpac#add('hail2u/vim-css3-syntax')
" call minpac#add('groenewege/vim-less')
" call minpac#add('ekalinin/Dockerfile.vim')
" call minpac#add('bwangel23/nginx-vim-syntax')
" call minpac#add('vim-scripts/openvpn')
" call minpac#add('othree/yajs.vim')
" call minpac#add('othree/javascript-libraries-syntax.vim')
" call minpac#add('mxw/vim-jsx')
" if has('Python')
"   call minpac#add('valloric/MatchTagAlways')
" endif

" Basic stuff
set encoding=utf-8                     " always use the good encoding
set mouse=a                            " allow the mouse to be used
set title                              " set the window's title to the current filename
set visualbell                         " no more beeping from Vim
set cursorline                         " highlight current line
set fillchars=vert:│                   " Solid line for vsplit separator
set showmode                           " show what mode (Insert/Normal/Visual) is currently on
set timeoutlen=500
set number                             " show line numbers
set wildmode=list:longest,list:full

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" Remap ; to : in visual mode
nnoremap ; :

" LightLine displays mode
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" Whitespace
set nowrap
set tabstop=2                           " number of visual spaces per tab
set softtabstop=2                       " number of spaces in tab when editing
set expandtab                           " tabs are spaces!
set shiftwidth=2                        " how many spaces to indent/outdent

" F5 will remove trailing whitespace and tabs
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" Use modeline overrides
set modeline
set modelines=10

" Colors
try 
  colorscheme gruvbox
  set background=dark
  catch
endtry

" " Directories for session, undo, backup, swp files
" let g:vim_pid = $HOME.'/.vim/session/process-'.getpid()
" let g:vim_sid = $HOME.'/.vim/session/session'.substitute(expand("%:p:h"),'/','-','g')
" silent! call mkdir(g:vim_pid, 'p', 0701)
" silent! call mkdir(g:vim_sid, 'p', 0700)
"
" " Track undo and open files
" if has('persistent_undo')
"   set undofile
"   let &undodir=g:vim_sid
" endif
" let &backupdir=g:vim_pid
" let &directory=g:vim_pid

" <leader>u will show undo history graph
nnoremap <leader>u :GundoToggle<CR>
let g:gundo_right = 1

" Remember last location in file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Visual shifting (builtin-repeat)
vmap < <gv
vmap > >gv

" Better visual block selecting
set virtualedit+=block
set virtualedit+=insert
set virtualedit+=onemore

" Hide buffers or auto-save?
set hidden       " allow unsaved buffers to be hidden

" Alt-tab between buffers
nnoremap <leader><leader> <C-^>

" Make 'Y' follow 'D' and 'C' conventions'
nnoremap Y y$

" sudo & write if you forget to sudo first
cmap w!! w !sudo tee % >/dev/null

" Let split windows be different sizes
set noequalalways

" Rewrap paragraph
noremap Q gqip

" :Man pages in Vim
runtime! ftplugin/man.vim

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" Create our own mappings
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>

if has('nvim')
  tnoremap <silent> <M-h> <C-\><C-n> :TmuxNavigateLeft<cr>
  tnoremap <silent> <M-j> <C-\><C-n> :TmuxNavigateDown<cr>
  tnoremap <silent> <M-k> <C-\><C-n> :TmuxNavigateUp<cr>
  tnoremap <silent> <M-l> <C-\><C-n> :TmuxNavigateRight<cr>
  tnoremap <silent> <M-\> <C-\><C-n> :TmuxNavigatePrevious<cr>
endif

" Smart way to move between windows. Ctrl-[h,j,k,l]
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" If in Visual Mode, resize window instead of changing focus. Ctrl-[h,j,k,l]
vnoremap <c-j> <c-w>+
vnoremap <c-k> <c-w>-
vnoremap <c-h> <c-w><
vnoremap <c-l> <c-w>>

vnoremap <M-j> <c-w>+
vnoremap <M-k> <c-w>-
vnoremap <M-h> <c-w><
vnoremap <M-l> <c-w>>

" Let directional keys work in Insert Mode. Ctrl-[h,j,k,l]
inoremap <c-j> <Down>
inoremap <c-k> <Up>
inoremap <c-h> <Left>
inoremap <c-l> <Right>

" Cursor movement in command mode
cnoremap <c-j> <Down>
cnoremap <c-k> <Up>
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>
cnoremap <c-x> <Del>
cnoremap <c-z> <BS>
cnoremap <c-v> <c-r>"

" Searching
set hlsearch
set ignorecase
set smartcase
set gdefault

" Clear search with comma-space
noremap <leader><space> :noh<CR>:match none<CR>:2match none<CR>:3match none<CR>

" fzf fuzzy finder
set rtp+=~/.fzf
nnoremap <C-t> <ESC>:Files<CR>
" nnoremap <M-k> <ESC>:Buffers<CR>
nnoremap <M-t> <ESC>:Lines<CR>

" Find and Replace
nnoremap <M-f> <ESC>:Farp<CR>

" Use Ag instead of Grep when available
if executable("ag")
  set grepprg=ag\ -H\ --nogroup\ --nocolor
  nnoremap <leader>a :Ag ""<left>
endif

nnoremap <leader>g :Grepper<cr>
let g:grepper = { 'next_tool': '<leader>g' }

" Shift-K toggles buffexplorer
command! BufExplorerBuffers call s:Buffers()
function! s:Buffers()
  let l:title = expand("%:t")
  if (l:title == '[BufExplorer]')
    :b#
  else
    :silent BufExplorer
  endif
endfunction
nmap <S-k> :BufExplorer<CR>

" Vim-Sneak (type s followed by two characters)
let g:sneak#label = 1
let g:sneak#s_next = 1

" Unimpaired - see all mappings at :help unimpaired
" cob bgcolor cow softwrap, coc cursorline, cou cursorcolumn, con number, cor relativenumber
" yp yP yo YO yI YA paste with paste toggled on
" []x encode xml, []u encode url, []y encode C string
" []b buffers, []f files, []<Space> blank lines
" []e bubble multiple lines, visual mode mappings below:
vmap _ [egv
vmap + ]egv

" syntastic
if exists("*SyntasticStatuslineFlag")
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  " let g:syntastic_enable_signs=1
  " let g:syntastic_quiet_messages = {'level': 'warnings'}
endif

" git
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
let g:Gitv_DoNotMapCtrlKey = 1

" NERDTree toggles with ,d
map <Leader>d :NERDTreeToggle \| :silent NERDTreeMirror<CR>
map <Leader>] :NERDTreeToggle \| :silent NERDTreeMirror<CR>
map <Leader>dd :NERDTreeFind<CR>
map <Leader>]] :NERDTreeFind<CR>
let NERDTreeIgnore=['\.rbc$', '\~$', '\.xmark\.']
let NERDTreeDirArrows=1
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1

" Local config
if filereadable($HOME . "/.config/nvim/local.vim")
  source ~/.config/nvim/local.vim
endif
