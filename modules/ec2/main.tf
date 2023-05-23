resource "aws_instance" "default" {
  # Amazon Linux 2023 AMI 2023.0.20230503.0 x86_64 HVM kernel-6.1
  ami                         = "ami-0e0820ad173f20fbb"
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.default.name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.default.id]
  user_data                   = var.user_data
  user_data_replace_on_change = true

  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "intro-web"
  }
}

# IAM Role
data "aws_iam_policy_document" "default" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = "intro-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.default.json
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Profile
resource "aws_iam_instance_profile" "default" {
  name = "intro-ec2-instance-profile"
  role = aws_iam_role.default.name
}

# Security Group
resource "aws_security_group" "default" {
  name        = "intro-ec2-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
