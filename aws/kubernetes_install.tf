# run inventory script to create ansible inventory file with ec2 instance details
resource "null_resource" "ansible_inventory" {
  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [aws_instance.bastion-host,aws_instance.master,aws_instance.worker]

  provisioner "local-exec" {
    command = "python inventory.py"

  }
}

# install pkgs in bastion host to deploy kubernetes
resource "null_resource" "configure_k8s" {

  depends_on = [null_resource.ansible_inventory]

  provisioner "file" {
    content     = tls_private_key.ssh-key.private_key_pem
    destination = "~/.ssh/id_rsa"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.ssh-key.private_key_pem
      host        = aws_instance.bastion-host.public_ip
    }
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh-key.private_key_pem
    host        = aws_instance.bastion-host.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt update",
      "sudo apt install ansible git python-netaddr -y",
      "sudo git clone https://github.com/kubernetes-sigs/kubespray.git",
      "sudo chmod 400 /home/ubuntu/.ssh/id_rsa"
    ]
  }
}

# trigger kubespray in bastion host to install kubernetes

resource "null_resource" "k8s_install" {

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [null_resource.configure_k8s,null_resource.ansible_inventory]

  provisioner "file" {
    source      = "hosts"
    destination = "/home/ubuntu/hosts"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.ssh-key.private_key_pem
      host        = aws_instance.bastion-host.public_ip
    }
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh-key.private_key_pem
    host        = aws_instance.bastion-host.public_ip
  }

  provisioner "remote-exec" {
    inline = [
	"sudo mv /home/ubuntu/hosts /home/ubuntu/kubespray && cd /home/ubuntu/kubespray && ansible-playbook -i hosts /home/ubuntu/kubespray/cluster.yml -b -v  --private-key=/home/ubuntu/.ssh/id_rsa --become-method=sudo"
    ]
  }

}
