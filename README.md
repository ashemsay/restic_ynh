# restic for Yunohost

[![Latest Version](https://img.shields.io/badge/version-0.9.6-green.svg?style=flat)](https://github.com/YunoHost-Apps/restic_ynh/releases)
[![Status](https://img.shields.io/badge/status-testing-yellow.svg?style=flat)](https://github.com/YunoHost-Apps/restic_ynh/milestones)
[![Integration level](https://dash.yunohost.org/integration/restic.svg)](https://dash.yunohost.org/appci/app/restic)
[![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg?style=flat)](https://raw.githubusercontent.com/YunoHost-Apps/restic_ynh/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/YunoHost-Apps/restic_ynh.svg?style=flat)](https://github.com/YunoHost-Apps/restic_ynh/issues)

[![Install restic with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=restic)

A restic package for YunoHost based on [the Borg package](https://github.com/YunoHost-Apps/borg_ynh/)

## Usage

If you want to backup your server A onto the server B.

## Setup restic app on Server A

Firstly set up this app on the server A you want to backup:

```
$ yunohost app install https://github.com/YunoHost-Apps/restic_ynh
Indicate the server where you want put your backups: serverb.domain.tld
sftp port of your server (default: 22): 2222
The directory where you want to backup repositories to be created in (default: ./): ./servera.domain.tld
Indicate the ssh user to use to connect on this server: servera
You are now about to define a new user password. The password should be at least 8 characters - though it is good practice to use longer password (i.e. a passphrase) and/or to use various kind of characters (uppercase, lowercase, digits and special characters).
Indicate a strong passphrase, that you will keep preciously if you want to be able to use your backups:
Would you like to backup your YunoHost configuration ? [yes | no] (default: yes):
Would you like to backup mails and user home directory ? [yes | no] (default: yes):
Which apps would you backup (list separated by comma or 'all') ? (default: all): gitlab,blogotext,sogo
Allow backup method to temporarily use more space? [yes | no] (default: yes):
Indicate the backup frequency (see systemd OnCalendar format) (default: Daily):
```

You can schedule your backup by choosing an other frequency. Some example:

Monthly :

Weekly :

Daily : Daily at midnight

Hourly : Hourly o Clock

Sat *-*-1..7 18:00:00 : The first saturday of every month at 18:00

4:00 : Every day at 4 AM

5,17:00 : Every day at 5 AM and at 5 PM

After each invocation an e-mail will be sent to root@yourdomain.tld with the execution log.

NOTE: After each backup, the repository integrity is checked

See here for more info : https://wiki.archlinux.org/index.php/Systemd/Timers#Realtime_timer

At the end of the installation, the app displays the public_key and the user to give to the person who has access to the server B.

You should now authorize the public key for user `servera` on server B by logging into server B with user `servera` and running:

```
mkdir ~/.ssh -p 2>/dev/null
touch ~/.ssh/authorized_keys
chmod u=rw,go= ~/.ssh/authorized_keys
cat << EOPKEY >> ~/.ssh/authorized_keys
<paste here the privakey displayed at the end of installation>
EOPKEY
```
If you don't find the mail and you don't see the message in the log bar you can found the public_key with this command:
```
cat /root/.ssh/id_restic_ed25519.pub
```

## (Optional) set sftp jail on server B

To improve security, make sure user `servera` can only do sftp and can only access his home directory on server B.
This is how you would do it on Debian/Ubuntu, otherwise refer to your distribution manual (don't forget to replace `servera` with the real username)

```
cat << EOCONFIG >> /etc/ssh/sshd_config
Match User servera
   ChrootDirectory %h
   ForceCommand internal-sftp
   AllowTcpForwarding no
   X11Forwarding no
EOCONFIG
service ssh restart
```

## Test
At this step your backup should schedule.

If you want to be sure, you can test it by running on server A:
```
service restic start
```

Next you can check by running on server A
```
restic -r sftp:serverb.domain.tld:servera.domain.tld/auto_conf snapshots
```

Replace `auto_conf` with `auto_<app>` if you did not choose to backup configuration but only applications.

YOU SHOULD CHECK REGULARLY THAT YOUR BACKUP ARE STILL WORKING.

## Edit the apps list to backup

```
yunohost app setting restic apps -v "nextcloud,wordpress"
```

## Backup on different server, and apply distinct schedule for apps

You can setup the restic app several times on the same server so you can backup on several server or manage your frequency backup differently for specific part of your server.

## TODO

* Remove expect message when question was not matched
