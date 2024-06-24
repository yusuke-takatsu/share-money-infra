resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${local.project}-${local.env}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.project}-${local.env}"
  }
}

# ===============================================================================
# public subnet
# ===============================================================================
resource "aws_subnet" "public" {
  for_each = var.azs

  availability_zone       = "${local.region}${each.key}"
  cidr_block              = each.value.public_cidr
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  tags = {
    Name = "${local.project}-${local.env}-public-${local.region}${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  lifecycle {
    ignore_changes = [
      route,
    ]
  }

  tags = {
    Name = "${local.project}-${local.env}"
  }
}

resource "aws_route" "internet_gateway_public" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  route_table_id         = aws_route_table.public.id
}

resource "aws_route_table_association" "public" {
  for_each = var.azs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# ===============================================================================
# private subnet
# ===============================================================================
resource "aws_subnet" "private" {
  for_each = var.azs

  availability_zone       = "${local.region}${each.key}"
  cidr_block              = each.value.private_cidr
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  tags = {
    Name = "${local.project}-${local.env}-private-${local.region}${each.key}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  lifecycle {
    ignore_changes = [
      route,
    ]
  }

  tags = {
    Name = "${local.project}-${local.env}-private"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.azs

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}