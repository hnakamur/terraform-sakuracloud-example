resource "sakuracloud_internet" "router01" {
    name = "router01"
    description = "by Terraform"
    tags = ["Terraform"]
    nw_mask_len = 28
    band_width = 100
}

resource "sakuracloud_server" "server01" {
    name = "server01"
    disks = ["${sakuracloud_disk.disk01.id}"]
    cdrom_id = "112900007436"
    tags = ["@virtio-net-pci", "Terraform"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    additional_interfaces = [""]
}
resource "sakuracloud_disk" "disk01" {
    name = "disk01"
    source_archive_id = "${data.sakuracloud_archive.containerlinux.id}"
    size = "40"
    description = "by Terraform"
}

resource "sakuracloud_server" "server02" {
    name = "server02"
    disks = ["${sakuracloud_disk.disk02.id}"]
    cdrom_id = "112900007408"
    tags = ["@virtio-net-pci", "Terraform"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    additional_interfaces = [""]
}
resource "sakuracloud_disk" "disk02" {
    name = "disk02"
    source_archive_id = "${data.sakuracloud_archive.containerlinux.id}"
    size = "40"
    description = "by Terraform"
}

resource "sakuracloud_server" "server03" {
    name = "server03"
    disks = ["${sakuracloud_disk.disk03.id}"]
    cdrom_id = "112900007686"
    tags = ["@virtio-net-pci", "Terraform"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    additional_interfaces = [""]
}
resource "sakuracloud_disk" "disk03" {
    name = "disk03"
    source_archive_id = "${data.sakuracloud_archive.containerlinux.id}"
    size = "40"
    description = "by Terraform"
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
