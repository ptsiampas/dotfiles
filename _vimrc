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

" Show invisibles macros.. that I just LOVE!
nmap <leader>l :set list!<CR>

" Activate spell checking \s
nmap <silent> <leader>s :set spell!<CR>

" \v will edit the vimrc file in a new tab
map <leader>v :tabedit $MYVIMRC<CR>

" Whacky specific stuff traversing directories with shortcuts.
" \ew = Open directory in window
" \es = Open directory in split window
" \ev = Open directory in virtical split window
" \et = Open directory in tab window
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" -----------------------------------------------------------------------------
" Behavour and Vim layout
" -----------------------------------------------------------------------------
set history=700		" Sets how many lines of history VIM has to remember
set nocompatible	" Will make vim bheave like vim not vi
set number		" Turn on the numbering, oh I love numbers.
set backup		" Make sure I make a backup of the file I am working.
set backupdir=~/vim/tmp/	" Place to put backups, create directory first.

" make sure that list mode is on so I can see the hidden characters and change
" what they look like.
set list
set listchars=tab:▸\ ,eol:¬
" Invisible character colours
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59


" -----------------------------------------------------------------------------
" Functions that just help things along
" Stab = sets the tab stuff globaly
" 
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

