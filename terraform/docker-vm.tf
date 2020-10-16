resource "aws_key_pair" "Docker-VM-ssh-key" {
  key_name   = "Docker-VM-ssh-key"
  public_key = file("${var.PATH_PUB_KEY}")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["919814621061/www-ubuntu-16-04-hvm-22092017-201709220907"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["919814621061"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = ${aws_key_pair.Docker-VM-ssh-key.name}"
  vpc_security_group_ids = [${aws_security_group.Docker-VM.id}]
  subnet_id = ${aws_subnet.Public-1.id}
  associate_public_ip_address = True
  root_block_device {
    volume_size = "100"
  }
  user_data =<<-EOF
                 #!/bin/bash
                 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add 
                 sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                 sudo apt-get update -y 
                 apt-get install -y docker-ce
                EOF

  tags = {
    Name = "Test"
  }
}