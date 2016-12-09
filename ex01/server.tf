resource "sakuracloud_server" "server01" {
    name = "server01"
    disks = ["${sakuracloud_disk.disk01.id}"]
    tags = ["@virtio-net-pci", "Terraform"]
    description = "by Terraform"
    core = "2"
    memory = "2"
}

resource "sakuracloud_disk" "disk01" {
    name = "disk01"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    disable_pw_auth = true
    description = "by Terraform"
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
