# Arch Linux installation guide

*NB: you can use ```nano```, ```vi``` or ```vim``` as your text editor during installation.*

### Locale settings

*NB: this example is provided for Russian locale.*

1. Load Russian keyboard layout for your current session: ```loadkeys ru```.

2. Set the following font for Cyrillic support: ```setfont cyr-sun16```.

3. Add the following lines (locales) to ```/etc/locale.gen``` file:

```
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
```

4. Generate locales from ```/etc/locale.gen``` file: ```locale-gen```.

5. Set environment variable in ```/etc/locale.conf``` file:

```LANG=en_US.UTF-8```

6. Export environment variable with Russian locale: ```export LANG=ru_RU.UTF-8```.

### Disk format

1. Run disk format utility: ```cfdisk /dev/sda```.

Note that depending on your computer configuration the disk devices might not be named ```sda```,
but ```sdb```, ```sdc```, ```sdd``` etc.

2. **If you have BIOS** choose ```dos``` and do steps 2.1-2.5.

2.1. Create the following partitions and apply changes to disk:

* 1M BIOS boot type partition
* 200MB partition
* 20+GB partition for your root directory
* partition with size of your RAM (for swap)
* one more partition for your home directory

2.2. Exit ```cfdisk```.

2.3. Format your new partitions:

```
mkfs.vfat /dev/sda2 -n BOOT
mkfs.ext4 /dev/sda3 -L ROOT
mkswap /dev/sda4 -L SWAP
mkfs.ext4 /dev/sda5 -L HOME
```

2.4. Mount your new partitions:

```
mount /dev/sda3 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda2 /mnt/boot
mount /dev/sda5 /mnt/home
```

2.5. Set the swap : ```swapon /dev/sda4```.

3. **If you have UEFI** choose ```gpt``` and do steps 3.1-3.5:

3.1. Create the following partitions and apply changes to disk:

* 1G EFI type partition
* 20+GB partition for you root directory
* partition with size of your RAM (for swap)
* one more partition for your home directory

3.2. Exit ```cfdisk```.

3.3. Format your new partitions:

```
mkfs.vfat /dev/sda1 -n BOOT
mkfs.ext4 /dev/sda2 -L ROOT
mkswap /dev/sda3 -L SWAP
mkfs.ext4 /dev/sda4 -L HOME
```

3.4. Mount your new partitions:

```
mount /dev/sda2 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home
```

3.5. Set the swap : ```swapon /dev/sda3```.

### Basic system installation

*NB: this instruction presumes that you have wired connection to the Internet.
If you don't have an opportunity to use wired connection you might want to configure your wireless connection first.*

1. Add ```Server = http://mirror.yandex.ru/archlinux/$repo/os/$arch``` to the ```/etc/pacman.d/mirrorlist``` file
or use any other server with Arch repository instead.

2. Force refresh your local package database from the mirror you've chosen in step 1: ```pacman -Syy```.

3. Install basic system packages to your new root partition: ```pacstrap /mnt base base-devel```.

4. Generate automount config for your mounted partitions: ```genfstab -U /mnt >> /mnt/etc/fstab```.

5. Start a root user session in your newly installed basic system: ```arch-chroot /mnt```.

6. Set local timezone to UTC+3 (MSK+0) (or any other timezone you need):

```ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime```

7. Syncronize your hardware time with your system time: ```hwclock --systohc --utc```.

8. Repeat steps 1-6 of locale settings paragraph.

9. Set your computer name: ```echo "YOUR_COMPUTER_NAME" > /etc/hostname```.

10. Add routing for localhost in ```/etc/hosts``` file:

```
127.0.0.1       localhost
::1             localhost
127.0.1.1       YOUR_COMPUTER_NAME.localdomain    YOUR_COMPUTER_NAME

```

11. Create your new user:

```useradd -G audio,games,lp,optical,power,scanner,storage,video,wheel -s /bin/bash -m YOUR_USERNAME```

12. Make your new user an administrator by uncommenting the following line in the ```/etc/sudoers``` file:

```
%wheel ALL=(ALL) ALL
```

13. Set root user password: ```passwd```.

14. Set your new user password: ```passwd YOUR_USERNAME```.

15. Create an initial ramdisk environment for booting the linux kernel: ```mkinitcpio -p linux```.

16. Install ```grub``` package: ```pacman -S grub```.

