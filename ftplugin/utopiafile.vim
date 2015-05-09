" ftplugin/utopiafile.vim
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal completefunc=syntaxcomplete#Complete

"have warnings by default
if !exists("g:vim_utopiafile_warnings")
	let g:vim_utopiafile_warnings = 1
end
