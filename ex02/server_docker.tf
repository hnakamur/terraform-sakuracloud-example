resource "sakuracloud_disk" "server01"{
    name = "server01"
    hostname = "server01"
    description = "by Terraform"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    note_ids = ["${sakuracloud_note.docker_setup.id}"]
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    disable_pw_auth = true
    tags = ["Terraform"]
}

resource "sakuracloud_note" "docker_setup" {
    name = "docker_setup"
    #content = "${file("docker_setup.sh")}"
    content = <<EOF
curl -sSL https://get.docker.com/ | sh
systemctl enable docker
systemctl start docker
EOF
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
