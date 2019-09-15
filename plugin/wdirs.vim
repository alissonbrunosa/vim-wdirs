command -bang -nargs=* -complete=dir WdirsSearch call wdirs#dirs('workdir --print', 'Wdirs')
command -bang -nargs=0 -complete=dir WdirsAdd call wdirs#add_work_directory()
command -bang -nargs=* -complete=dir Wdirs
  \ call fzf#run({
  \   'source': 'workdir --print',
  \   'down' : '30%',
  \   'sink': function("wdirs#change_work_dir"),
  \   'options': '--prompt "WDirs> "' })

