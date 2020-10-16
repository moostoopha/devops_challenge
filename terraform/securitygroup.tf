
resource "aws_security_group" "Docker-VM" {
  name        = "Docker-VM"
  description = "Allow HTTP"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }

  tags = {
    task="test"
    Name = "Docker-VM"
    }
}
