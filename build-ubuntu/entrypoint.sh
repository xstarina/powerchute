#!/bin/sh

rm -f /var/lock/LCK*
[ ! -f ~/.ssh/id_rsa ] && ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ''

# Allowing SSH access to ESXi/ESX hosts with public/private key authentication
# https://kb.vmware.com/s/article/1002866
# cat ~/.ssh/id_rsa.pub | ssh root@esxi 'cat > /etc/ssh/keys-root/authorized_keys'

exec "$@"
