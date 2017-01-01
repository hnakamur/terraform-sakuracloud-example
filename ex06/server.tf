variable "password" {}

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
    tags = ["@virtio-net-pci", "Terraform"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    base_nw_ipaddress = "${element("${sakuracloud_internet.router01.nw_ipaddresses}", 0)}"
    base_nw_gateway = "${sakuracloud_internet.router01.nw_gateway}"
    base_nw_mask_len = "28"
    additional_interfaces = [""]
}

resource "sakuracloud_server" "server02" {
    name = "server02"
    disks = ["${sakuracloud_disk.disk02.id}"]
    tags = ["@virtio-net-pci", "Terraform"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    base_nw_ipaddress = "${element("${sakuracloud_internet.router01.nw_ipaddresses}", 1)}"
    base_nw_gateway = "${sakuracloud_internet.router01.nw_gateway}"
    base_nw_mask_len = "28"
    additional_interfaces = [""]
}

resource "sakuracloud_server" "server03" {
    name = "server03"
    disks = ["${sakuracloud_disk.disk03.id}"]
    tags = ["@virtio-net-pci", "Terraform"]
    description = "by Terraform"
    core = "1"
    memory = "1"
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    base_nw_ipaddress = "${element("${sakuracloud_internet.router01.nw_ipaddresses}", 2)}"
    base_nw_gateway = "${sakuracloud_internet.router01.nw_gateway}"
    base_nw_mask_len = "28"
    additional_interfaces = [""]
}

resource "sakuracloud_disk" "disk01" {
    name = "disk01"
    source_archive_id = "112801390647"
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    size = "20"
    hostname = "core01"
    password = "$${password}"
    disable_pw_auth = false
    description = "by Terraform"
}

resource "sakuracloud_disk" "disk02" {
    name = "disk02"
    source_archive_id = "112801390647"
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    size = "20"
    hostname = "core02"
    password = "$${password}"
    disable_pw_auth = false
    description = "by Terraform"
}

resource "sakuracloud_disk" "disk03" {
    name = "disk03"
    source_archive_id = "112801390647"
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    size = "20"
    hostname = "core03"
    password = "$${password}"
    disable_pw_auth = false
    description = "by Terraform"
}

resource "sakuracloud_ssh_key" "terraform"{
    name = "terraform-sshkey"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
    description = "by Terraform"
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
