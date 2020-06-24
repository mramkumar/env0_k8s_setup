output "bastion-ip" {
  value = aws_instance.z_bastion-host.public_ip
}

output "private-key-output" {
  value = tls_private_key.ssh-key.private_key_pem
}
