" -----------------------------------------------------------------------------
" Call for pathogen stuff, it needs to be first
" -----------------------------------------------------------------------------
call pathogen#infect()


" -----------------------------------------------------------------------------
" moving around, searching and patterns
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
"  tags
" -----------------------------------------------------------------------------


" -----------------------------------------------------------------------------
" displaying text
" -----------------------------------------------------------------------------
set hlsearch
set incsearch
set ignorecase
set smartcase

" -----------------------------------------------------------------------------
"  syntax, highlighing and spelling
" -----------------------------------------------------------------------------

" colo delek
color blackboard   " This is a file that exists in ~/.vim/colors/blackboard.vim
syntax on	   " Turn on syntax highliting
set spelllang=en_au     " Set to my region Australia

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

set t_Co=256

" -----------------------------------------------------------------------------
"  multiple windows
" -----------------------------------------------------------------------------


" -----------------------------------------------------------------------------
"  mappings
" -----------------------------------------------------------------------------
" Map Leader key ,
let mapleader = ","

" Execute the current file
nnoremap <F2> :call ExecuteFile()<CR>

" Show invisibles macros.. that I just LOVE!
nmap <leader>l :set list!<CR>

" Sort the selected list
vnoremap <Leader>s : sort<CR>

" 'v will edit the vimrc file in a new tab
map <leader>v :tabedit $MYVIMRC<CR>

" Moving around in tabs
map <leader>m : <esc>:tabprevious<CR>
map <leader>n : <esc>:tabnext<CR>


" Whacky specific stuff traversing directories with shortcuts.
" ,ew = Open directory in window
" ,es = Open directory in split window
" ,ev = Open directory in virtical split window
" ,et = Open directory in tab window
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Auto close: parentheses, brackets, braces
imap { {}<left>
imap ( ()<left>
imap [ []<left>

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Remove all the trailling whitespaces
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>

" Bind nohl
" Removes highlight of your last search
" ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>


" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" -----------------------------------------------------------------------------
" Behavour and Vim layout
" -----------------------------------------------------------------------------
set history=700		" Sets how many lines of history VIM has to remember
set nocompatible	" Will make vim bheave like vim not vi
set number		" Turn on the numbering, oh I love numbers.
set backup		" Make sure I make a backup of the file I am working.
set backupdir=~/.vim/tmp/	" Place to put backups, create directory first.
set tw=79		" Width of document (used by gd)
set fo-=t		" don't auto wrap text when typing
set colorcolumn=80	" set column 80 as a differnt colour
highlight ColorColumn ctermbg=233


" make sure that list mode is on so I can see the hidden characters and change
" what they look like.
set list
set listchars=tab:▸\ ,eol:¬
" Invisible character colours
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Highlight trailing whitespace in vim on non empty lines, but not while
" typing in insert mode!
highlight ExtraWhitespace ctermbg=red guibg=Brown
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\S\zs\s\+$/
au InsertEnter * match ExtraWhitespace /\S\zs\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\S\zs\s\+$/

" =============================================================================
" Python IDE Setings and Plugins
" =============================================================================
" Settings for vim-powerline
set laststatus=2

" Settings for ctrlp
let g:ctrlp_max_height=30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*

" Settings for jedi-vim
" cd ~/.vim/bundle
" git clone git://github.com/davidhalter/jedi-vim.git
let g:jedi#usages_command = "<leader>z"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0

map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>)

" Better navigating through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>))))

" Python folding
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492
set nofoldenable

" ========================================================================
"                          RUN CURRENT FILE                              =
" ========================================================================
" Will attempt to execute the current file based on the `&filetype`
" You need to manually map the filetypes you use most commonly to the
" correct shell command.
function! ExecuteFile()
  let filetype_to_command = {
  \   'javascript': 'node',
  \   'coffee': 'coffee',
  \   'python': 'python',
  \   'html': 'open',
  \   'sh': 'sh'
  \ }
  let cmd = get(filetype_to_command, &filetype, &filetype)
  call RunShellCommand(cmd." %s")
endfunction

" =============================================================================
" Enter any shell command and have the output appear in a new buffer          =
" For example, to word count the current file:
"
"   :Shell wc %s
"
" src: http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
" =============================================================================
command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
function! RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction
" -----------------------------------------------------------------------------
" Functions that just help things along
" Stab = sets the tab stuff globaly
" -----------------------------------------------------------------------------
" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Set tabstop, softtabstop and shiftwidth to the same value
" Command is :Stab
" Then give the values you want the tabs to be set at.
command! -nargs=* Stab call Stab()
function! Stab()
	let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
	if l:tabstop > 0
		let &l:sts = l:tabstop
		let &l:ts = l:tabstop
		let &l:sw = l:tabstop
	endif
	call SummarizeTabs()
endfunction

function! SummarizeTabs()
	try
		echohl ModeMsg
		echon 'tabstop='.&l:ts
		echon ' shiftwidth='.&l:sw
		echon ' softtabstop='.&l:sts
		if &l:et
			echon ' expandtab'
		else
			echon ' noexpandtab'
		endif
		finally
		echohl None
	endtry
endfunction

" -----------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands
" This sets up the correct tabs for various files, I may want to expand this
" to include extra files types that I work with.
" -----------------------------------------------------------------------------
if has("autocmd")
  " Enable file type detection
  filetype plugin indent on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType markdown setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab

  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss,*.atom setfiletype xml
endif

" -----------------------------------------------------------------------------
" Returns true if paste mode is enabled,
" this is used for the status line, so it knows to update it with 'PASTE MODE'
" -----------------------------------------------------------------------------
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

