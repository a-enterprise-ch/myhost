#!/bin/sh
iptables="/etc/sysconfig/iptables"
sed -i '/#DDNSIP/d' $iptables
lookup="$(grep -i "#MyDDNS" $iptables)"
select=( $lookup )
ddns="${select[2]}"
echo $select $ddns
ip="$(host $ddns)"
if [ "$ip" == "${ip%% has address *}" ]; then
continue;
fi
ip="${ip##* has address }"
sed -i 's/^\('"$lookup"'\)$/\1\n-A RH-Firewall-1-INPUT -i eth0 -p udp -m udp -s '"$ip"' -m comment --comment #DDNSIP -j ACCEPT/' $iptables
service iptables restart