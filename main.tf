provider "aws" {
  region = "ap-south-1"
}

variable "sg_ports" {
  default = [22,8001]
}

data "aws_ami" "ami_info"{
  most_recent = true

  filter {
    name = "description"
    values = ["Amazon Linux 2 Kernel 5.10 AMI 2.0.20220805.0 x86_64 HVM gp2"]
    }
  filter {
    name = "virtualization-type"
    values = ["hvm"] 
    }


}


resource "aws_instance" "my_ec2" {
  ami =  data.aws_ami.ami_info.id
  instance_type  = "t2.micro" 
  vpc_security_group_ids = [aws_security_group.sg1.id]
  key_name = "ec2-user"
  user_data = file("entry.sh")
}



resource "aws_security_group" "sg1" {
  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port 
    content{ 
    from_port = port.value  
    to_port = port.value
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  
}

output "ec2_public_ip" {
  value= aws_instance.my_ec2.public_ip
}

