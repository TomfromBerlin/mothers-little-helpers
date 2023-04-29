shlt_help () {
  cat <<EOH
 This script is intended to measure the load time of the active shell.
 Usage: zlt or zlt <integer>

 Example:
 "zlt" will start zsh 1 times and exit to parent shell.
 "zlt 10" will start zsh 10 times and exit to parent shell.
EOH
}
if [[ -z $1 ]]; then time $SHELL -i -c exit; else for i in {1..$1}; do time $SHELL -i -c exit; done; fi
