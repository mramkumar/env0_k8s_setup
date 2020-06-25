resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Allow ssh"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
     Name = format("%s-%s",var.environment_name,"bastion-sg")
  }
}

resource "aws_security_group" "private-sg" {
  name        = "private-sg"
  description = "private access only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  ingress {
    description = "full access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-%s",var.environment_name,"private-sg")
  }
}


resource "aws_security_group" "public-sg" {
  name        = "public-sg"
  description = "public access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-%s",var.environment_name,"public-sg")
  }
}
