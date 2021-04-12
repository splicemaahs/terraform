resource "aws_security_group" "allow-all" {
  name="allow-all"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 6556
    protocol = "tcp"
    cidr_blocks = ["23.20.251.250/32", "172.21.12.0/22"]
  }

  tags = merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-allow_rdp"
    )
  )
}
