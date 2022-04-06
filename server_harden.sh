#!/usr/bin/env bash

#####################################################
# Source various web sources:
# https://www.linuxbabe.com/ubuntu/enable-google-tcp-bbr-ubuntu
# https://www.cyberciti.biz/faq/linux-tcp-tuning/
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf

(crontab -l 2>/dev/null; echo "@reboot source /etc/functions.sh") | crontab -
(crontab -l 2>/dev/null; echo "@reboot source /etc/multipool.conf") | crontab -

echo -e " Boosting server performance for YiiMP...$COL_RESET"
# Boost Network Performance by Enabling TCP BBR
hide_output sudo apt install -y --install-recommends linux-generic-hwe-16.04;
wait $!
echo 'net.core.default_qdisc=fq' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | hide_output sudo tee -a /etc/sysctl.conf

# Tune Network Stack
echo 'net.core.wmem_max=12582912' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.core.rmem_max=12582912' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem= 10240 87380 12582912' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem= 10240 87380 12582912' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_window_scaling = 1' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_timestamps = 1' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_sack = 1' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_no_metrics_save = 1' | hide_output sudo tee -a /etc/sysctl.conf
echo 'net.core.netdev_max_backlog = 5000' | hide_output sudo tee -a /etc/sysctl.conf

echo -e "$GREEN Done...$COL_RESET"
exit 0
