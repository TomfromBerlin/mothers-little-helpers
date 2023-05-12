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
echo -e "    \e[1;36m This is intended to be used on a Raspberry Pi with low memory"
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
echo -e "\e[1;36m"
# We ask whether the installation should begin.
echo -e "         Do you want to install zram-tools"
read -pr"       and establish a swapfile in your RAM?" ans_yn
   case "$ans_yn" in
      [Yy]|[Yy][Ee][Ss]) echo "Here we go...";;
               *) echo -e "\e[0m" && exit 3 ;;
   esac
echo -e "\e[0m"
#########################################################################
# Start install process
#
# DEBIAN_FRONTEND is an apt-get variable, obviously it is for Debian-based environments.
# you must not issue the following command from command line
DEBIAN_FRONTEND=noninteractive
# https://www.cyberciti.biz/faq/explain-debian_frontend-apt-get-variable-for-ubuntu-debian/
#
# show only questions that one really, really need to see
DEBIAN_PRIORITY=critical
export DEBIAN_PRIORITY
# check if zram is already installed
# if it is installed we only check the status and display mem stats,
# since we do not want to change any existing configuration by accident
if [[ ! -x /usr/bin/zramctl ]]; then
# download the package, and install it, if it is not installed
sudo apt-get -yq install zram-tools < /dev/null > /dev/null
# the switch [-yq] answers [y]es to apt-get and makes the output more or less [q]uiet;
# [< /dev/null > /dev/null] redirects the remaining output (stdin, stdout) to nowhere, only errors will be shown

# configure the swapfile to 50% of available RAM, compressed with zstd algorythm
# and write it to /etc/default/zramswap
echo -e ALGO="zstd\nPERCENT=50\nPRIORITY=100" | sudo tee -a /etc/default/zramswap

# Compression algorithm selection
# speed: lz4 > zstd > lzo
# compression: zstd > lzo > lz4
# See /sys/block/zram0/comp_algorithm (when zram module is loaded) to see
# what is currently set and available for your kernel
# https://github.com/torvalds/linux/drivers/block/zram/Kconfig
# https://github.com/torvalds/linux/Documentation/admin-guide/blockdev/zram.rst

# now invoke the service with
sudo service zramswap reload

fi

# get back to the default frontend for apt/apt-get
export DEBIAN_FRONTEND=dialog  #only needed when running this script

# show the status of the service; it should be active and running
sudo service zramswap status

echo -e "         Should the service enabled to be started"
read -pr "         at system boot time?" ans_yn
   case "$ans_yn" in
      [Yy]|[Yy][Ee][Ss]) echo "Here we go...";;
               *) echo -e "\e[1;32m" && free -h && echo -e "\e[0m" && exit 3 ;;
   esac
echo -e "\e[0m"
sudo systemctl enable zramswap.service && echo -en "\e[1;36mDone."
# show memory & swap file stats
echo -e "\e[1;32m"
free -h
echo -e "\e[0m"
#
# EOF