17. **If you have UEFI** install ```efibootmgr``` package: ```pacman -S efibootmgr```.

18. Install grub to your device: ```grub-install /dev/sda```.

19. Create grub configuration file: ```grub-mkconfig -o /boot/grub/grub.cfg```.

20. Exit your new systems's root session: ```exit```.

21. Unmount your new partitions: ```umount -R /mnt```.

22. Reboot: ```reboot```.

### Further installation

* Adding 32-bit packages to package manager database:

uncomment the following lines in the ```/etc/pacman.conf``` file and refresh your local database with ```pacman -Sy```:

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

* System update:

```pacman -Suy```

* Network packages:

```pacman -S iw dialog wpa_supplicant```

If you prefer to use deprecated ```ifconfig``` and ```iwconfig``` utilities:

```pacman -S net-tools wireless_tools```

* Enabling DHCP and DHCPv6 daemon:

```systemctl enable dhcpcd```

* X-server installation:

```pacman -S xorg-server xterm xorg-xinit xorg-apps```

* Video drivers installation:

```pacman -S mesa-libgl lib32-mesa-libgl xf86-video-intel xf86-video-nouveau xf86-video-ati xf86-video-vesa```

* Fonts installation:

```sudo pacman -S ttf-dejavu ttf-liberation```

* Gnome desktop environment installation:

```
pacman -S gnome gnome-extra
systemctl enable gdm
```

* KDE desktop environment installation:

```
pacman -S plasma kde-applications sddm
systemctl enable sddm
```

* Xfce desktop environment installation:

```
pacman -S xfce4 xfce4-goodies sddm
systemctl enable sddm
```

* Network manager for KDE and Xfce:

```
pacman -S networkmanager network-manager-applet
systemctl enable NetworkManager
```

* Yaourt (AUR package manager) installation:

```
pacman -S git wget yajl
git clone https://aur.archlinux.org/package-query.git
cd package-query/
makepkg -si
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt/
makepkg -si
cd ..
rm -Rf yaourt/ package-query/
```

* Dynamic kernel modules system (DKMS) installation:

```pacman -S linux-headers dkms```

* Sound settings:

```pacman -S pulseaudio pulseaudio-alsa pavucontrol alsa-lib alsa-utils```

* Other software:

```yaourt -S powerpill``` - pacman wrapper for faster downloads

```pacman -S firefox``` - web browser from ozilla.org

```yaourt -S google-chrome``` - web browser from Google

```pacman -S terminator``` - terminal emulator that supports tabs and grids

```pacman -S clementine``` - music player and library organizer

```pacman -S vlc``` - MPEG, VCD/DVD, and DivX player

```pacman -S flashplugin``` - Adobe Flash Player NPAPI

```pacman -S wine``` - a compatibility layer for running Windows programs

```pacman -S winetricks``` - script to install various redistributable runtime libraries in Wine

```pacman -S transmission-gtk``` - BitTorrent client (GTK+ GUI)

```pacman -S viewnior``` - simple image viewer program

```pacman -S epdfview``` - simple PDF document viewer

```pacman -S fbreader``` - an e-book reader

```pacman -S krita``` - edit and paint images

```pacman -S gstreamer gstreamer-vaapi gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly``` - codecs

```pacman -S pinta``` - drawing/editing program modeled after Paint.NET

```pacman -S inkscape``` - vector graphics editor

```pacman -S gimp``` - GNU Image Manipulation Program

```pacman -S libreoffice-still``` - LibreOffice maintenance branch

```pacman -S libreoffice-fresh``` - LibreOffice branch which contains new features and program enhancements

```pacman -S putty``` - a terminal integrated SSH/Telnet client

```pacman -S filezilla``` - FTP, FTPS and SFTP client

```pacman -S thunderbird``` - mail and news reader from mozilla.org

```pacman -S pidgin``` - multi-protocol instant messaging client

```pacman -S htop``` - console interactive process viewer

```pacman -S geany``` - lightweight IDE

```yaourt -S sublime-text-3-imfix``` - sophisticated text editor for code, markup and prose - stable build

```pacman -S emacs``` - the extensible, customizable, self-documenting real-time display editor

```pacman -S gedit``` - Gnome  text editor

```pacman -S playonlinux``` - GUI for managing Windows programs under linux

```pacman -S vim``` - improved version of the vi text editor
