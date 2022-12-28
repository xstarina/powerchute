#!/bin/sh

# ---------------
# Shutdown all VMs and power off ESXi hosts with this IPs
# First you need to export the public SSH key to the ESXi hosts!
# 
# Run this on docker host with running container named apc (only once), where ESXi-IP-Address -- IP of ESXi (ver. 5.x, 6.0, 6.5 and 6.7) host:
# docker exec apc bash -c "cat ~/.ssh/id_rsa.pub | ssh -o StrictHostKeyChecking=no root@ESXi-IP-Address 'cat >> /etc/ssh/keys-root/authorized_keys'"
# 
# Read more: https://kb.vmware.com/s/article/1002866
# ---------------

# ESXi hosts IPs
ESXiIPs="192.168.192.221 192.168.192.222"

for IP in $ESXiIPs
do
  ssh -o StrictHostKeyChecking=no root@$IP "nohup sh -c \"/sbin/shutdown.sh && /sbin/poweroff\" > /dev/null 2>&1 < /dev/null &"
done
