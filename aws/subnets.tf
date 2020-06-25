resource "aws_subnet" "private-subnets" {
  for_each = var.private_subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  tags = {
     Name = format("%s-%s-%s",var.environment_name,"private",each.key)
  }
}

resource "aws_subnet" "public-subnets" {
  for_each = var.public_subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  map_public_ip_on_launch = true
  availability_zone = each.key
  tags = {
     Name = format("%s-%s-%s",var.environment_name,"public",each.key)
  }
}
