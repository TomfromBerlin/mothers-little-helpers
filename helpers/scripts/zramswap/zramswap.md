# zramswap-install

## _Usage: `sh zram-install`_

## _Licence: Dtfweywwtf_

## Description

 If you run a Raspberry Pi with 4 GB memory or less & a SD card as system drive, you may want to consider to have the swapfile installed in your RAM to reduce write access to the SD card.

This will extend the life time of your SD card.
This script installs a compressed RAM drive that is used as a swap drive.

Every thing below this line comes without any warranty.
Use it at your own risk.

This is intended to be used on a Raspberry Pi with low memory

## What the script does...

```
DEBIAN_FRONTEND=noninteractive
```
DEBIAN_FRONTEND is an apt-get variable. You must not issue this command from command line. Obviously it is for Debian-based environments.

[Source](https://www.cyberciti.biz/faq/explain-debian_frontend-apt-get-variable-for-ubuntu-debian/)

Lets see only Questions that one really, really need to see.

```
DEBIAN_PRIORITY=critical
```

_The following commands you can issue in a terminal_

At first we check if zram is already installed. If it is installed we only check the status and display mem stats, since we do not want to change existing configurations by accident

```
if [[ ! -x /usr/bin/zramctl ]]; then
```
download and install the package if the package is not installed

```
sudo apt-get -yq install zram-tools < /dev/null > /dev/null
```

The switch [-yq] answers [y]es to apt-get and makes the output more or less [q]uiet.

[< /dev/null > /dev/null] redirects the remaining output (stdin, stdout) to nowhere, only errors will be shown

We configure the swapfile to 50% of available RAM, compressed with zstd algorythm and write it to /etc/default/zramswap

```
echo -e ALGO="zstd\nPERCENT=50" | sudo tee -a /etc/default/zramswap
```

Now the service will be invoked with

```
sudo service zramswap reload
```

and we do not forget to close the "if-then" statement with `fi`

Now we get back to the default frontend for apt/apt-get (you do not need to issue this from command line)

```
export DEBIAN_FRONTEND=dialog
```

Lets show the status of the service; it should be active and running

```
sudo service zramswap status
```
Now we ask, if the service should be started at boot time. Probably "Yes".

```
echo -e "         Should the service enabled to be started"
read -pr "         at system boot time?" ans_yn
   case "$ans_yn" in
      [Yy]|[Yy][Ee][Ss]) echo "Here we go...";;
               *) free -h && echo -e "\e[0m" && exit 3 ;;
   esac
echo -e "\e[0m"
sudo systemctl enable zramswap.service && echo -en "\e[1;36mDone."
```

Let's see what memory and swap file stats say...

```
free -h
```

...and exit.

```
exit
```
Thats all. You can download the script [here](zram-install.sh)
