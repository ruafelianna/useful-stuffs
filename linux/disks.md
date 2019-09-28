1. ```blkid```

The list of available disks.

2. **/etc/fstab**

Disk mount settings. (More info on [ArchWiki](https://wiki.archlinux.org/index.php/Fstab))

Adding HDD automount example:

```UUID=UUID_from_blkid /mnt/docs ntfs rw,notail,relatime 0 0```

(*where UUID_from_blkid is UUID, which you can get from paragraph 1*)

Note that ```/mnt/docs``` should be created manually before adding above mentioned line to ```/etc/fstab```.

Also don't forget to set proper permissions for the ```/mnt/docs``` directory.
