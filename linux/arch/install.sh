# keyboard layout
loadkeys ru
# proxy
export http_proxy=
export https_proxy=$http_proxy
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$http_proxy
export COMPUTER_NAME=
export ROOT_PASSWD=
export USER_NAME=
export USER_PASSWD=
# partitions
sfdisk /dev/sda << EOF
label: gpt
/dev/sda1: start=2048, size=2097152, type=c12a7328-f81f-11d2-ba4b-00a0c93ec93b
/dev/sda2: start=2099200, size=8388608, type=0657fd6d-a4ab-43c4-84e5-0933c84b4f4f
/dev/sda3: start=10487808, type=0fc63daf-8483-4772-8e79-3d69d8477de4
EOF
# format
mkfs.vfat -n BOOT /dev/sda1
mkswap -L SWAP /dev/sda2
yes | mkfs.ext4 -L ROOT /dev/sda3
# mount
swapon /dev/sda2
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
# base system
pacman -Syy
pacman-key --init
pacman-key --populate
pacstrap -K /mnt base base-devel linux virtualbox-guest-utils \
    git openssh nano tree man docker docker-compose python-pdm linux-headers dkms refind \
    xfce4 xfce4-terminal mousepad thunar-archive-plugin noto-fonts noto-fonts-cjk noto-fonts-emoji
# fstab
genfstab -U /mnt >> /mnt/etc/fstab
# chroot
arch-chroot /mnt
# time
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc
# locale
sed -n 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/p' /etc/locale.gen
sed -n 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/p' /etc/locale.gen
locale-gen
echo 'LANG=ru_RU.UTF-8' > /etc/locale.conf
echo 'KEYMAP=ru' > /etc/vconsole.conf
# network
echo $COMPUTER_NAME > /etc/hostname
cat >> /etc/hosts << EOF
127.0.0.1       localhost
::1             localhost
127.0.1.1       $COMPUTER_NAME.local    $COMPUTER_NAME
EOF
# docker
cat > /etc/docker/daemon.json << EOF
{
 "proxies": {
   "http-proxy": "$http_proxy",
   "https-proxy": "$https_proxy",
   "no-proxy": "127.0.0.0/8,localhost"
 }
}
EOF
# users
echo -n $ROOT_PASSWD | passwd -s
useradd -G wheel,docker -s /bin/bash -m $USER_NAME
echo -n $USER_PASSWD | passwd -s $USER_NAME
sed -n 's/#%wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/p' /etc/sudoers
# bash root
mkdir /root/.bashrc.d
cd /root/.bashrc.d
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/colors
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/prompt
sed -n '15 s/# PS1/PS1/p' prompt
cd ..
echo 'source .bashrc.d/prompt' >> .bashrc
# bash user
mkdir /home/$USER_NAME/.bashrc.d
cd /home/$USER_NAME/.bashrc.d
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/colors
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/prompt
sed -n '10 s/# PS1/PS1/p' prompt
cd ..
echo 'source .bashrc.d/prompt' >> .bashrc
# bootloader
refind-install
# finish
exit
umount -R /mnt
reboot
