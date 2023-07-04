# Installation of swapfile in RAM with zram

## _Usage: `sh zram-install`_

## _Licence: Dtfweywwtf_

## Description

 If you run a Raspberry Pi with a SD card as system drive, you may want to consider to have the swapfile installed in your RAM to reduce write access to the SD card.

This will extend the life time of your SD card. This script installs a compressed RAM drive that is used as a swap drive.

__Every thing below this line comes without any warranty. Use it at your own risk.__

## What the script does...

```
DEBIAN_FRONTEND=noninteractive
```
DEBIAN_FRONTEND is an apt-get variable. You must not issue this command from command line. Obviously it is for Debian-based environments.
[Source](https://www.cyberciti.biz/faq/explain-debian_frontend-apt-get-variable-for-ubuntu-debian/)

```
DEBIAN_PRIORITY=critical
```
Let one see only questions that one really, really need to see.

_The following commands you can issue in a terminal_

At first we check if zram is already installed. If it is installed we only check the status and display mem stats, since we do not want to change existing configurations by accident

```
if [[ ! -x /usr/bin/zramctl ]]; then
```
download and install the package if it is not installed

```
sudo apt-get -yq install zram-tools < /dev/null > /dev/null
```

The switch [-yq] answers [y]es to apt-get and makes the output more or less [q]uiet.

[< /dev/null > /dev/null] redirects the remaining output (stdin, stdout) to nowhere, only errors will be shown.

Now we get back to the default frontend for apt/apt-get.

```
export DEBIAN_FRONTEND=dialog
```

After the successful installation the user is asked for the compression algorithm and the percentage of memory to be used.

Possible values for the algorithm are:
- zstd (recommended)
- lz4hc
- lz4
- lzo-rle
- lzo
- 842 (if you really hate your life)

| Alogorithm comparission | best > > > > > > > > > > > > > > worst |
|-|-|
| speed:           | lz4 > lz4hc > zstd > lzo-rle > lzo > 842 |
| de-/compression: | zstd > lzo-rle > lzo > lz4hc > lz4 > 842 |

Type `cat /sys/block/zram0/comp_algorithm` at command line (when zram module is loaded) to see what is [currently set], and available for your kernel. The corresponding configuration will be saved using `sudo tee -a /etc/default/zramswap`. How this works in detail can be looked up in the source code.

The resulting configuration could be look like the following:

```zsh
ALGO=zstd               # algorithm to be used
PERCENT=50              # a value between 30 and 50 seems to be a good choice in most cases
PRIORITY=100            # the lower this value, the higher the priority
```

PRIORITY is hard coded because it is a background process and we do not want it to interfere with foreground tasks.

Now the service will be invoked with

```zsh
sudo service zramswap reload
```

and we do not forget to close the "if-then" statement with

```zsh
fi
```

Lets show the status of the service; it should be active and running

```zsh
sudo service zramswap status
```
Now we ask, if the service should be started at boot time. Probably "Yes".

```zsh
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

```zsh
free -h
```

...and exit.

```zsh
exit
```
Thats all. You can download the script [here](zram-install.sh)

See documentation of zram [here](https://github.com/torvalds/linux/blob/7163a2111f6c030ee39635ac3334bfa1a52a3dd3/Documentation/admin-guide/blockdev/zram.rst)
