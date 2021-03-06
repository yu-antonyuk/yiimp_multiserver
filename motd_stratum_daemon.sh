#!/usr/bin/env bash
#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################
echo -e "$GREY run motd_stratum_daemon.sh$COL_RESET"
source /etc/functions.sh
source /etc/multipool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf

cd /tmp

apt_install lsb-release figlet update-motd \
landscape-common update-notifier-common
wait $!
cd /tmp
sudo rm -r /etc/update-motd.d/
sudo mkdir /etc/update-motd.d/
sudo touch /etc/update-motd.d/00-header ; sudo touch /etc/update-motd.d/10-sysinfo ; sudo touch /etc/update-motd.d/90-footer
sudo chmod +x /etc/update-motd.d/*
sudo cp -r 00-header 10-sysinfo 90-footer /etc/update-motd.d/

cd $HOME/multipool/yiimp_multi/ubuntu
sudo cp -r stratum /usr/bin
sudo chmod +x /usr/bin/stratum
sudo cp -r addport /usr/bin
sudo chmod +x /usr/bin/addport
sudo cp -r addport-full /usr/bin
sudo chmod +x /usr/bin/addport-full
sudo cp -r addport-lowdiff /usr/bin
sudo chmod +x /usr/bin/addport-lowdiff
sudo cp -r addport-zenx /usr/bin
sudo chmod +x /usr/bin/addport-zenx

echo '
clear
run-parts /etc/update-motd.d/ | sudo tee /etc/motd
' | sudo -E tee /usr/bin/motd >/dev/null 2>&1

sudo chmod +x /usr/bin/motd
exit 0
