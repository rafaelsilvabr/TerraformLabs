provider "aws" {
  region     = var.region
}

resource "aws_s3_bucket" "blog" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "object1" {
  for_each = fileset("html/", "*")
  bucket = aws_s3_bucket.blog.id
  key = each.value
  source = "html/${each.value}"
  etag = filemd5("html/${each.value}")
  content_type = "text/html"
}

resource "aws_instance" "web" {
  ami = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  iam_instance_profile = "EC2_Role_16359.87169513"
  user_data = <<EOF

    #!/bin/bash
    sudo su
    yum update -y
    yum install httpd -y
    aws s3 cp s3://${aws_s3_bucket.blog.id}/index.html /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
    EOF

  tags = {
    Name = "Whiz-EC2-Instance"
  }
}

resource "aws_security_group" "web-sg" {
  name = "Web-SG"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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