# create master node

resource "aws_instance" "master" {
  depends_on    = [aws_route.associate-nat-gw]
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
  depends_on    = [aws_route.associate-nat-gw]
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


# create bastion ec2 instance
resource "aws_instance" "bastion-host" {
  depends_on             = [aws_route.associate-internet-gw]
  key_name               = aws_key_pair.public-key.key_name
  ami                    = var.image_id
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id              =  aws_subnet.public-subnets["us-east-1a"].id
  instance_type          = var.bastion_instance_type
  tags = {
    Name = format("%s-%s",var.environment_name,"bastion")
  }
}
