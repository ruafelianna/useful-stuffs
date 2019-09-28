1. **TP-Link TL-WN823N on Arch Linux**

Install driver instruction:

1.1 Make sure you have ```git```, ```base-devel```, ```linux-headers``` and ```dkms``` packages installed.

1.2 ```git clone https://github.com/Mange/rtl8192eu-linux-driver.git```

1.3 ```cd rtl8192eu-linux-driver```

1.4 ```dkms add .```

1.5 ```dkms install rtl8192eu/1.0```

1.6 Create a file named ```/etc/modules-load.d/8192eu.conf``` with the contents ```8192eu``` for driver autoload

1.7 Reboot

If you get the following error on paragraph 1.5: ```Your kernel headers for kernel 3.11.6-1-ARCH cannot be found at
/usr/lib/modules/3.11.6-1-ARCH/build or /usr/lib/modules/3.11.6-1-ARCH/source```, try running ```pacman -Sy linux-headers```
and reinstall ```linux-headers``` package. Package manager should now see a new driver and install it automatically during package
postinstallation process.

For more information check [michaelheap.com](https://michaelheap.com/tp-link-tl-wn823n-on-arch-linux/).
