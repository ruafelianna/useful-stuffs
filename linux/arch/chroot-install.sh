source env
# time
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc
# locale
sed -ni 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/p' /etc/locale.gen
sed -ni 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/p' /etc/locale.gen
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
mkdir /etc/docker
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
sed -ni 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL) ALL/p' /etc/sudoers
# bash root
export home=/root
mkdir -p $home/.bashrc.d
cd $home/.bashrc.d
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/colors
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/prompt
sed -ni '15 s/# PS1/PS1/p' prompt
echo 'source $HOME/.bashrc.d/prompt' >> $home/.bashrc
# bash user
export home=/home/$USER_NAME
mkdir -p $home/.bashrc.d
cd $home/.bashrc.d
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/colors
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/prompt
sed -ni '10 s/# PS1/PS1/p' prompt
echo 'source $HOME/.bashrc.d/prompt' >> $home/.bashrc
# bootloader
refind-install
# finish
exit
