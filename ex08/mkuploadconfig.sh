#!/bin/sh
set -eu
basedir=/tmp/configdrive.$$
server="$SERVER"
ssh_pub_key="$SSH_PUB_KEY"
dns1="$DNS1"
dns2="$DNS2"
address="$ADDRESS"
gateway="$GATEWAY"

mkdir -p "$basedir/openstack/latest"

cat <<EOF > "$basedir/openstack/latest/user_data"
#cloud-config

users:
  - name: "core"
    ssh-authorized-keys:
      - "${ssh_pub_key}"
coreos:
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
EOF

config_name="${server}-config"
mkisofs -R -V config-2 -o "${config_name}.iso" "${basedir}"
sacloud-upload-image -f "${config_name}.iso" "${config_name}"
