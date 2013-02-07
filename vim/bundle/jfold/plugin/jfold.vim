" jfold - Intelligent folding for vim
" By Jim Babcock

"# Representative line extraction
function IsGoodRepresentativeLine(text)
	" Does this look like a comment (or blank) line? We assume something's a
	" comment line if it starts with a slash (//-style or /* opening), a *
	" (continuation of a /* style comment), a # (shell-style comment,
	" except in CSS files), or a double quote (vimscript comment). Also exclude
	" lines starting with @ (Python attributes).
	if !(a:text =~ '[a-zA-Z0-9]')
		return 0
	endif
	if a:text =~ '^[ \t]*[/*@"]' || (a:text =~ '^[ \t]*#' && &l:filetype != 'css')
		" If this is a comment line, include it only if it (a) contains a fold
		" marker and (b) contains an alphanumeric character.
		" So '// Header text {{{' is representative, but '// }}}' or '// Regular
		" comment' is not.
		if a:text =~ '{{{' && a:text =~ '[a-zA-Z0-9_]'  "}}}
			return 1
		else
			return 0
		endif
	else
		return 1
	endif
endfunction

function GetRepresentativeLine(foldStart, foldEnd)
	let foldedLineCount = a:foldEnd - a:foldStart
	let lineNum = 0
	
	" Choose a representative line from inside the fold
	while lineNum < foldedLineCount
		let representativeLine = getline(v:foldstart+lineNum)
		if IsGoodRepresentativeLine(representativeLine)
			return representativeLine
		endif
		let lineNum = lineNum + 1
	endwhile
	
	" If we went through the whole fold without finding a good
	" representative line, lower the standards to "contains at least one
	" alphanumeric character" and try again.
	let lineNum = 0
	while lineNum < foldedLineCount
		let representativeLine = getline(v:foldstart+lineNum)
		if representativeLine =~ '[a-zA-Z0-9_]'
			return representativeLine
		endif
		let lineNum = lineNum + 1
	endwhile
	
	" If still no good representative line, take the first line that has a
	" non-whitespace character
	let lineNum = 0
	while lineNum < foldedLineCount
		let representativeLine = getline(v:foldstart+lineNum)
		if representativeLine =~ '[^ \t]'
			return representativeLine
		endif
		let lineNum = lineNum + 1
	endwhile
	
	return ''
endfunction

function AddSpecialComment(initial, text)
	" Collect special comments
	let m = matchstr(a:text, '\(TODO\|FIXME\|NOTE\|NOTES\|XXX\|STUB\)')
	if strlen(m) > 0
		if a:initial == ''
			return ' //' . m
		else
			return a:initial . ' ' . m
		endif
	endif
	return a:initial
endfunction

function GetFoldText()
  return GetFoldTextForLines(v:foldstart, v:foldend+1)
endfunction

" start inclusive, end exclusive
function GetFoldTextForLines(start, end)
	let foldedLineCount = a:end - a:start
	let representativeLine = GetRepresentativeLine(a:start, a:end)
	let lineNum = 0
	
	" Collect special comments (TODO, FIXME, etc)
	let specialComments = ''
	while lineNum < foldedLineCount
		let line = getline(a:start+lineNum)
		let specialComments = AddSpecialComment(specialComments, line)
		let lineNum = lineNum + 1
	endwhile
	
	let nucolwidth = &fdc + &number * &numberwidth
	let windowWidth = winwidth(0) - nucolwidth
	
	" Convert tabs to spaces and prepend a '+'
	let foldText = '+' . substitute(representativeLine,'\t','    ','g') . specialComments
	
	" Line up folded text by collapsing two spaces into one where possible
	" (This undoes any misalignment in tables and such that adding the '+'
	" would have caused)
	let foldText = substitute(foldText,'  ',' ','')

	let fillCharCount = windowWidth - len(foldText) - len(foldedLineCount) - 2
	return foldText . repeat(" ", fillCharCount) . ' ' . foldedLineCount
endfunction


function GetFoldLevel()
	return FoldLevelForLine(v:lnum)
endfunction

" Given a range of lines which meets the autofolding heuristic, decide whether
" the range should be folded. We want this to be true for functions, and false
" for most other things. Heuristic: Fold only if it contains at least one
" indented line.
function ShouldFoldRange(start, end)
	for ii in range(a:start, a:end)
		let line = getline(ii)
		if line =~ "^[ \t]+[^ \t]"
			return 1
		endif
	endfor
	return 0
endfunction

