# create master node

resource "aws_instance" "master" {
  ami           = var.image_id
  instance_type = var.master_instance_type
  key_name = aws_key_pair.public-key.id
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  for_each = var.master_instances
  subnet_id = aws_subnet.private-subnets[each.value].id
  tags = {
    Name = format("%s-%s",var.environment_name,each.key)
  }
}


# create worker node
resource "aws_instance" "worker" {
  ami           = var.image_id
  instance_type = var.worker_instance_type
  key_name = aws_key_pair.public-key.id
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  for_each = var.worker_instances
  subnet_id = aws_subnet.private-subnets[each.value].id
  tags = {
    Name = format("%s-%s",var.environment_name,each.key)
  }
}
