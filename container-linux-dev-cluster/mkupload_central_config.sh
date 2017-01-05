#!/bin/sh
set -eu
basedir=/tmp/configdrive.$$
server="$SERVER"
ssh_pub_key="$SSH_PUB_KEY"
dns1="$DNS1"
dns2="$DNS2"
address="$ADDRESS"
gateway="$GATEWAY"
priv_address="${PRIV_ADDRESS}"
etcd_address="${priv_address%/*}"

mkdir -p "$basedir/openstack/latest"

cat <<EOF > "$basedir/openstack/latest/user_data"
#cloud-config

users:
  - name: "core"
    ssh-authorized-keys:
      - "${ssh_pub_key}"
coreos:
  etcd2:
    name: etcdserver
    initial-cluster: etcdserver=http://${etcd_address}:2380
    initial-advertise-peer-urls: http://${etcd_address}:2380
    advertise-client-urls: http://${etcd_address}:2379
    # listen on both the official ports and the legacy ports
    # legacy ports can be omitted if your application doesn't depend on them
    #listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-client-urls: http://0.0.0.0:2379
    listen-peer-urls: http://0.0.0.0:2380
  units:
    - name: etcd2.service
      command: start
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
