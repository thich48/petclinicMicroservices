# Terraform Variables

variable "environment" {
  description = "Environment name for deployment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region resources are deployed to"
  type        = string
  default     = "eu-west-1"
}

# VPC Variables

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet cidr block"
  type        = string
  default     = "10.0.0.0/24"
}

# IAM Role Variables

variable "ec2-trust-policy" {
  description = "sts assume role policy for EC2"
  type        = string
  default     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }   
    ]
}
EOF  
}

variable "ec2-s3-permissions" {
  description = "IAM permissions for EC2 to S3"
  type        = string
  default     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# S3 Variables

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "terraformjenkinshichams3bucket"
}

# EC2 Variables

variable "ssh_key" {
  description = "ssh key name"
  type        = string
  default     = "jenkinsKey"
}

variable "instance_type" {
  description = "Jenkins EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "ec2_user_data" {
  description = "User data shell script for Jenkins EC2"
  type        = string
  default     = <<EOF
#!/bin/bash

    sudo hostname jenkins
    sudo yum update –y

  #install Maven
  sudo yum install maven -y

  # Install Jenkins

    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade
    
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins

    #install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
    sudo apt install unzip
    sudo unzip awscliv2.zip
    sudo ./aws/install
    aws --version

    #install Git
    sudo yum install git -y

    #install eksctl
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    #Move the extracted binary to /usr/local/bin.
    sudo mv /tmp/eksctl /usr/local/bin
  
    #install kubectl
    sudo curl --silent --location -o /usr/local/bin/kubectl   https://s3.us-west-2.amazonaws.com/amazon-eks/1.25.7/2023-03-17/bin/linux/amd64/kubectl
    sudo chmod +x /usr/local/bin/kubectl     

    #install Docker

    sudo amazon-linux-extras install docker -y
    sudo yum install docker -y
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    sudo usermod -aG docker ec2-user
    sudo usermod -aG docker jenkins
    sudo service jenkins restart
    sudo systemctl daemon-reload

    sudo systemctl restart docker
    sudo systemctl enable docker

    #install Terraform
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform

EOF
}
