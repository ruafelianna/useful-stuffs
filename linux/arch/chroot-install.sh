start='>>> '

# env
{
  echo $start'Loading proxy settings...' && \
  eval $(cat ./env_proxy) && \
  echo $start'Loading chroot settings...' && \
  eval $(cat ./env_chroot)
} && \

# locale
{
  echo $start'Setting keys var...' && \
  keys=ru && \
  echo $start'Setting font var...' && \
  font=ter-v32n && \
  
  echo $start'Loading keys...' && \
  loadkeys $keys && \
  echo $start'Setting font...' && \
  setfont $font && \

  {
    for locale in en_US ru_RU
    do
      echo $start'Setting locale var...' && \
      l="$locale.UTF-8 UTF-8" && \
      echo $start'Uncommenting '$locale' locale...' && \
      sed -i "s/#$l/$l/" /etc/locale.gen
    done
  } && \
  
  echo $start'Generating locale...' && \
  locale-gen && \
  
  echo $start'Setting language...' && \
  {
    cat > /etc/locale.conf << EOF
LANG=ru_RU.UTF-8
EOF
  } && \

  echo $start'Setting console settings...' && \
  cat > /etc/vconsole.conf << EOF
KEYMAP=$keys
FONT=$font
EOF
} && \

# time
{
  echo $start'Setting timezone...' && \
  ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
  echo $start'Syncing clock...' && \
  hwclock --systohc
} && \

# network
{
  echo $start'Setting host name...' && \
  echo $COMPUTER_NAME > /etc/hostname && \
  
  echo $start'Setting hosts...' && \
  cat >> /etc/hosts << EOF
127.0.0.1       localhost
::1             localhost
127.0.1.1       $COMPUTER_NAME.local    $COMPUTER_NAME
EOF
} && \

# docker
{
  echo $start'Setting docker folder var...' && \
  docker_dir=/etc/docker && \
  
  echo $start'Creating docker folder...' && \
  mkdir -p $docker_dir && \
  
  echo $start'Creating docker proxy settings...' && \
  cat > $docker_dir/daemon.json << EOF
{
 "proxies": {
   "http-proxy": "$http_proxy",
   "https-proxy": "$https_proxy",
   "no-proxy": "$no_proxy"
 }
}
EOF
} && \

# users
{
  echo $start'Setting root password...' && \
  echo -n $ROOT_PASSWD | passwd -s && \
  
  echo $start'Creating administrator user...' && \
  useradd -G wheel,docker -s /bin/bash -m $USER_NAME && \
  echo $start'Setting admiinistrator password...' && \
  echo -n $USER_PASSWD | passwd -s $USER_NAME && \
  
  whl='%wheel ALL=(ALL:ALL) ALL' && \
  echo $start'Setting wheel users as sudoers...' && \
  sed -i "s/# $whl/$whl/" /etc/sudoers
} && \

# customize tty
{
  echo $start'Setting tty home var...' && \
  tty_home=/root/tty-stuff && \
  echo $start'Setting base url var...' && \
  base_url=https://raw.githubusercontent.com/ruafelianna/useful-stuffs/refs/heads/master/linux && \
  echo $start'Setting bashrc colors var...' && \
  colors=bashrc/colors && \
  echo $start'Setting bashrc prompt var...' && \
  prompt=bashrc/prompt && \
  echo $start'Setting nanorc var...' && \
  nanorc=.nanorc && \
  
  echo $start'Loading bash and nano settings...' && \
  curl "$base_url/{$colors,$prompt,$nanorc}" --create-dirs -o "$tty_home/#1" && \
  
  tty_settings() {
    echo $start'Setting home var...' && \
    home=$1 && \
    echo $start'Setting bashrc folder var...' && \
    home_d=$home/.bashrc.d && \
  
    echo $start'Creating bash folder...' && \
    mkdir -p $home_d && \
  
    echo $start'Copying bash files...' && \
    cp $tty_home/$colors $tty_home/$prompt $home_d && \
    echo $start'Copying nano files...' && \
    cp $tty_home/$nanorc $home && \
    echo $start'Copying proxy config...' && \
    cp env_proxy $home_d/proxy && \
  
    echo $start'Uncommenting corner settings...' && \
    sed -i '15,16 s/# //' $home_d/prompt && \
    echo $start'Uncommenting PS1 var...' && \
    sed -i "$2 s/# //" $home_d/prompt && \
    echo $start'Changing nanorc directory...' && \
    sed -i '224 s/local\///' $home/.nanorc && \
    echo $start'Uncommenting color settings...' && \
    sed -i "$3 s/# //" $home/.nanorc && \
  
    echo $start'Adding prompt sourcing...' && \
    echo 'source $HOME/.bashrc.d/prompt' >> $home/.bashrc && \
    echo $start'Adding proxy sourcing...' && \
    echo 'source $HOME/.bashrc.d/proxy' >> $home/.bashrc
  }
  
  echo $start'Adding root customization...' && \
  tty_settings '/root' '22' '210,217' && \
  echo $start'Adding administrator customization...' && \
  tty_settings "/home/$USER_NAME" '19' '201,208' && \
  
  echo $start'Creating root .bash_profile...' && \
  echo '[[ -f ~/.bashrc ]] && . ~/.bashrc' > /root/.bash_profile && \
  
  echo $start'Changing owner of administrator files...' && \
  chown -R $USER_NAME:$USER_NAME $home
} && \

# services
{
  echo $start'Enabling dhcp daemon...' && \
  systemctl enable dhcpcd && \
  echo $start'Enabling docker daemon...' && \
  systemctl enable docker
} && \

# bootloader
{
  echo $start'Installing refind...' && \
  refind-install && \
  
  root_uuid=$(lsblk -o UUID /dev/sda3 | sed -n '2 s/0/0/p') && \
  
  echo $start'Creating refind conf...' && \
  cat > /boot/refind_linux.conf << EOF
"Boot with standard options"  "root=UUID=$root_uuid rw loglevel=3 quiet"                        
"Boot to single-user mode"    "root=UUID=$root_uuid rw loglevel=3 quiet single"                 
"Boot with minimal options"   "root=UUID=$root_uuid ro"
EOF
}
