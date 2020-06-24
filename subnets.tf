resource "aws_subnet" "private-subnets" {
  for_each = var.private_subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  tags = {
    Name = var.environment_name-private-each.key
  }
}
