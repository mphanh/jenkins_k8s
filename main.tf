terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

locals {
    ami = "ami-0e86e20dae9224db8"
    instance_type = "t2.micro"
    k8s_instance_type = "t2.medium"
    key_name = "wave-cafe-prod-nvir"
}

resource "aws_instance" "k8s_cluster" {
    ami = local.ami
    instance_type = local.k8s_instance_type
    key_name = local.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = data.template_file.k8s.rendered
    tags = {
        Name = "k8s_cluster"
    }
}

resource "aws_instance" "ansible_server" {
    ami = local.ami
    instance_type = local.instance_type
    key_name = local.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = data.template_file.ansible.rendered
    tags = {
        Name = "ansible_server"
    }
}

resource "aws_instance" "jenkins_server" {
    ami = local.ami
    instance_type = local.instance_type
    key_name = local.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = data.template_file.jenkins.rendered
    tags = {
        Name = "jenkins_server"
    }
}

data "template_file" "k8s" {
    template = file("k8s.sh")
}

data "template_file" "jenkins" {
    template = file("jenkins.sh")
}

data "template_file" "ansible" {
    template = file("ansible.sh")
}

resource "aws_security_group" "sg" {
    name = "sg"
    tags = {
        Name = "130924-sg"
    }
    ingress {
        self = true
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}