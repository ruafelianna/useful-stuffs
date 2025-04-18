eval $(cat ./env)
# time
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc
# locale
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=ru_RU.UTF-8' > /etc/locale.conf
echo 'KEYMAP=ru' > /etc/vconsole.conf
setfont cyr-sun16
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
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
# bash root
export home=/root
mkdir -p $home/.bashrc.d
cd $home/.bashrc.d
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/colors
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/prompt
sed -i '15 s/# PS1/PS1/' prompt
echo 'source $HOME/.bashrc.d/prompt' >> $home/.bashrc
cd ..
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/.nanorc
sed -i '224 s/local\///'
sed -i '201,208 s/set/# set/'
sed -i '210,217 s/# set/set/'
# bash user
export home=/home/$USER_NAME
mkdir -p $home/.bashrc.d
cd $home/.bashrc.d
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/colors
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/bashrc/prompt
sed -i '10 s/# PS1/PS1/' prompt
echo 'source $HOME/.bashrc.d/prompt' >> $home/.bashrc
cd ..
curl -O https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux/.nanorc
sed -i '224 s/local\///'
chown -R $USER_NAME:$USER_NAME $home
# bootloader
refind-install
# finish
exit
