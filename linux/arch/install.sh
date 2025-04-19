start='>>> '

# env
{
  echo $start'Loading proxy settings...' && \
  eval $(cat ./env_proxy)
} && \

# partitions
{
  echo $start'Creating partitions...' && \
  sfdisk /dev/sda << EOF
label: gpt
/dev/sda1: start=2048, size=2097152, type=c12a7328-f81f-11d2-ba4b-00a0c93ec93b
/dev/sda2: start=2099200, size=8388608, type=0657fd6d-a4ab-43c4-84e5-0933c84b4f4f
/dev/sda3: start=10487808, type=0fc63daf-8483-4772-8e79-3d69d8477de4
EOF
} && \
# format
{
  echo $start'Formatting boot partition...' && \
  mkfs.vfat -n BOOT /dev/sda1 && \
  echo $start'Formatting swap partition...' && \
  mkswap -L SWAP /dev/sda2 && \
  echo $start'Formatting root partition...' && \
  yes | mkfs.ext4 -L ROOT /dev/sda3
} && \

# mount
{
  echo $start'Mounting swap...' && \
  swapon /dev/sda2 && \

  echo $start'Mounting root...' && \
  mount /dev/sda3 /mnt && \
  echo $start'Mounting boot...' && \
  mount --mkdir /dev/sda1 /mnt/boot
} && \

# base system
{
  echo $start'Updating pacman mirror list...' && \
  reflector --country 'Russia,' --save /etc/pacman.d/mirrorlist && \
  echo $start'Updating pacman repository information...' && \
  pacman -Syy && \

  echo $start'Initiating pacman keys...' && \
  pacman-key --init && \
  echo $start'Populating pacman keys...' && \
  pacman-key --populate && \

  echo $start'Installing base system...' && \
  pacstrap -K /mnt base base-devel linux linux-headers dkms virtualbox-guest-utils \
    git openssh nano tree man refind dhcpcd reflector htop \
    terminus-font docker docker-compose python-pdm
} && \

# fstab
{
  echo $start'Generating stab...' && \
  genfstab -U /mnt >> /mnt/etc/fstab
} && \

# chroot
{
  echo $start'Copying installation files to root...' && \
  cp chroot-install.sh env_proxy env_chroot /mnt/ && \

  echo $start'Changing root to /mnt...' && \
  arch-chroot /mnt bash -c "source chroot-install.sh"
} && \

# finish
{
  echo $start'Removing installation files...' && \
  rm /mnt/{chroot-install.sh,env_proxy,env_chroot} && \

  echo $start'Unmounting root and boot...' && \
  umount -R /mnt && \

  echo $start'Unmounting swap...' && \
  swapoff /dev/sda2 && \

  echo 'Installation has completed. Extract installation media and reboot...'
}
