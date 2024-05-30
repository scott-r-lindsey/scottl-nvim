
" -----------------------------------------------------------------------------
" install vim-plug if missing
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" install plugins
call plug#begin()

" file navigation
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" syntax highlighting
Plug 'hashivim/vim-terraform'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'HerringtonDarkholme/yats.vim'

" themes
Plug 'gosukiwi/vim-atom-dark',
Plug 'sonph/onehalf', { 'rtp': 'vim' }

" utilities
Plug 'chrisbra/Colorizer'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ryanoasis/vim-devicons'
Plug 'inside/vim-search-pulse'
Plug 'RRethy/vim-illuminate'
Plug 'nathanaelkane/vim-indent-guides'

" ide features
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'airblade/vim-gitgutter'

" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" ai plugins
Plug 'CoderCookE/vim-chatgpt'
Plug 'madox2/vim-ai'
Plug 'github/copilot.vim'

call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" :silent! packadd onehalf-vim

" -----------------------------------------------------------------------------
" general fixes

" allow uppercase w/q
command W w
command Q q
command Wq wq
command WQ wq

" No startup message
set shortmess+=I

" turn off swap file hand-holding
set noswapfile

" 256 colors party like 1990
let &t_Co=256

" leader
set showcmd
set timeoutlen=2000
let mapleader = " "

" Colors
if (has("termguicolors"))
    set termguicolors
endif

" modern tabs
set tabstop=2
set shiftwidth=2
set expandtab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType scss setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.tsx set filetype=javascript.jsx
autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2
autocmd BufNewFile,BufRead *.dockerfile set filetype=dockerfile

" always show status line
set laststatus=2

" supress W11 warning
autocmd FileChangedShell * :

" no history file plz
let g:netrw_dirhistmax=0

" json
let g:vim_json_syntax_conceal = 0

" disable comment continuation
autocmd FileType * set formatoptions-=cro

" no auto-indent
filetype indent off

" don't hide quotes
set conceallevel=0

" -----------------------------------------------------------------------------
" functions

" ale eslint disable generator
command! ALEIgnoreEslint call AleIgnoreEslint()
function! AleIgnoreEslint()
  " https://stackoverflow.com/questions/54961318/vim-ale-shortcut-to-add-eslint-ignore-hint
  let l:codes = []
  if (!exists('b:ale_highlight_items'))
    echo 'cannot ignore eslint rule without b:ale_highlight_items'
    return
  endif
  for l:item in b:ale_highlight_items
    if (l:item['lnum']==line('.') && l:item['linter_name']=='eslint')
      let l:code = l:item['code']
      call add(l:codes, l:code)
    endif
  endfor
  if len(l:codes)
    exec 'normal O/* eslint-disable-next-line ' . join(l:codes, ', ') . ' */'
  endif
endfunction

" Toggle signcolumn.
function! ToggleInfo()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        :ALEToggle
        set signcolumn=no
        let b:signcolumn_on=0
    else
        :ALEToggle
        set signcolumn=number
        let b:signcolumn_on=1
    endif
endfunction

function! GenerateUUID()
    :let generatedUUID=system("python3  -c 'import uuid; print(uuid.uuid4(), end=\"\")'")
    :execute "normal i" . generatedUUID
endfunction

" -----------------------------------------------------------------------------
" color config

silent! colorscheme atom-dark-256

" augroup ColorschemePreferences
"   autocmd!
"     autocmd ColorScheme * highlight MatchParen cterm=bold ctermfg=cyan gui=bold guifg=cyan guibg=black
"     autocmd ColorScheme * highlight ALEErrorSign cterm=bold ctermfg=red gui=bold guifg=red
"     autocmd ColorScheme * highlight ALEWarningSign cterm=bold ctermfg=yellow gui=bold guifg=yellow
"     autocmd ColorScheme * highlight ALEInfoSign cterm=bold ctermfg=white gui=bold guifg=white
" augroup END

autocmd BufNewFile,BufRead *.json colorscheme onehalfdark

" -----------------------------------------------------------------------------
" plugin config

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='onehalfdark'

" ale
" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }
let g:ale_linters = {'javascript': ['eslint']}
let b:ale_fixers = {'javascript': ['eslint']}
let g:ale_fix_on_save = 1

let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = '󰌶'
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
let g:ale_linters = { 'cs': ['OmniSharp'] }

" coc.nvim press CR to select
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Colorizer
let g:colorizer_auto_color = 1

" devicons
set encoding=UTF-8

" gitgutter
let g:gitgutter_set_sign_backgrounds = 1

" vim-jsx-pretty
let g:vim_jsx_pretty_colorful_config = 1
let g:vim_jsx_pretty_highlight_close_tag = 1

" Omnisharp
let g:OmniSharp_server_use_net6 = 1






" -----------------------------------------------------------------------------
" custom shortcuts

" fzf on f1
map <F1> :FZF<CR>

" enable The NERD Tree
map <F2> :NERDTreeToggle<CR>

" Json formatting on F3
map <F3> :%!~/.config/nvim/indent-json.sh<CR>

" insert eslint-ignore automatically
nnoremap <F4> :call AleIgnoreEslint()<CR>

" Toggle ALE SignColumn on F5
nnoremap <F5> :call ToggleInfo()<CR>

" strip trialing whitespace
nnoremap <F6> :StripWhitespace<CR>

map <leader>h :noh<CR>
map <leader><Left> :bp<CR>
map <leader><Right> :bn<CR>

map <leader>d :call GenerateUUID()<CR>

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)

  " strip trialing whitespace
  nnoremap <F12> :edit

augroup END

" -----------------------------------------------------------------------------
" local config

" Function to source all .vim files in a specified directory
function! SourceDirectory(directory)
    " Check if the directory exists
    if isdirectory(a:directory)
        " List all .vim files in the directory
        for file in split(glob(a:directory . '*.vim'), '\n')
            " Source each file
            execute 'source' file
        endfor
    endif
endfunction

" Call the function with the path to your directory
call SourceDirectory(expand('~/.config/nvim/local_config/'))

" -----------------------------------------------------------------------------


