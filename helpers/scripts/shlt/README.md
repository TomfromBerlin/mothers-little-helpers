# shlt

This script is intended to measure the load time of the active shell.

Usage: `shlt` or `shlt <integer>`

Example:

`shlt` will start the active shell 1 times as a subshell and exit to parent shell.

`shlt 10` will start the active shell 10 times as a subshell and exit to parent shell.

It is just a one-liner:

```
if [[ -z $1 ]]; then time $SHELL -i -c exit; else for i in {1..$1}; do time $SHELL -i -c exit; done; fi
```

Download the script [here](shlt.sh)
