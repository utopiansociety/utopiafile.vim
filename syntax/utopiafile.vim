runtime! ftplugin/utopiafile.vim

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'utopiafile'
endif

" Separated into a match and region because a region by itself is always greedy
syn match  jsonStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=jsonString
syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ contains=jsonEscape contained

" Syntax: JSON does not allow strings with single quotes, unlike JavaScript.
syn region  jsonStringSQError oneline  start=+'+  skip=+\\\\\|\\"+  end=+'+

" Syntax: Escape sequences
syn match   jsonEscape    "\\["\\/bfnrt]" contained
syn match   jsonEscape    "\\u\x\{4}" contained

" Syntax: Numbers
syn match   jsonNumber    "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>\ze[[:blank:]\r\n]*[,}\]]"

" ERROR WARNINGS **********************************************
if (!exists("g:vim_utopiafile_warnings") || g:vim_utopiafile_warnings==1)
	" Syntax: Strings should always be enclosed with quotes.
	syn match   jsonNoQuotesError  "\<[[:alpha:]][[:alnum:]]*\>"
	syn match   jsonTripleQuotesError  /"""/

	" Syntax: An integer part of 0 followed by other digits is not allowed.
	syn match   jsonNumError  "-\=\<0\d\.\d*\>"

	" Syntax: Decimals smaller than one should begin with 0 (so .1 should be 0.1).
	syn match   jsonNumError  "\:\@<=[[:blank:]\r\n]*\zs\.\d\+"

	" Syntax: No comments in JSON, see http://stackoverflow.com/questions/244777/can-i-comment-a-json-file
	syn match   jsonCommentError  "//.*"
	syn match   jsonCommentError  "\(/\*\)\|\(\*/\)"

	" Syntax: No semicolons in JSON
	syn match   jsonSemicolonError  ";"

	" Syntax: No trailing comma after the last element of arrays or objects
	syn match   jsonTrailingCommaError  ",\_s*[}\]]"

	" Syntax: Watch out for missing commas between elements
	syn match   jsonMissingCommaError /\("\|\]\|\d\)\zs\_s\+\ze"/
	syn match   jsonMissingCommaError /\(\]\|\}\)\_s\+\ze"/ "arrays/objects as values
	syn match   jsonMissingCommaError /}\_s\+\ze{/ "objects as elements in an array
	syn match   jsonMissingCommaError /\(true\|false\)\_s\+\ze"/ "true/false as value
endif

" ********************************************** END OF ERROR WARNINGS
" Allowances for JSONP: function call at the beginning of the file,
" parenthesis and semicolon at the end.
" Function name validation based on
" http://stackoverflow.com/questions/2008279/validate-a-javascript-function-name/2008444#2008444
syn match  jsonPadding "\%^[[:blank:]\r\n]*[_$[:alpha:]][_$[:alnum:]]*[[:blank:]\r\n]*("
syn match  jsonPadding ");[[:blank:]\r\n]*\%$"

" Syntax: Boolean
syn match  jsonBoolean /\(true\|false\)\(\_s\+\ze"\)\@!/

" Syntax: Null
syn keyword  jsonNull      null

" Syntax: Braces
syn region  jsonFold matchgroup=jsonBraces start="{" end=/}\(\_s\+\ze\("\|{\)\)\@!/ transparent fold
syn region  jsonFold matchgroup=jsonBraces start="\[" end=/]\(\_s\+\ze"\)\@!/ transparent fold

syntax keyword utopiaKeywords
    \ app
    \ deployment
    \ environment
    \ name
    \ description
    \ git
    \ teams
    \ instances
    \ mem
    \ args
    \ cmd
    \ default
    \ dev
    \ stg
    \ prd


hi Keyword ctermfg=161 guifg=#d7005f
" Define the default highlighting.
if version >= 508 || !exists("did_json_syn_inits")
  hi def link utopiaKeywords Keyword
  hi def link jsonPadding		Operator
  hi def link jsonString		String
  hi def link jsonTest			Label
  hi def link jsonEscape		Special
  hi def link jsonNumber		Delimiter
  hi def link jsonBraces		Delimiter
  hi def link jsonNull			Function
  hi def link jsonBoolean		Delimiter

	if (!exists("g:vim_utopiafile_warnings") || g:vim_utopiafile_warnings==1)
		hi def link jsonNumError						Error
		hi def link jsonCommentError				Error
		hi def link jsonSemicolonError			Error
		hi def link jsonTrailingCommaError	Error
		hi def link jsonMissingCommaError		Error
		hi def link jsonStringSQError				Error
		hi def link jsonNoQuotesError				Error
		hi def link jsonTripleQuotesError		Error
  endif
  hi def link jsonQuote			Quote
  hi def link jsonNoise			Noise
endif


let b:current_syntax = "utopiafile"
if main_syntax == 'utopiafile'
  unlet main_syntax
endif

