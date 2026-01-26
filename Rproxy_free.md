Oracle always free tier
Ubuntu 24
apt-get update
apt-get upgrade
set password on ubuntu account so we can use cloud shell for recovery if needed

<code>
apt-get install wget htop tar iptables-persistent
</code>

vi /etc/systemd/system/zoraxy.service
<code>
text
[Unit]
Description=Zoraxy Reverse Proxy
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/zoraxy
ExecStart=/home/ubuntu/zoraxy/zoraxy.sh
Restart=always
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE  
# NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
</code>


vi ~/zoraxy/zoraxy.sh

<code>
#!/bin/bash
cd /home/ubuntu/zoraxy
./zoraxy -port=:8000 -db=leveldb -default_inbound_port=443 -default_inbound_enabled=true
</code>

chown and chgrp to ubuntu if needed
chmod +x zoraxy.sh
systemctl start zoraxy

