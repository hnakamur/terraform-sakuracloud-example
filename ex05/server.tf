resource "sakuracloud_internet" "router01" {
    name = "router01"
    description = "by Terraform"
    tags = ["Terraform"]
    nw_mask_len = 28
    band_width = 100
}

resource "sakuracloud_server" "web01" {
    name = "web01"
    description = "by Terraform"
    core = "1"
    memory = "1"
    disks = ["${sakuracloud_disk.web01.id}"]
    tags = ["@virtio-net-pci","Terraform"]
    base_interface = "${sakuracloud_internet.router01.switch_id}"
    base_nw_ipaddress = "${element("${sakuracloud_internet.router01.nw_ipaddresses}", 0)}"
    base_nw_gateway = "${sakuracloud_internet.router01.nw_gateway}"
    base_nw_mask_len = "28"
    additional_interfaces = [""]
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

# resource "sakuracloud_server" "db01" {
#     name = "db01"
#     description = "by Terraform"
#     core = "1"
#     memory = "1"
#     disks = ["${sakuracloud_disk.db01.id}"]
#     tags = ["@virtio-net-pci","Terraform"]
#     base_interface = "${sakuracloud_internet.router01.id}"
#     base_nw_ipaddress = "${sakuracloud_internet.router01.nw_ipaddresses[1]}"
#     base_nw_gateway = "${sakuracloud_internet.router01.nw_gateway}"
#     base_nw_mask_len = "28"
# }
# 
# resource "sakuracloud_disk" "db01"{
#     name = "db01"
#     hostname = "db01"
#     description = "by Terraform"
#     source_archive_id = "${data.sakuracloud_archive.centos.id}"
#     ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
#     disable_pw_auth = true
#     tags = ["Terraform"]
# }

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
