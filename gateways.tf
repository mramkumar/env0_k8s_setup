# internet gateway
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
     Name = format("%s-%s-%s",var.environment_name,"igw")
  }
}


# nat gateway

resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public_subnets.id,count.index)

  tags = {
     Name = format("%s-%s-%s",var.environment_name,"ngw")
  }
}