function FoldLevelForLine(lineNumber)
	let line = getline(a:lineNumber)

	" Check for explicit fold markers
	if (line =~ "{{{" && !(line =~ "}}}"))
		return 'a1'
	elseif (line =~ "}}}" && !(line =~ "{{{"))
		return 's1'
	endif
	
	if line =~ '^\(//\|"\)#'
		return '0'
	endif

	if LineIsFoldCloseCandidate(a:lineNumber)
		let open = FindMatchingFoldOpen(a:lineNumber)
		if FoldIsValid(open, a:lineNumber+1)
			return '<1'
		endif
	endif
	if LineIsFoldOpenCandidate(a:lineNumber)
		let close = FindMatchingFoldClose(a:lineNumber)
		if FoldIsValid(a:lineNumber, close)
			return '>1'
		endif
	endif
	
	return '='
endfunction

" Given a line number on which a fold-candidate starts, find the corresponding
" fold-candidate end. If there is no matching end, returns -1. Go at most 1k
" lines, to avoid slowness
function FindMatchingFoldClose(lineNumber)
	let ii = a:lineNumber+1
	while nextnonblank(ii-1) > 0 && ii < a:lineNumber + 1000
		if LineIsFoldCloseCandidate(ii)
			if FoldCandidatesMatch(a:lineNumber, ii)
				return ii
			endif
		endif
		let ii = ii+1
	endwhile
	return -1
endfunction

" Given a line number on which a fold-candidate ends, find the corresponding
" fold-candidate start.
function FindMatchingFoldOpen(lineNumber)
	let ii = prevnonblank(a:lineNumber-1)
	while ii > 0 && ii > a:lineNumber - 1000
		if LineIsFoldOpenCandidate(ii)
			if FoldCandidatesMatch(ii, a:lineNumber)
				return ii
			endif
		endif
		let ii = prevnonblank(ii-1)
	endwhile
	return -1
endfunction

function LineIsFoldCloseCandidate(lineNumber)
	if(a:lineNumber < 1)
		return 0
	endif

	" If blank, and previous line is top-level and nonblank, end fold
	let line = getline(a:lineNumber)
	let prevline = getline(a:lineNumber - 1)
	if (line =~ '{')
		return 0
	endif
	if line =~ "^[ \t]*$" && prevline =~ "^[^ \t]"
		return 1
	else
		return 0
	endif
endfunction

function LineIsFoldOpenCandidate(lineNumber)
	if(a:lineNumber < 1)
		return 0
	endif

	let line = getline(a:lineNumber)
	let prevline = getline(a:lineNumber - 1)
	if (line =~ '}')
		return 0
	endif
	
	" Line is not indented, and previous line is either blank, starts with the
	" unfolded-comment marker //#, or is all close-delimiters.
	if (line =~ "^[^ \t]") && (prevline =~ '^\s*$' || prevline =~ '^\(//\|"\)#')
		return 1
	else
		return 0
	endif
endfunction

" Given a pair of lines that are start and end fold-candidates, return whether
" they can possibly match.
function FoldCandidatesMatch(startLine, endLine)
	if GetIndentLevel(getline(a:startLine)) == GetIndentLevel(getline(a:endLine))
		return 1
	else
		return 0
	endif
endfunction

" Given a range of lines (inclusive start, exclusive end) and a fold type,
" return whether it's a valid fold.
function FoldIsValid(startLine, endLine)
	if a:startLine<0 || a:endLine<0
		return 0
	endif
	
	let firstLine = getline(a:startLine)
	let minIndent = GetIndentLevel(firstLine)
	let maxIndent = GetIndentLevel(firstLine)
	
	let ii = nextnonblank(a:startLine)
	while ii < a:endLine && ii > 0
		let line = getline(ii)
		let indentLevel = GetIndentLevel(line)
		if indentLevel < minIndent
			let minIndent = indentLevel
		endif
		if indentLevel > maxIndent
			let maxIndent = indentLevel
		endif
		let ii = nextnonblank(ii+1)
	endwhile
	
	" Only fold ranges that contain some indented code
	if minIndent == maxIndent
		return 0
	endif
	return 1
endfunction


"# Util
function GetIndentLevel(str)
	let ret = 0
	for ii in range(strlen(a:str))
		if a:str[ii] == "\t"
			let ret = ret + 4 "FIXME: Respect tabstop option
		elseif a:str[ii] == ' '
			let ret = ret + 1
		else
			return ret
		endif
	endfor
	return ret
endfunction

function IsBlank(str)
	return a:str =~ '^\s*$'
endfunction

function IsSpecialComment(str)
	return a:str =~ '##'
endfunction


"# Python folding
function PythonFold()
  return PythonFold_LevelForLine(v:lnum)
endfunction

