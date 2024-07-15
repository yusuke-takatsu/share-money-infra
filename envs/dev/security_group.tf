# ===============================================================================
# app
# ===============================================================================
resource "aws_security_group" "app" {
  name        = "${local.project}-${local.env}-app"
  description = "security group for ${local.project}-${local.env} app"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "${local.project}-${local.env}-app"
  }
}

# ===============================================================================
# vpc内部のリソース同士の通信
# ===============================================================================
resource "aws_security_group" "vpc" {
  name        = "${local.project}-${local.env}-vpc"
  description = "security group for ${local.project}-${local.env} vpc"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project}-${local.env}-vpc"
  }
}