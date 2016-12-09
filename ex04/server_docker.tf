resource "sakuracloud_server" "server01" {
    name = "server01"
    disks = ["${sakuracloud_disk.disk01.id}"]
    tags = ["@virtio-net-pci", "Terraform"]
    description = "by Terraform"
    core = "1"
    memory = "1"
}

resource "sakuracloud_disk" "disk01"{
    name = "disk01"
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

show_info() {
  echo ID=@@@.ID@@@ 
  echo Name=@@@.Name@@@ 
  echo === ls -l /root/.sacloud-api/server.json
  ls -l /root/.sacloud-api/server.json
  echo === cat /root/.sacloud-api/server.json
  cat /root/.sacloud-api/server.json
  echo === ip a
  ip a
  echo === cat /etc/resolv.conf
  cat /etc/resolv.conf
}

show_info | tee -a /root/startup_script.log
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
