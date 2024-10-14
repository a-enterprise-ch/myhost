## iptables chain for dynamic ip address

The purpose is to lookup IPv4 address of DDNS hostname while append to iptables chain.
Run the script on CentOS or with minor changes on any Linux, may change line 2 for appropriate path to iptables i.e. debian /etc/default.

The `host` command use a part of the BIND utilities so you need to install them. To install the BIND utilities, type the following:
`yum -y install bind-utils`

A line contains with your DDNS hostname tagged with `#MyDDNS` must be entered into the `iptables` configuration file:

````
#Allow from myhost.dyndns.org #MyDDNS
-A RH-Firewall-1-INPUT -i eth0 -p udp -m udp -s 198.51.100.62 -m comment --comment #DDNSIP -j ACCEPT
````
The `-A` chain will automatically appended with first time ran the script. Not. do not forget make it executable: `chmod +x /usr/bin/allow_myhost.sh`. 

The source ip address will automatically lookup and update every 15 min. if changed. The iptables chain are opening the udp protocol which allows ip phones to communicate with the PBX, the rule can be arbitrarily customized, but the comment option `--comment` must be present.

For continuous update create a cron task:
`*/15 * * * * root /usr/bin/allow_myhost.sh >/dev/null 2>&1`