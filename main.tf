provider "aws" {
  region = "us-east-1"
}

resource "tls_private_key" "key" {
  algorithm = "RSA"

}

resource "local_file" "private_key" {
  filename        = "${path.module}/ansible-key/private.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "ansible-key"
  public_key = tls_private_key.key.public_key_openssh
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "sg" {
  vpc_id      = data.aws_vpc.default.id
  description = "ansible-sg"
  name        = "ansible-sg"

  ingress {
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
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  // key_name               = aws_key_pair.key_pair.name
  security_groups        = [aws_security_group.sg.name]
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "ansible-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y software-properties-common",
      "sudo add-apt-repository ppa:ansible/ansible -y",
      "sudo apt-get install -y python-pip",
      "sudo pip install ansible",
      "ansible-playbook -i localhost, -c local ./main.yml"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.instance.public_ip
      private_key = local_file.private_key.id
    }

  }

  provisioner "local-exec" {
    command = "ansible-playbook - u ubuntu --key ansible-key/private.pem -T 300 -i ${self.public_ip},main.yml"
  }


}






