scriptencoding utf-8
set nocompatible        " Use Vim defaults (much better!)

" --- pathogen --- {{{
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#incubate()
call pathogen#helptags()
" }}}

" -- ctags --- {{{
let g:ctags_statusline=1
let g:generate_tags=1
set tags=./tags,./TAGS,tags,TAGS,~/qt-tags
"  }}}

" --- DetectIndent --- {{{
autocmd BufReadPost * :DetectIndent
"  }}}


" --- basic settings --- {{{
set sws=                " Disable swapfile syncing (in order to support laptop-mode)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command line history
map Q gq                " Don't use Ex mode, use Q for formatting
set numberwidth=3
set number
set shiftwidth=4
set tabstop=4
set laststatus=2
set incsearch
"set ruler               " Show the cursor position all the time
"
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%{TagName()}\ %-14.(%l,%c%V%)\ %P

filetype plugin on
filetype indent on

set grepprg=grep\ -nH\ $*

if has("gui_running")
  set guioptions-=T
  set guioptions-=m
  set guioptions+=c

  set guifont=terminus\ 12
endif

set background=light
set t_Co=16
colors solarized
" }}}

" --- syntax highlighting --- {{{
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  let g:load_doxygen_syntax=1
endif
" }}}

" --- handling special files --- {{{
" When doing tab completion, give the following files lower priority. You may
" wish to set 'wildignore' to completely ignore files, and 'wildmenu' to enable
" enhanced tab completion. These can be done in the user vimrc file.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

if has("autocmd")	" Only do this part when compiled with support for autocommands.

	augroup filetypedetect
     au BufRead,BufNewFile *.pro         setfiletype make
     au BufRead,BufNewFile *.docbook     setfiletype xml
     au BufRead,BufNewFile *.asy         setfiletype asy
     au BufRead,BufNewFile *.tex          set spell spelllang=de
   augroup END

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 80 characters.
		autocmd FileType text setlocal textwidth=80

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
					\ if line("'\"") > 0 && line("'\"") <= line("$") |
					\   exe "normal g`\"" |
					\ endif
	augroup END

   augroup skeletons
     autocmd!

     " insert skeleton
     autocmd BufNewFile *.h,*.cpp 0r ~/.vim/skeleton.cpp
     " insert file name into comment head
     autocmd BufNewFile *.h,*.cpp call setline(2, getline(2) . expand("%:t"))
     " insert current year after copyright mark
     autocmd BufNewFile *.h,*.cpp exe "1,20s/: (C)/: (C) " . strftime("%Y")
     " go to end of file
     autocmd BufNewFile *.h,*.cpp $

     " header files: insert #ifndef/#define/#endif guards
     autocmd BufNewFile *.h call CHeaderGuards()
     " header files: assuming it belongs to a C++ project, insert class definition
     autocmd BufNewFile *.h exe "normal iclass " . expand("%:t:r") . "\<CR>{\<CR>};\<CR>" | -2

     " source files: include an associated header
     autocmd BufNewFile *.cpp exe "normal i#include \"" . expand("%:t:r") . ".h\"\n\n"
   augroup END

   fun! CHeaderGuards()
     let macroname = toupper(substitute(expand("%:t:r"), "\\(.\\)\\([A-Z]\\)", "\\1_\\2", "g")) . "_H"
     exe "normal i#ifndef " . macroname . "\<CR>#define " . macroname . "\<CR>\<CR>\<CR>#endif // ifndef " . macroname
     -1
   endfunction

endif " has("autocmd")
" }}}

" {{{ various fixes and special-case handling
if &term ==? "xterm"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif
" }}}

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :

