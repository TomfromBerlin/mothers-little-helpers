# KDE & Nvidia

If you try to use KDE with your Nvidia card with proprietary drivers, you may run into a scaling problem. Your desktop might look like the following:

![kde-nvidia-scaling-problem](kde-nvidia-scaling-problem.png)

![kde-nvidia-scaling-problem2](kde-nvidia-scaling-problem2.png)

As you can see, icons, fonts and almost everything are way to big, and the desktop is more or less unusable.

The solution is quite simple: open /etc/sddm.conf (e.g. with `sudo nano /etc/sddm.conf`) and add

```
-dpi 96
```

to the line

_**ServerArguments=-nolisten tcp**_

in section `[X11]`:

It should look like this (among other entries):

```
[X11]
ServerArguments=-nolisten tcp -dpi 96

```

After restarting your computer the scaling problem should be gone and your desktop look like this:

![kde-nvidia-scaling-problem](kde-nvidia-no-scaling-problem.jpg)

![kde-nvidia-scaling-problem2](kde-nvidia-no-scaling-problem2.jpg)
