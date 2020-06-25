# ssh key pair creation

resource "tls_private_key" "ssh-key" {
algorithm = "RSA"
}

resource "local_file" "private-key" {
sensitive_content = tls_private_key.ssh-key.private_key_pem
filename          = "private_key"
file_permission   = "0400"
}

resource "aws_key_pair" "public-key" {
key_name   = "bastion"
public_key = tls_private_key.ssh-key.public_key_openssh
}
