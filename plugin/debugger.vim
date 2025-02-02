let g:debugger_dictionary = {
      \ '\.rb':             'binding.break',
      \ '\.rake':           'binding.break',
      \ '\.ex$':            'require IEx; IEx.pry',
      \ '\.exs':            'require IEx; IEx.pry',
      \ '\.erb':            '<% binding.break %>',
      \ '\.haml':           '- binding.break',
      \ '\.eex':            '<%= require IEx; IEx.pry %>',
      \ '\.coffee$':        'debugger',
      \ '\.json\.jbuilder': 'binding.break',
      \ '\.js$':            'debugger;',
      \ '\.jsx$':           'debugger;',
      \ '\.rs$':            'println!("{:?}", );',
      \ '\.ts$':            'debugger;',
      \ '\.py$':            'import pdb; pdb.set_trace()',
      \ }

if exists("g:user_debugger_dictionary")
  call extend(g:debugger_dictionary, g:user_debugger_dictionary, "force")
endif

function! AddDebugger(direction)
  let debugger_statement = FindDebuggerStatement()

  if debugger_statement != ""
    execute "normal!" a:direction.debugger_statement
  else
    echo NoDebuggerFoundError()
  endif
endfunction

function! RemoveAllDebuggers()
  let debugger_statement = FindDebuggerStatement()

  if debugger_statement != ""
    let command = join(["g/", debugger_statement, "/d"], "")
    execute command
  else
    echo NoDebuggerFoundError()
  end
endfunction

function! FindDebuggerStatement()
  let current_file_extension = split(expand("%"), "/")[-1]

  for file_extension in keys(g:debugger_dictionary)
    if current_file_extension =~ file_extension
      return g:debugger_dictionary[file_extension]
    endif
  endfor

  return ""
endfunction

function! NoDebuggerFoundError()
  return "Couldn't figure out the debugger type, please add an entry for this file extension."
endfunction
