resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"

  tags = {
    task="toptal"
  }
}
resource "aws_subnet" "Public-1" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "${var.region}a"
	tags = {
    task="toptal"
    Name = "Public-Subnet-1"
  	}
}
resource "aws_subnet" "Public-2" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.2.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "${var.region}b"
	tags = {
    task="toptal"
    Name = "Public-Subnet-2"
  	}
}
resource "aws_subnet" "Public-3" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.3.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "${var.region}c"
	tags = {
    task="toptal"
    Name = "Public-Subnet-3"
  	}
}
resource "aws_subnet" "Private-1" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.4.0/24"
	availability_zone = "${var.region}a"
	tags = {
    task="toptal"
    Name = "Private-Subnet-1"
  	}
}
resource "aws_subnet" "Private-2" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.5.0/24"
	availability_zone = "${var.region}b"
	tags = {
    task="toptal"
    Name = "Private-Subnet-2"
  	}
}

resource "aws_subnet" "Private-3" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.6.0/24"
	availability_zone = "${var.region}c"
	tags = {
    task="toptal"
    Name = "Private-Subnet-3"
  	}
}
resource "aws_internet_gateway" "main" {
	vpc_id = "${aws_vpc.main.id}"
	tags = {
    task="toptal"
  }
}

resource "aws_route_table" "main-public" {
	vpc_id = "${aws_vpc.main.id}"
	route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  } 
}

resource "aws_route_table_association" "a" {
	subnet_id = "${aws_subnet.Public-1.id}"
	route_table_id = "${aws_route_table.main-public.id}"
}
resource "aws_route_table_association" "b" {
	subnet_id = "${aws_subnet.Public-2.id}"
	route_table_id = "${aws_route_table.main-public.id}"
}
resource "aws_route_table_association" "c" {
	subnet_id = "${aws_subnet.Public-3.id}"
	route_table_id = "${aws_route_table.main-public.id}"
}
