# public rt
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-%s",var.environment_name,"public-rt")
  }
}

# associate rt's
resource "aws_route_table_association" "public-rt-associate" {
  for_each =  var.public_subnets
  subnet_id      = aws_subnet.public-subnets[each.key].id
  route_table_id = aws_route_table.public-rt.id
}

# associate internet gateway
resource "aws_route" "associate-internet-gw" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gw.id
}

# private rt
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id
  tags = {
      Name = format("%s-%s",var.environment_name,"private-rt")
  }
}

# associate rt's
resource "aws_route_table_association" "private-rt-associate" {
  for_each =  var.private_subnets
  subnet_id      = aws_subnet.private-subnets[each.key].id
  route_table_id = aws_route_table.private-rt.id
}

# associate nat gateway
resource "aws_route" "associate-nat-gw" {
  route_table_id         = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
}
