function! wdirs#dirs(src, cmd)
  call fzf#run({ 'source': a:src, 'sink': function('wdirs#search_in_dir'), 'down': '30%', 'options': '--prompt "' . a:cmd . '> "' })
endfunction

function! wdirs#add_work_directory()
  let dir = getcwd()
  call system("workdir --add " . dir)
endfunction

function! wdirs#change_work_dir(dir)
  execute "cd " .  a:dir
  echo "Work directory changed to " . fnamemodify(a:dir, ":~:.")
endfunction

function! wdirs#search_in_dir(dir)
  let short = fnamemodify(a:dir, ":~:.")
  let cmd = "ag -l "" ". a:dir

  call fzf#run({ "source": cmd, "sink": "e", "down": "30%", "options": "--prompt '" . short . ">'" })
endfunction


