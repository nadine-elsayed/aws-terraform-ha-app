

resource "aws_vpc" "nadine_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "nadine-project-vpc"
    Project = "nadine-project"
  }
}

resource "aws_internet_gateway" "nadine_igw" {
  vpc_id = aws_vpc.nadine_vpc.id
  tags = {
    Name = "nadine-project-igw"
    Project = "nadine-project"
  }
}

resource "aws_subnet" "nadine_public" {
  count                   = 2
  vpc_id                  = aws_vpc.nadine_vpc.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)
  tags = {
    Name = "nadine-project-public-${count.index + 1}"
    Project = "nadine-project"
  }
}

resource "aws_subnet" "nadine_private" {
  count                   = 2
  vpc_id                  = aws_vpc.nadine_vpc.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index + 2)
  availability_zone       = element(var.azs, count.index)
  tags = {
    Name = "nadine-project-private-${count.index + 1}"
    Project = "nadine-project"
  }
}

resource "aws_eip" "nadine_nat" {
  count  = 1
  domain = "vpc"
  tags = {
    Name = "nadine-project-nat-eip"
    Project = "nadine-project"
  }
}

resource "aws_nat_gateway" "nadine_nat" {
  allocation_id = aws_eip.nadine_nat[0].id
  subnet_id     = aws_subnet.nadine_public[0].id
  tags = {
    Name = "nadine-project-nat"
    Project = "nadine-project"
  }
}

resource "aws_route_table" "nadine_public" {
  vpc_id = aws_vpc.nadine_vpc.id
  tags = {
    Name = "nadine-project-public-rt"
    Project = "nadine-project"
  }
}

resource "aws_route" "nadine_public_internet" {
  route_table_id         = aws_route_table.nadine_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nadine_igw.id
}

resource "aws_route_table_association" "nadine_public" {
  count          = 2
  subnet_id      = aws_subnet.nadine_public[count.index].id
  route_table_id = aws_route_table.nadine_public.id
}

resource "aws_route_table" "nadine_private" {
  vpc_id = aws_vpc.nadine_vpc.id
  tags = {
    Name = "nadine-project-private-rt"
    Project = "nadine-project"
  }
}

resource "aws_route" "nadine_private_nat" {
  route_table_id         = aws_route_table.nadine_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nadine_nat.id
}

resource "aws_route_table_association" "nadine_private" {
  count          = 2
  subnet_id      = aws_subnet.nadine_private[count.index].id
  route_table_id = aws_route_table.nadine_private.id
}
 
