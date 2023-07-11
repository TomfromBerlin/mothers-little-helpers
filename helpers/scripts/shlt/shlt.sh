#!/bin/env zsh
shlt_help() {
  cat <<EOH

  This script is intended to measure the load time of the active shell.
  Usage: shlt -h (show this help), shlt or shlt <integer>

  Example:
  "shlt" will start zsh 1 times and shows the load time using the time
  command. This will look like this:

  =============
  CPU    98%
  user   0,020
  system 0,01s
  total  0,034
  =============

  "shlt 10" will start zsh 10 times. If you use a plugin to measure
  execution times of commands (like zsh-cmd-time), you can divide
  the total time measured by the number of times the shell was loaded.
  This will give you an average value, as rounding errors are inevitable
  in the measurements.

EOH
}
shell_loading_time() {
export TIMEFMT=$'\n\e[1;34m =============\e[0m\n CPU\t\e[4;36m%P\e[0m\n user\t\e[4;36m%*U\e[0m\n system\t\e[4;36m%S\e[0m\n total\t\e[4;36m%*E\e[0m\n\e[1;34m =============\e[0m\n'
if [[ -z $1 ]]; then time $SHELL -i -c exit; else for i in {1..$1}; do time $SHELL -i -c exit; done; fi
}

shlt() {
if [[ $1 = "-h" ]]; then shlt_help
    else
    shell_loading_time $1
fi
}

shlt "$@"
