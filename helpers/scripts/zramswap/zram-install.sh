#!/bin/bash
# shellcheck shell=bash
#########################################################################
# Usage: sh zram-install                                                #
################################################################################
#                                                                              #
# Copyright 2023 Thomas Bernard (https://github.com/TomfromBerlin)             #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining a copy #
# of this software and associated documentation files (the “Software”), to     #
# deal in the Software without restriction, including without limitation the   #
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  #
# sell copies of the Software, and to permit persons to whom the Software is   #
# furnished to do so, subject to the following conditions:                     #
#                                                                              #
# The above copyright notice and this permission notice shall be included in   #
# all copies or substantial portions of the Software.                          #
#                                                                              #
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS #
# IN THE SOFTWARE.                                                             #
#                                                                              #
################################################################################
#                                                                       #
# Description:                                                          #
# If you run a Raspberry Pi with a SD card as the system drive,         #
# you may want to consider to have the swapfile installed               #
# in your RAM to reduce write access to the SD card.                    #
#                                                                       #
# This will extend the life time of your SD card.                       #
#                                                                       #
#            This script installs a compressed RAM drive that is        #
#                         used as a swap drive.                         #
#                                                                       #
#        All commands are explained in the code when they occure.       #
#                                                                       #
#########################################################################
#                                                                       #
#        Every thing below this line comes without any warranty.        #
#                    Use it at your own risk.                           #
#                                                                       #
#########################################################################
clear
echo -e " \e[1;36m This is intended to be used on a Raspberry Pi with low memory"
echo -e "\e[1;32m"
echo -e "              ....               ..."
echo -e "         ..............     .............."
echo -e "         ...............  ................"
echo -e "          ............... ..............."
echo -e "           .......... ..   ............."
echo -e "            ..........       .........."
echo -e "\e[1;35m                ...    ....    ..."
echo -e "              ..... .......... ......"
echo -e "            ......  ..........  ......."
echo -e "           ....  ...  ......  ...   ...."
echo -e "           ..  ........ ..  ........  .."
echo -e "         ..   ..........  ...........  .."
echo -e "        .... ............ ........... ....."
echo -e "       ..... ...........   ..........  ...."
echo -e "       ....   ........  ...  ........  ...."
echo -e "        ...     ....  .......  ....     .."
echo -e "           ....     ...........    ....."
echo -e "          .......  ............  ........"
echo -e "          ........  ........... ........."
echo -e "           ........  ......... ........."
echo -e "             ......    .....    ......"
echo -e "                ..  ..  ...  ..  .."
echo -e "                    ..........."
echo -e "                      ......."
echo -e " "
echo -e " "
echo -e "\e[0m"
echo "         Do you want to install zram-tools"
echo -n "       and establish a swapfile in your RAM? " && read -r ans_yn
   case "$ans_yn" in
      [Yy]|[Yy][Ee][Ss]) echo -e "\n Here we go...";;
               *) echo -e "\e[1;31m Abort!\e[0m" && exit 3 ;;
   esac
echo -e "\e[0m"
#########################################################################
# Start install process
#
# show only questions that one really, really need to see
DEBIAN_PRIORITY=critical
export DEBIAN_PRIORITY
# check if zram is already installed
# if it is installed we only check the status and display mem stats,
# since we do not want to change any existing configuration by accident
if [[ ! -x /usr/bin/zramctl ]]; then
# you must not issue the following command from command line
DEBIAN_FRONTEND=noninteractive
# DEBIAN_FRONTEND is an apt-get variable, obviously it is for Debian-based environments.
# https://www.cyberciti.biz/faq/explain-debian_frontend-apt-get-variable-for-ubuntu-debian/
# no w we download the package, and install it, if it is not installed
sudo apt-get -yq install zram-tools < /dev/null > /dev/null
# the switch [-yq] answers [y]es to apt-get and makes the output more or less [q]uiet;
# [< /dev/null > /dev/null] redirects the remaining output (stdin, stdout) to nowhere, only errors will be shown
# now we get back to the default frontend for apt/apt-get
export DEBIAN_FRONTEND=dialog
echo " Compression algorithm comparison"
echo -e "      speed:            \e[0;32mlz4\e[0m > \e[0;32mlz4hc\e[0m > \e[1;32mzstd\e[0m > \e[0;33mlzo-rle\e[0m > \e[0;33mlzo\e[0m > \e[0;31m842\e[0m"
echo -e "      de-/compression:  \e[1;32mzstd\e[0m > \e[0;33mlzo-rle\e[0m > \e[0;33mlzo\e[0m > \e[0;32mlz4hc\e[0m > \e[0;32mlz4\e[0m > \e[0;31m842\e[0m"
echo -e "\n \e[0;32mzstd\e[0m seems to be the best compromise between speed and compression ratio.\n \e[0;33mlz4 and lzo/lzo-rle are said to be susceptible to OOM!\e[0m However, I have no real proof of this.\n"
echo -e " Type \e[0;32mcat /sys/block/zram0/comp_algorithm\e[0m at command line (when zram module is loaded)\n to see what is [currently set], and available for your kernel."
echo -e "\n Compression algorithm selection"
echo -e "\e[1;32m   1 = zstd (recommended)"
echo -e "\e[0;32m   2 = lz4hc"
echo -e "\e[0;32m   3 = lz4"
echo -e "\e[0;33m   4 = lzo-rle"
echo -e "\e[0;33m   5 = lzo"
echo -e "\e[0;31m   6 = 842 (worst decision)\e[0m"
echo -e "   * = cancel and quit"
echo ""
echo -en " Which algorithm should be used? Enter a number from 1 to 5: " && read -r alg_sel
   case "$alg_sel" in
      1) comp_alg='zstd';;
      2) comp_alg='lz4hc';;
      3) comp_alg='lz4';;
      4) comp_alg='lzo-rle';;
      5) comp_alg='lzo';;
      6) comp_alg='842';;
      *) echo -e "\e[1;31m Cancel and quit.\e[0m" && exit 3;;
   esac
echo ""
echo " How many percent of RAM should be used for zswap?"
echo -en " Type an integer without %-sign. A value between\n 30 and 50 is a good choice in most cases. " && read -r ram_perc
echo -e "ALGO=$comp_alg\nPERCENT=$ram_perc\nPRIORITY=100" | sudo tee -a /etc/default/zramswap
echo ""
echo -e " The swapfile has been configured to \e[1;32m$ram_perc%\e[0m of available RAM,\n compressed with \e[1;32m$comp_alg\e[0m algorithm."
echo -e " The configuration was written to \e[1;32m/etc/default/zramswap\e[0m."
# For more info go to
# https://github.com/torvalds/linux/drivers/block/zram/Kconfig
# https://github.com/torvalds/linux/Documentation/admin-guide/blockdev/zram.rst
# now invoke the service with
sudo service zramswap reload
echo -en "\n Should the service enabled to be started at system boot time?\n Type \e[1;32mY\e[0m or \e[1;32mYes\e[0m or \e[1;32myes\e[0m to continue, any other key to exit: " && read -r ans_yn
   case "$ans_yn" in
      [Yy]|[Yy][Ee][Ss]) echo -e "\n\e[1;36m This is how it shall be..." ;;
               *) echo -e "\e[1;32m" && free -h && echo -e "\e[0m" && exit 3 ;;
   esac
sudo systemctl enable zramswap.service && echo -en "\e[1;36m ...done.\e[0m"
fi
# show the status of the service; it should be active and running
sudo service zramswap status

# show memory & swap file stats
echo -e "\e[1;32m"
free -h
echo -e "\e[0m"
# EOF
