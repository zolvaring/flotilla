data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "test_security_group" {
  name = "test_security_group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  description = "Test security group."
  vpc_id = "vpc-05534262"

}

resource "aws_instance" "test_instance" {
  # 1. Add resource name.
  # 2. Specify VPC subnet ID
  # 3. Specify EC2 instance type.
  # 4. Specify Security group for this instance (use one that we create above).
  # Docs: https://www.terraform.io/docs/providers/aws/r/instance.html
  ami = "${data.aws_ami.centos.id}"
  subnet_id = "subnet-8c2d68c5"
  instance_type = "t2.nano"
  vpc_security_group_ids = [ "${aws_security_group.test_security_group.id}" ]
  associate_public_ip_address = false
  # user_data = "${file("../shared/user-data.txt")}"
  tags {
    Name = "test-instance"
  }
  availability_zone = "us-west-2a"
  
}
