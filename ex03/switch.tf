resource "sakuracloud_switch" "local-sw01" {
    name = "local-sw01"
    description = "by Terraform"
    tags = ["Terraform"]
}

resource "sakuracloud_server" "web01" {
    name = "web01"
    description = "by Terraform"
    core = "1"
    memory = "1"
    disks = ["${sakuracloud_disk.web01.id}"]
    tags = ["@virtio-net-pci","Terraform"]
    base_interface = "shared"
    additional_interfaces = ["${sakuracloud_switch.local-sw01.id}"]
}

resource "sakuracloud_disk" "web01"{
    name = "web01"
    hostname = "web01"
    description = "by Terraform"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    disable_pw_auth = true
    tags = ["Terraform"]
}

resource "sakuracloud_server" "db01" {
    name = "db01"
    description = "by Terraform"
    core = "1"
    memory = "1"
    disks = ["${sakuracloud_disk.db01.id}"]
    tags = ["@virtio-net-pci","Terraform"]
    base_interface = "shared"
    additional_interfaces = ["${sakuracloud_switch.local-sw01.id}"]
}

resource "sakuracloud_disk" "db01"{
    name = "db01"
    hostname = "db01"
    description = "by Terraform"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    disable_pw_auth = true
    tags = ["Terraform"]
}

data "sakuracloud_archive" "centos" {
    filter = {
        name   = "Tags"
        values = ["current-stable", "arch-64bit", "distro-centos"]
    }
}

resource "sakuracloud_ssh_key" "terraform"{
    name = "terraform-sshkey"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
    description = "by Terraform"
}

output "web01_ipaddress" {
    value = "${sakuracloud_server.web01.base_nw_ipaddress}"
}

output "web01_gateway" {
    value = "${sakuracloud_server.web01.base_nw_gateway}"
}

output "web01_dns_servers" {
    value = ["${sakuracloud_server.web01.base_nw_dns_servers}"]
}

output "db01_ipaddress" {
    value = "${sakuracloud_server.db01.base_nw_ipaddress}"
}

output "db01_gateway" {
    value = "${sakuracloud_server.db01.base_nw_gateway}"
}

output "db01_dns_servers" {
    value = ["${sakuracloud_server.db01.base_nw_dns_servers}"]
}
