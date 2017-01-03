#!/bin/bash
. ~/lib/functions.conf
logfile=/tmp/rsync.log
>$logfile
LogWrite "To: xxx@gmail.com"
LogWrite "From: xxx@gmail.com"
LogWrite "Subject: source's rsync log"
LogWrite ""
LogWrite "`date` - Starting rsync of source to target..."

LogWrite "`df -hl /source*`"

LogWrite "syncing music..."
if `rsync -av --delete /source/music/ user@target:/target/music/ >> $logfile 2>&1`
    then LogWrite "rsync OK"
    else LogWrite "rsync failed - exiting"; exit 3
fi

LogWrite "syncing home dirs..."
for USER in andy root
do
    LogWrite " ... for $USER ..."
    HOME=$(getent passwd $USER | cut -d: -f6)
    if `rsync -av --delete $HOME user@target:/target/homedirs >> $logfile 2>&1`
        then LogWrite " ... done!"
        else LogWrite "rsync of $HOME failed - exiting"
#        else LogWrite "rsync of $HOME failed - exiting"; exit 4
    fi
done

LogWrite "syncing configuration..."
for DIR in /etc /var/spool/cron
do
    LogWrite " ... for $DIR ..."
    if `rsync -avR --delete $DIR/ user@target:/target/config >> $logfile 2>&1`
        then LogWrite " ... done!"
        else LogWrite "rsync of $DIR failed - exiting"; exit 5
    fi
done

LogWrite "`date` - Finished rsync of source to target"
/usr/sbin/ssmtp xxx@gmail.com < $logfile
cat $logfile >> /var/log/rsync_source.log
