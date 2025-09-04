| ![Views](https://img.shields.io/endpoint?color=green&label=Views&logoColor=red&style=plastic&url=https%3A%2F%2Fhits.dwyl.com%2FTomfromBerlin%2Fmothers-little-helpers) | ![Unique Viewers](https://img.shields.io/endpoint?color=green&label=Unique%20Viewers&logoColor=pink&style=plastic&url=https%3A%2F%2Fhits.dwyl.com%2FTomfromBerlin%2Fmothers-little-helpers%3Fshow%3Dunique) |
|-|-|

# Mothers Little Helpers

## Disclaimer

This repository is provided to you in the hope that it will be helpful, but everything comes without any warranty and the owner of this repository is in no way responsible for any kind of harm, even if your cat dies while using one or more or all of these files.

## Licence

Some of the scripts may have their own license, if not, the [MIT license](https://opensource.org/license/mit/) applies.

## Usage

Copy the desired files into a dedicated directory where zsh can find it (e.g. `~/.config/zsh/plugins` or `~/zsh/plugins`; any directory in your fpath will be fine). Then (re)start zsh and the functions resp. scripts should be available on your system.

**If you use any kind of framework, please refer to their documentation to find out the proper directory and possible difficulties.**

## Tips & Tricks

- [How to make Debian 11 (bullseye) & unbound work together](/../../../../TomfromBerlin/Debian-Pihole-Unbound)
- [How to fix incorrect scaling of KDE Plasma when using a nvidia card with propietary dirvers](helpers/kde-nvidia)

## Functions

More information and how to use shell functions can be found [here](https://zsh.sourceforge.io/Doc/Release/Functions.html).

- [allcolors](helpers/scripts/functions/allcolors) - shows the escape sequences for colors in the terminal
- [chpwd](helpers/scripts/functions/chpwd) - auto-ls after each directory change (zsh only)
- [temp_conv](helpers/scripts/functions/temp_conv) - Script to convert temperature values (Celsius, Fahrenheit, Kelvin). The output includes joules and electron volts. You will be asked to enter the value you want to convert and will receive all conversions as a result.

<details><summary>Details for temp_conv</summary>
  You will be prompted for nessecary input and the output is colored. If you want to have background information type `absolute_zero` at the command line and press enter (you must not run the script for this function).
  For conversion type `temp_conv` at the command line, press Enter and use one of the following options (case insensitive):

| Command | Option | Purpose |
|:---------:|:---------:|:---------:|
| `temp_conv` | `CF` | for Celsius -> Fahrenheit -> Kelvin -> Joule -> Electron Volt conversion |
| `temp_conv` | `FC` | for Fahrenheit -> Celsius -> Kelvin -> Joule -> Electron Volt conversion |
| `temp_conv` | `KC` | for Kelvin -> Celsius -> Fahrenheit -> Joule -> Electron Volt conversion |
| `absolute_zero` |  | further information about the Third Law of Thermodynamics and more... |

 For example, if you have a temperature in Fahrenheit and want to convert it to Kelvin, you need to run the script and enter "fc" when prompted and press `Enter`. The following prompt looks like this:

`Please enter a value for Fahrenheit:`

Enter a value (e.g. `100`) and receive the output presenting the results. It looks like this:

`The conversion formula is (100°F − 32) × 5/9 and gives 37.7778°C, which is 310.928 Kelvin, 4.29283e-21 Joules and 3.60816e+06 eV.`

</details>

- [title](helpers/scripts/funtions/title) - show command in window title bar (zsh only)
- [topcmd](helpers/scripts/functions/topcmd) - display frequently used commands of the current shell session or the entire command history.
- [zprofiler](helpers/scripts/zprofiler) - profiling of the Z shell with instructions for configuration, if necessary
- [checkport](helpers/scripts/functions/checkport) - Tiny function for zsh that shows which processes are listening or communicating on which TCP ports. It determines whether the system language is German. If this is the case, the output is in German, otherwise in English.
- ~[zsh_wifi_signal](helpers/scripts/functions/zsh_wifi_signal) - shows wifi signal strength in a terminal (zsh only)~

## Scripts

- [zramswap](helpers/scripts/zramswap) - install a compressed swapfile in RAM
- [shlt](helpers/scripts/shlt) - measure loading time of the shell
- [zrecompile](helpers/scripts/misc/zrecompile) - compile functions and dot-files, if necessary (zsh only)
- [PS4-demo](helpers/scripts/misc/PS4_demo.sh) - demonstrate the functionality of the PS4 prompt variable
- [what_shell](helpers/scripts/misc/what_shell) - show the (sub-)shell that is currently used. usage: `source what_shell` (the file should live somewhere in your $PATH)
- [progress bar](https://github.com/TomfromBerlin/mothers-little-helpers/tree/main/helpers/scripts/progress%20bar) - a progress bar purely written as a shell script

## Information tools for command line

- [screenFetch](https://github.com/KittyKatt/screenFetch) - The Bash Screenshot Information Tool
- [Neofetch](https://github.com/dylanaraps/neofetch) - command-line system information tool
