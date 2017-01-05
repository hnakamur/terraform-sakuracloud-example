#!/bin/sh
set -eu
basedir=/tmp/configdrive.$$
server="$SERVER"
ssh_pub_key="$SSH_PUB_KEY"
dns1="$DNS1"
dns2="$DNS2"
address="$ADDRESS"
gateway="$GATEWAY"
priv_address="$PRIV_ADDRESS"
central_address="$CENTRAL_ADDRESS"

mkdir -p "$basedir/openstack/latest"

cat <<EOF > "$basedir/openstack/latest/user_data"
#cloud-config

users:
  - name: "core"
    ssh-authorized-keys:
      - "${ssh_pub_key}"
coreos:
  etcd2:
    proxy: on
    listen-client-urls: http://localhost:2379
    initial-cluster: etcdserver=http://${central_address}:2380
  fleet:
    etcd_servers: "http://localhost:2379"
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
  units:
    - name: 00-eth0.network
      runtime: true
      content: |
        [Match]
        Name=eth0

        [Network]
        DNS=${dns1}
        DNS=${dns2}
        Address=${address}
        Gateway=${gateway}
    - name: 01-eth1.network
      runtime: true
      content: |
        [Match]
        Name=eth1

        [Network]
        Address=${priv_address}
EOF

config_name="${server}_config"
mkisofs -R -V config-2 -o "${config_name}.iso" "${basedir}"
sacloud-upload-image -f "${config_name}.iso" "${config_name}"
rm "${config_name}.iso"
