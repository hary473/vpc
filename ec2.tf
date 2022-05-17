data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "my-ec2" {
 ami = data.aws_ami.ubuntu.id
 instance_type = "t2.micro"
 subnet_id = aws_subnet.dev-public-1.id
 security_groups = [ "${aws_security_group.web-sg.id}" ]
 associate_public_ip_address="true"
 key_name =var.keyname
 tags ={
    Name="Hello World"
    }  
}    
