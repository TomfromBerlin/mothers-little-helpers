#!/bin/env zsh

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\e[0;36;40m'
BLUE='\e[0;34;40m'
MAGENTA='\e[0;35;40m'
RESET='\033[0m'
[[ $(ps -cp "$$" -o command="") != "zsh" ]] && echo -en "$RED" && echo "This script is intended for use in a Z shell environment." && echo -en "$RESET" && exit;
echo -e " This script demonstrates the functionality of the PS4 prompt variable.\n For it to work, we need to define this variable:\n (line breaks for readability only)"
echo -e " PS4='\n   ""$GREEN""%F{white}eval depth: %F{green}%e%f\n ""$CYAN""- %F{white}exec: %F{cyan}%x%f%\n ""$BLUE""- %F{white}source: %F{blue}%N%f%\n ""$MAGENTA""- %F{white}line no.: %F{magenta}%I%f\n""$YELLOW"" - %F{white}code: %F{yellow} ""$RESET""\n'"
echo "$RESET"
echo -e " It will show\n the ""$GREEN""evaluation depth$RESET,\n the ""$CYAN""name of the executed file""$RESET"",\n the""$BLUE"" name of the sourced file""$RESET"",\n the ""$MAGENTA""line no.""$RESET"",\n the ""$YELLOW""executed code""$RESET""\n as well as the""$YELLOW"" standard output.\n"
echo -e " ""$RED""We will overwrite any existing definition of PS4, and restore it afterwards.\n If you do not want that, press CTRL-C to exit, or"
echo -e "\n ""$RESET""|------------------------------|\n | ""$GREEN""Press any key to continue...""$RESET"" |\n |------------------------------|"; read -r -k1 -s
echo ""
[[ -n "$PS4" ]] && PS4_TMP="$PS4" && export PS4_TMP
PS4='%F{white}eval depth: %F{green}%e%f - %F{white}exec: %F{cyan}%x%f%  - %F{white}source: %F{blue}%N%f%  - %F{white}line no.: %F{magenta}%I%f - %F{white}code: %F{yellow} '
export PS4
clear
echo ""
echo "----------------------------------------------------------------------"
echo " ""$YELLOW""This is the output without tracing --> ' -x' is not set""$RESET"""
echo ""
echo "PS4 demo script"
ls -l /etc/ | wc -l
du -sh ~
echo ""
echo "----------------------------------------------------------------------"
echo ""
echo -e "\n ""$RESET""|------------------------------|\n | ""$GREEN""Press any key to continue...""$RESET"" |\n |------------------------------|"; read -r -k1 -s
echo ""
echo "----------------------------------------------------------------------"
echo ""
echo -e " ""$YELLOW""This is the output with tracing --> ' -x' is set with 'set -x'\n""$RESET""" && set -x
echo "PS4 demo script"
ls -l /etc/ | wc -l
du -sh ~
[[ -n "$PS4_TMP" ]]
PS4="$PS4_TMP"
export PS4
unsetopt -x
echo "$RESET"
echo -e "Your PS4 prompt var has been restored."
echo -e "End of demo script\n"
