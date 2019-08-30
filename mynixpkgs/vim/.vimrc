" nocompatible means Vim doesn't have to support
" backwards compatibility with Vi.
" Usually this line does nothing.
set nocompatible               " be iMproved
set encoding=utf-8

" Detect filetype and use indent plugin
filetype plugin indent on

syntax enable
set background=dark
colorscheme gruvbox

" Adding CLI deps for Neoformat and Syntastic.
" In default.nix, we specify replacing CUSTOM_PATH_REPLACE_ME with a
" PATH variable containing the bin dir of each dep in ./buildInputs.
" In here, we add that variable to vim's runtimepath, which is
" essentially the PATH variable active inside vim.
" TODO is this option a good way to handle this issue? See issue
" https://github.com/NixOS/nixpkgs/issues/41613#issuecomment-396074416
exe 'set rtp+=' . expand("CUSTOM_PATH_REPLACE_ME")
" The line above is similar to the one below, but it's better, because
" it avoids conflicts it by essentially namespacing it under vim:
"let $PATH = "CUSTOM_PATH_REPLACE_ME" . ':' . $PATH

" Powerline:
" add bindings to Vim's runtimepath:
" default.nix handles replacing POWER_LINE_VIM_PATH_REPLACE_ME
exe 'set rtp+=' . expand("POWER_LINE_VIM_PATH_REPLACE_ME")
" make status bar always show:
set laststatus=2

" make backspace behave 'normally'
set backspace=indent,eol,start

" show line numbers by default
set number

"******************
" Key Mappings
"******************

" Quickly type 'jk' to leave insert mode
inoremap jk <Esc>

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" make csv.vim recognize the pound sign as indicating a comment
let g:csv_comment = '#'

" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine the mapping there.
" from http://superuser.com/questions/815416/hitting-enter-in-the-quickfix-window-doesnt-work
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

""""""""""""""""""""""""""""""""
" Neoformat: auto-format on save
""""""""""""""""""""""""""""""""
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_enabled_html = ['js-beautify --html']
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_json = ['prettier']
let g:neoformat_enabled_markdown = ['prettier']

let g:neoformat_enabled_php = ['phpcsfixer']
" TODO look at using phpcbf vs. phpcsfixer. (NOTE: phpcbf not currently a supported option for Neoformat.)
" https://github.com/squizlabs/PHP_CodeSniffer
"
"let g:neoformat_enabled_php = ['phpcbf']
"let g:syntastic_php_phpcs_args = \"--standard=$(nix-env -q --out-path --no-name 'composer-mediawiki-mediawiki-codesniffer')/share/php/composer-mediawiki-mediawiki-codesniffer/vendor/mediawiki/mediawiki-codesniffer/MediaWiki/ruleset.xml"
"
" This worked from the command line:
" phpcbf --standard="$(nix-env -q --out-path --no-name 'composer-mediawiki-mediawiki-codesniffer')/share/php/composer-mediawiki-mediawiki-codesniffer/vendor/mediawiki/mediawiki-codesniffer/MediaWiki/ruleset.xml" ../../wow.php

let g:neoformat_enabled_python = ['black']
let g:neoformat_enabled_sh = ['shfmt']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_xml = ['tidy']

" TODO sqlformat (from sqlparse) messes up CREATE TABLE statements:
" https://github.com/andialbrecht/sqlparse/issues/360
" So I added pg_format (from pgFormatter) as an option for Neoformat.
" But the version of Neoformat in Nixpkgs hasn't
" been updated yet to use my update.
" Watch for the neoformat expression to be updated to anything after Apr. 20
"   <https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/default.nix#L2283>
" then enable the following line:
"let g:neoformat_enabled_sql = ['pg_format']
" And add *.sql to the list of file extensions for Neoformat

" JS/TS/JSON indent settings: match prettier defaults
autocmd Filetype javascript setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
autocmd Filetype typescript setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
autocmd Filetype json setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" Autoformat on save for filetypes specified:
autocmd BufWritePre *.css,*.html,*.js,*.jsx,*.json,*.md,*.php,*.py,*.sh,*.ts,*.tsx,*.xml Neoformat

""""""""""""""""""""""""""""""
" Syntastic: the syntax helper
""""""""""""""""""""""""""""""
let g:syntastic_mode_map = { 'mode': 'active',
			\ 'active_filetypes': ['html', 'javascript', 'nix', 'php', 'python', 'sh', 'sql', 'typescript' ],
			\ 'passive_filetypes': [] }
" Always stick any detected errors into the loclist:
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Make tsuquyomi output display in syntastic gutter (disabled now bc it freezes vim for minutes)
"let g:tsuquyomi_disable_quickfix = 1

let g:syntastic_html_checkers = ['eslint']

let g:syntastic_javascript_checkers = ['eslint']
" strangely, when g:tsuquyomi_disable_quickfix is set to 1, I needed
" to add tsuquyomi as below to make the errors show in the gutter
"let g:syntastic_javascript_checkers = ['eslint', 'tsuquyomi']

let g:syntastic_nix_checkers = ['nix']

let g:syntastic_php_checkers = ['phpcs']
" Tell phpcs to use the Mediawiki standard:
" TODO replace the nix-env call with a variable calculated at build
let g:syntastic_php_phpcs_args = "--standard=$(nix-env -q --out-path --no-name 'composer-mediawiki-mediawiki-codesniffer')/share/php/composer-mediawiki-mediawiki-codesniffer/vendor/mediawiki/mediawiki-codesniffer/MediaWiki/ruleset.xml"

let g:syntastic_python_checkers = ['flake8', 'pylint']
" Black's default line length is 88 chars, but it will
" sometimes make long lines, e.g.: 119 chars
" https://github.com/python/black#line-length
let g:syntastic_python_flake8_args="--ignore=E501"
" If Black always limited to 88, the following might work:
"let g:syntastic_python_flake8_args="--max-line-length=88"
"let g:syntastic_python_pylint_post_args="--max-line-length=88"

let g:syntastic_sh_checkers = ['shellcheck']
" make syntastic call shellcheck with param to follow files
let g:syntastic_sh_shellcheck_args = "-x"

let g:syntastic_sql_checkers = ['sqlint']
" TODO: getting an error when this is enabled
"let g:syntastic_typescript_checkers = ['tsuquyomi']

"""""""""""""""""""""""""
" CtrlP: better searching
"""""""""""""""""""""""""
" Use the C extension for matching:
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
" Add commands for initiating CtrlP:
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Tell CtrlP which files to ignore.
" This is for Mac/Linux. For Windows, see https://github.com/ctrlpvim/ctrlp.vim.
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
			\ 'dir':  '\v[\/]\.(git|hg|svn)$',
			\ 'file': '\v\.(exe|so|dll)$',
			\ 'link': 'some_bad_symbolic_links',
			\ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
