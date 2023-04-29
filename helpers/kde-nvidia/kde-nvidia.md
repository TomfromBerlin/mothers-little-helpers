# KDE & Nvidia

If you try to use KDE with your Nvidia card with proprietary drivers, you may run into a scaling problem. Your desktop might look like the following:

![kde-nvidia-scaling-problem](kde-nvidia-scaling-problem.png)

![kde-nvidia-scaling-problem2](kde-nvidia-scaling-problem2.png)

The solution is quite simple: open /etc/sddm.conf (e.g. with `sudo nano /etc/sddm.conf`) and add the following argument to the line _ServerArguments=-nolisten tcp_ in section [X11]:
`-dpi 96`

After editing the line should look like this

```
[X11]

ServerArguments=-nolisten tcp -dpi 96

```

After restarting your computer the scaling problem should be gone and you desktop should look like this:

![kde-nvidia-scaling-problem](kde-nvidia-no-scaling-problem.jpg)

![kde-nvidia-scaling-problem2](kde-nvidia-no-scaling-problem2.jpg)
