# topcmd

<details>
  <summary> This script provides a utility for analyzing and displaying the most frequently used commands from the shell's command history. It offers various options to customize the output and provides helpful information for configuring the history function in zsh. </summary>

## Description

The function checks if the first argument ($1) is empty. If it is, it means no argument was provided, and the function proceeds to display the most frequently used commands in the current session.

If an argument is provided, the function uses a case statement to handle different argument options. The following options are supported:

 `-v` - Displays the most frequently used commands divided by the provided arguments.

 `-vx` - Displays the most frequently used commands in the entire command history divided by the provided arguments.

 `-c` - Displays an example configuration for the history function.

 `-h` or `--help` - Displays detailed usage instructions and examples.

The function uses ANSI escape sequences to format and colorize the output, providing visual cues and highlighting important information.

It is worth noting that the code is somewhat bloated. That seems to be the toll you have to pay if you want to make all souls happy. In other words: Under Linux, the "column" command knows headers, whereas under MacOS and FreeBSD it does not. The result is that under Linux you have nice headers in the tables. Under MacOS and FreeBSD you have to do without.
  
</details>
