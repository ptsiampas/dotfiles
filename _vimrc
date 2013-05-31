call pathogen#infect()
set history=700		" Sets how many lines of history VIM has to remember

" colo delek
color blackboard	" This is a file that exists in ~/.vim/colors/blackboard.vim
syntax on		" Turn on syntax highliting
set nocompatible

set number
set backupdir=~/vim/tmp/	" Place to put backups, create directory first.
set backup

" Show invisibles macros.. that I just LOVE!
nmap <leader>l :set list!<CR>
" Use the cool symbols.. 
set list
set listchars=tab:▸\ ,eol:¬
" Invisible character colours
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Activate spell checking \s
nmap <silent> <leader>s :set spell!<CR>

" Set to my region Australia
set spelllang=en_au

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif
" \v will edit the vimrc file in a new tab
map <leader>v :tabedit $MYVIMRC<CR>

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

" Only do this part when compiled with support for autocommands
" This sets up the correct tabs for various files, I may want to expand this
" to include extra files types that I work with.
if has("autocmd")
  " Enable file type detection
  filetype plugin indent on
   
  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
   
  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
   
  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss,*.atom setfiletype xml
endif

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