" Get the fold level for the given line. If the line is blank and the previous
" line is nonblank, this is the fold level for the previous line. Otherwise,
" this is the fold level for the last line in the run of lines with the same
" indent level, which is found by searching lines before that for lines at
" lesser or equal indentation levels for folds, and checking their extents.
function PythonFold_LevelForLine(lineNumber)
	if IsBlank(getline(a:lineNumber)) && (a:lineNumber>0 && !IsBlank(getline(a:lineNumber-1)))
		let initLine = a:lineNumber-1
		let currentIndentLevel = GetIndentLevel(getline(initLine))
	else
		let initLine = a:lineNumber
		let currentIndentLevel = GetIndentLevel(getline(initLine))
		while PythonFold_MayPrecedePrototype(getline(initLine)) && GetIndentLevel(getline(initLine+1)) == currentIndentLevel
		  let initLine = initLine+1
		endwhile
	endif
	let folds = 0
	let pos = initLine
	let isFoldStart = 0
	let isFoldEnd = 0
	
	while pos > 0
		let line = getline(pos)
		if !IsBlank(line)
			let indentLevel = GetIndentLevel(line)
			
			" Only look at lines that are indented at most as much as the
			" least-indented line we've seen so far in our traversal.
			if indentLevel <= currentIndentLevel
				if indentLevel < currentIndentLevel
					let currentIndentLevel = indentLevel
				endif
				
				if PythonFold_FoldForLine(line)
					let foldStart = PythonFold_GetStart(pos)
					let foldEnd = PythonFold_GetEnd(pos, initLine+3)
					if foldStart == a:lineNumber
						let isFoldStart = 1
					endif
					if foldEnd == a:lineNumber
						let isFoldEnd = 1
					endif
					if foldStart <= initLine && foldEnd >= initLine
						let folds = folds+1
					endif
					let pos = foldStart
					let currentIndentLevel = indentLevel-1
				endif
				
				if currentIndentLevel == 0
					break
				endif
			endif
		elseif currentIndentLevel == 0
		  " If we made it up to the unindented level, a blank line is definitely
		  " not part of any folds.
		  break
		endif
		let pos = pos-1
	endwhile
	
	if isFoldStart == 1
		return '>' . folds
	elseif isFoldEnd == 1
		return '<' . folds
	else
		return folds
	endif
endfunction

" Returns whether the line indicates a fold - that is, if it:
"   - Starts with 'def' or 'class', and
"   - Has a ':' to indicate lines under it
function PythonFold_FoldForLine(line)
	return a:line =~ '^\s*\(def\|class\).*:'
endfunction

" Given the line number of a line that indicates a fold (that is,
" PythonFold_FoldLine is true for it), find the start of the fold. This goes
" up through any nonblank lines at the same indent level which start with @
" (denoting an attribute on the function or class) or # (denoting a header
" comment).
function PythonFold_GetStart(lineNumber)
	let pos = a:lineNumber - 1
	let indentLevel = GetIndentLevel(getline(a:lineNumber))
	
	while pos>0
		let newLine = getline(pos)
		if IsBlank(newLine)
			break
		endif
		
		let newIndentLevel = GetIndentLevel(newLine)
		if newIndentLevel != indentLevel
			break
		endif
		
		if !PythonFold_MayPrecedePrototype(newLine)
			break
		endif
		
		let pos = pos-1
	endwhile
	
	return pos+1
endfunction

function PythonFold_MayPrecedePrototype(line)
  return a:line =~ '\s*[#@]'
endfunction

" Given the line number of a line that indicates a fold, return the lesser of
" lastLine or the end of the fold. This goes down through any lines that are
" blank or at greater indent levels, stopping at less or equal indent levels,
" then returns the last valid line, or the first blank line in the run of
" blank lines that ended it if there was one.
function PythonFold_GetEnd(lineNumber, lastLine)
	let foldIndentLevel = GetIndentLevel(getline(a:lineNumber))
	let pos = a:lineNumber + 1
	let lastNonblank = a:lineNumber + 1
	while pos < a:lastLine
		let line = getline(pos)
		if !IsBlank(line)
			let indentLevel = GetIndentLevel(line)
			if indentLevel <= foldIndentLevel
				" Found the end of the fold
				if pos == lastNonblank+1
					return lastNonblank
				else
					return lastNonblank+1
				endif
			else
				let lastNonblank = pos
			endif
		endif
		let pos = pos+1
	endwhile
	return a:lastLine
endfunction


set foldmethod=expr
set foldtext=GetFoldText()
set foldexpr=GetFoldLevel()
set fillchars=fold:\ 

