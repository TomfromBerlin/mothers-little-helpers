#!/bin/env zsh

local GREEN='\033[0;32m'
local RED='\033[0;31m'
local YELLOW='\033[0;33m'
local CYAN='\e[0;36;40m'
local BLUE='\e[0;34;40m'
local MAGENTA='\e[0;35;40m'
local RESET='\033[0m'
# local ls='ls --color=auto --human-readable --group-directories-first --classify'
[[ $(ps -cp "$$" -o command="") != "zsh" ]] && echo -en "\n$BLUE This script is intended for use in a Z shell environment.\n Dont' use $RED$(ps -cp "$$" -o command="") $0$BLUE, use$RED zsh PS4_demo.sh$BLUE instead!\n\n" && echo -en "$RESET" && exit;
echo -e "\n This script demonstrates the functionality of the PS4 prompt variable.\n$RED Since some long lines are output in the second part,\n you should set your terminal to full screen.$RESET\n\n For the script to work, we need to define this variable: (line breaks for readability only)"
echo -e " PS4='\n   $GREEN%F{white}eval depth: %F{green}%e%f\n $CYAN- %F{white}exec: %F{cyan}%x%f%\n $BLUE- %F{white}source: %F{blue}%N%f%\n $MAGENTA- %F{white}line no.: %F{magenta}%I%f\n$YELLOW - %F{white}code: %F{yellow} ""$RESET""\n'"
echo -e " It will show\n the$GREEN evaluation depth$RESET,\n the$CYAN name of the executed file$RESET,\n the$BLUE name of the sourced file$RESET,\n the$MAGENTA line no.$RESET,\n the$YELLOW executed code$RESET\n as well as the standard output.\n"
echo -e ""$BLUE" We will temporarily overwrite any existing PS4 definitions, and restore it afterwards.\n If you do not want that, "$RED"press CTRL-C to exit"$BLUE", or to continue "$GREEN"press any key"$RESET"..."; read -r -k1 -s
[[ -n "$PS4" ]] && PS4_TMP="$PS4"
export PS4_TMP
PS4='%F{white}eval depth: %F{green}%e%f - %F{white}exec: %F{cyan}%x%f%  - %F{white}source: %F{blue}%N%f%  - %F{white}line no.: %F{magenta}%I%f - %F{white}code: %F{yellow} '
export PS4
clear
echo "\n----------------------------------------------------------------------"
echo "$YELLOW This is the output$GREEN without$YELLOW tracing --> ' -x' is not set$RESET\n"
echo -e "$CYAN Your terminal is $MAGENTA$(tput longname)$CYAN, current window width is $MAGENTA$(tput cols) columns$CYAN and height is $MAGENTA$(tput lines) lines$RESET."
echo -e "$RED $(ps -cp "$$" -o command="") $0$RESET was entered as a command"
echo -e "$RED $(command ls -l /etc/ | wc -l)$RESET entries in /etc/ (without hidden ones)"
echo -e "$RED $(command du -sh ~)$RESET size and name of the user's home directory"
echo -e "\n |------------------------------|\n | ""$GREEN""Press any key to continue...""$RESET"" |\n |------------------------------|"
echo "----------------------------------------------------------------------\n"; read -r -k1 -s
echo -e "$YELLOW This is the output$GREEN with$YELLOW tracing --> ' -x' is set with 'set -x'\n It should be noted here that aliases are expanded and not the aliases themselves are displayed.\n Also we prefix$MAGENTA ls$YELLOW and$MAGENTA du$YELLOW with 'command' to avoid using aliases. This prefix is not displayed either.$RESET\n" && set -x
echo -e "$CYAN Your terminal is $MAGENTA$(tput longname)$CYAN, current window width is $MAGENTA$(tput cols) columns$CYAN and height is $MAGENTA$(tput lines) lines.$RESET\n"
echo -e "$RED $(ps -cp "$$" -o command="") $0$RESET was entered as a command\n"
echo -e "$RED $(command ls -l /etc/ | wc -l)$RESET entries in /etc/ (without hidden ones)\n"
echo -e "$RED $(command du -sh ~)$RESET size and name of the user's home directory\n"
[[ -n "$PS4_TMP" ]] && PS4="$PS4_TMP"
export PS4
unsetopt -x
echo -e "$BLUE\n |-------------------------------------------------|\n |     Your PS4 prompt var has been restored.      |\n |                End of demo script               |\n |-------------------------------------------------|\n$RESET"
