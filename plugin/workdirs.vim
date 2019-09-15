if exists('g:fzf')
  function! s:fzf(src, cmd)
    call fzf#run({ 'source': a:src, 'sink': function('s:search_in_dir'), 'down': '30%', 'options': '--prompt "' . a:cmd . '> "' })
  endfunction

  function! s:add_work_directory()
    let dir = getcwd()
    call system("workdir --add " . dir)
  endfunction

  function! s:change_work_dir(dir)
    execute "cd " .  a:dir
    echo "Work directory changed to " . fnamemodify(a:dir, ":~:.")
  endfunction

  command -bang -nargs=* -complete=dir WdirsSearch call s:fzf('workdir --print', 'Wdirs')
  command -bang -nargs=0 -complete=dir WdirsAdd call s:add_work_directory()
  command -bang -nargs=* -complete=dir Wdirs call fzf#run({ 'source': 'workdir --print', 'sink': function("s:change_work_dir"), 'down': '30%', 'options': '--prompt "WDirs> "' })
else
  echo "Please install fzf plugin first"
endif
