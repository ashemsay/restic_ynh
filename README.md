# restic for Yunohost

[![Latest Version](https://img.shields.io/badge/version-1.0.3-green.svg?style=flat)](https://github.com/YunoHost-Apps/restic_ynh/releases)
[![Status](https://img.shields.io/badge/status-testing-yellow.svg?style=flat)](https://github.com/YunoHost-Apps/restic_ynh/milestones)
[![Integration level](https://dash.yunohost.org/integration/restic.svg)](https://dash.yunohost.org/appci/app/restic)
[![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg?style=flat)](https://raw.githubusercontent.com/YunoHost-Apps/restic_ynh/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/YunoHost-Apps/restic_ynh.svg?style=flat)](https://github.com/YunoHost-Apps/restic_ynh/issues)

[![Install restic with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=restic)

A restic package for YunoHost

## Usage

If you want to backup your server A onto the server B.

## Setup restic app on Server A

Firstly set up this app on the server A you want to backup:

```
$ yunohost app install https://github.com/YunoHost-Apps/restic_ynh
Indicate the server where you want put your backups: serverB.local
Indicate the ssh user to use to connect on this server: servera
Indicate a strong passphrase, that you will keep preciously if you want to be able to use your backups: N0tAW3akp4ssw0rdYoloMacN!guets
Would you like to backup your YunoHost configuration ? [0 | 1] (default: 1):
Would you like to backup mails and user home directory ? [0 | 1] (default: 1):
Which apps would you backup (list separated by comma or 'all') ? (default: all):
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

See here for more info : https://wiki.archlinux.org/index.php/Systemd/Timers#Realtime_timer

At the end of the installation, the app displays the public_key and the user to give to the person who has access to the server B.

You should now authorize the public key for user `servera` on server B by logging into server B with user `servera` and running:

```
mkdir ~/.ssh/authorized_keys -p 2>/dev/null
chmod u=rw,go= ~/.ssh/authorized_keys
cat << EOPKEY >> ~/.ssh/authorized_keys
<paste here the privakey displayed at the end of installation>
EOPKEY
```
If you don't find the mail and you don't see the message in the log bar you can found the public_key with this command:
```
cat /root/.ssh/id_restic_ed25519.pub
```

## Optional set sftp jail on server B

To improve security, make sure user `servera` can only do sftp and can only access his home directory on server B.
This is how you would do it on Debian/Ubuntu, otherwise refer to your distribution manual (don't forget to replace `servera` by the real username)

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
restic list
```

YOU SHOULD CHECK REGULARLY THAT YOUR BACKUP ARE STILL WORKING.

## Edit the apps list to backup

```
yunohost app setting restic apps -v "nextcloud,wordpress"
```

## Backup on different server, and apply distinct schedule for apps

You can setup the restic app several times on the same server so you can backup on several server or manage your frequency backup differently for specific part of your server.

## TODO

* Schedule backup check
* Remove expect message when question was not matched
