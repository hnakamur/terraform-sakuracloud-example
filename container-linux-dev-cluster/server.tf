resource "sakuracloud_internet" "router01" {
    name = "router01"
    description = "by Terraform"
    tags = ["Terraform"]
    nw_mask_len = 28
    band_width = 100
}

resource "sakuracloud_switch" "switch01" {
    name = "switch01"
    description = "by Terraform"
    tags = ["Terraform"]
}

resource "sakuracloud_server" "central01" {
    name = "central01"
    disks = ["${sakuracloud_disk.central01_disk.id}"]
    cdrom_id = "${data.sakuracloud_cdrom.central01_config.id}"
    tags = ["@virtio-net-pci", "central"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    additional_interfaces = ["${sakuracloud_switch.switch01.id}"]
}
resource "sakuracloud_disk" "central01_disk" {
    name = "central01_disk"
    source_archive_id = "${data.sakuracloud_archive.containerlinux.id}"
    size = "40"
    description = "by Terraform"
}
data "sakuracloud_cdrom" "central01_config" {
    filter = {
        name   = "Name"
        values = ["central01_config"]
    }
}

resource "sakuracloud_server" "worker01" {
    name = "worker01"
    disks = ["${sakuracloud_disk.worker01_disk.id}"]
    cdrom_id = "${data.sakuracloud_cdrom.worker01_config.id}"
    tags = ["@virtio-net-pci", "worker"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    additional_interfaces = ["${sakuracloud_switch.switch01.id}"]
}
resource "sakuracloud_disk" "worker01_disk" {
    name = "worker01_disk"
    source_archive_id = "${data.sakuracloud_archive.containerlinux.id}"
    size = "40"
    description = "by Terraform"
}
data "sakuracloud_cdrom" "worker01_config" {
    filter = {
        name   = "Name"
        values = ["worker01_config"]
    }
}

resource "sakuracloud_server" "worker02" {
    name = "worker02"
    disks = ["${sakuracloud_disk.worker02_disk.id}"]
    cdrom_id = "${data.sakuracloud_cdrom.worker02_config.id}"
    tags = ["@virtio-net-pci", "worker"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    additional_interfaces = ["${sakuracloud_switch.switch01.id}"]
}
resource "sakuracloud_disk" "worker02_disk" {
    name = "worker02_disk"
    source_archive_id = "${data.sakuracloud_archive.containerlinux.id}"
    size = "40"
    description = "by Terraform"
}
data "sakuracloud_cdrom" "worker02_config" {
    filter = {
        name   = "Name"
        values = ["worker02_config"]
    }
}

data "sakuracloud_archive" "containerlinux" {
    filter = {
        name   = "Tags"
        values = ["current-stable", "arch-64bit", "distro-containerlinux"]
    }
}

output "router01_ipaddress" {
    value = "${sakuracloud_internet.router01.nw_address}"
}

output "router01_gateway" {
    value = "${sakuracloud_internet.router01.nw_gateway}"
}

output "router01_min_ipaddress" {
    value = "${sakuracloud_internet.router01.nw_min_ipaddress}"
}

output "router01_max_ipaddress" {
    value = "${sakuracloud_internet.router01.nw_max_ipaddress}"
}

output "router01_ipaddresses" {
    value = ["${sakuracloud_internet.router01.nw_ipaddresses}"]
}
