$Message = "
                /'''\
               |\__/|
               |       |
               |       |
               |>-<|
               |       |
        /'''\|        |/'''\...
 /''\|       |       |       |   \
|      |       |       |       |    \
|      |       |       |       |      \
|  ~     ~     ~     ~  |)       )
|                                      /
 \                                   /
   \                               /
     \                           /
      |                         |
      |                         |
"
$c = New-Object -Comobject wscript.shell
$b = $c.popup("$Message",0," Wins!",0)