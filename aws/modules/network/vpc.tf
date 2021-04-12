resource "aws_vpc" "main" {
  instance_tenancy = "default"
  cidr_block       = var.vpc_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-vpc"
    )
  )

}

resource "aws_ec2_tag" "main_rt" {
  resource_id = aws_vpc.main.default_route_table_id
  key         = "Name"
  value       = "${var.environment}-rt1"
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(data.aws_availability_zones.available_azs.names, 0)

  map_public_ip_on_launch = true
  cidr_block              = var.private_subnet_cidr

  tags = merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-subnet-1",
    )
  )
}

resource "aws_route_table_association" "main_rt_assoc_core" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_vpc.main.default_route_table_id
}

resource "aws_internet_gateway" "igw" {
  #                        | is_private=true
  count = var.is_private ? 0 : 1
  #                            | is_private=false
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-igw"
    )
  )

}

resource "aws_route" "main_default_route" {
  #                        | is_private=true
  count = var.is_private ? 0 : 1
  #                            | is_private=false
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[count.index].id
}
