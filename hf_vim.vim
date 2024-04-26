function! SaveVisibleLines(dest)
  let l:visibleLines = []
  let lnum = 1
  while lnum <= line('$')
    if foldclosed(lnum) == -1
      call add(l:visibleLines, getline(lnum))
      let lnum += 1
    else
      call add(l:visibleLines, getline(foldclosed(lnum)))
      call add(l:visibleLines, "...")
      call add(l:visibleLines, getline(foldclosedend(lnum)))
      let lnum = foldclosedend(lnum) + 1
    endif
  endwhile
  call writefile(l:visibleLines, a:dest)
endfunction

function! FillHoles(model)
  if (bufname('%') == '')
      let l:tmpFile = tempname()
      exec "w " . l:tmpFile
  else
      exec 'w'
      let l:tmpFile = expand('%:p') 
  endif
  call SaveVisibleLines('.fill.tmp')
  exec '!NODE_NO_WARNINGS=1 holefill ' . l:tmpFile . ' .fill.tmp ' . a:model
  exec '!rm .fill.tmp'
  exec 'edit!'
endfunction
