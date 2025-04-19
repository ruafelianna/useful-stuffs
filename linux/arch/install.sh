eval $(cat ./env)
# keyboard layout
loadkeys ru
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
reflector --country 'Russia,' --save /etc/pacman.d/mirrorlist
pacman -Syy
pacman-key --init
pacman-key --populate
pacstrap -K /mnt base base-devel linux linux-headers dkms virtualbox-guest-utils \
    git openssh nano tree man refind dhcpcd reflector htop \
    noto-fonts-* docker docker-compose python-pdm
# fstab
genfstab -U /mnt >> /mnt/etc/fstab
# chroot
cp chroot-install.sh /mnt/install.sh
cp env /mnt/env
arch-chroot /mnt source install.sh
# finish
rm /mnt/install.sh /mnt/env
umount -R /mnt
swapoff /dev/sda2
echo 'Installation complete. Extract installation media and reboot...'
