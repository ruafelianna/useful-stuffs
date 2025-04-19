# env
eval $(cat ./env_proxy)
eval $(cat ./env_chroot)

# locale
keys=ru
font=ter-v32n

loadkeys $keys
setfont $font

for locale in en_US ru_RU
do
  l="$locale.UTF-8 UTF-8"
  sed -i "s/#$l/$l/" /etc/locale.gen
done

locale-gen

cat > /etc/locale.conf << EOF
LANG=ru_RU.UTF-8
EOF

cat > /etc/vconsole.conf << EOF
KEYMAP=$keys
FONT=$font
EOF

# time
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc

# network
echo $COMPUTER_NAME > /etc/hostname

cat >> /etc/hosts << EOF
127.0.0.1       localhost
::1             localhost
127.0.1.1       $COMPUTER_NAME.local    $COMPUTER_NAME
EOF

# docker
docker_dir=/etc/docker

mkdir $docker_dir

cat > $docker_dir/daemon.json << EOF
{
 "proxies": {
   "http-proxy": "$http_proxy",
   "https-proxy": "$https_proxy",
   "no-proxy": "$no_proxy"
 }
}
EOF

# users
echo -n $ROOT_PASSWD | passwd -s

useradd -G wheel,docker -s /bin/bash -m $USER_NAME
echo -n $USER_PASSWD | passwd -s $USER_NAME

whl='wheel ALL=(ALL:ALL) ALL'
sed -i "s/# $whl/$whl/" /etc/sudoers

# customize tty
tty_home=/root/tty-stuff
base_url=https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux
colors=bashrc/colors
prompt=bashrc/prompt
nanorc=.nanorc

curl "$base_url/{$colors,$prompt,$nanorc}" --create-dirs -o "$tty_home/#1"

tty_settings() {
  home=$1
  home_d=$home/.bashrc.d

  mkdir -p $home_d

  cp $tty_home/$colors $tty_home/$prompt $home_d
  cp $tty_home/$nanorc $home
  cp env_proxy $home_d/proxy

  sed -i "$2 s/# PS1/PS1/" $home_d/prompt
  sed -i '224 s/local\///' $home/.nanorc
  sed -i "$3 s/set/# set/" $home/.nanorc
  sed -i "$4 s/# set/set/" $home/.nanorc

  echo 'source $HOME/.bashrc.d/prompt' >> $home/.bashrc
  echo 'source $HOME/.bashrc.d/proxy' >> $home/.bashrc
}

tty_settings '/root' '15' '201,208' '210,217'
tty_settings "/home/$USER_NAME" '10' '210,217' '201,208'

chown -R $USER_NAME:$USER_NAME $home

# bootloader
refind-install

root_uuid=$(lsblk -o UUID /dev/sda3 | sed -n '2 s/0/0/p')

cat > /boot/refind_linux.conf << EOF
"Boot with standard options"  "root=UUID=$root_uuid rw loglevel=3 quiet"                        
"Boot to single-user mode"    "root=UUID=$root_uuid rw loglevel=3 quiet single"                 
"Boot with minimal options"   "root=UUID=$root_uuid ro"
EOF
