resource "aws_key_pair" "sshkey" {
  key_name   = "${var.environment}-sshkey"
  public_key = file(var.path_to_public_key)

    tags = merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-pubkey"
    )
  )
}

resource "aws_instance" "windows-jumpbox" {
  ami           = var.win_amis[var.aws_region]
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.sshkey.key_name
  vpc_security_group_ids=[aws_security_group.allow-all.id]

  root_block_device {
    delete_on_termination = true
    volume_size = 1000
    volume_type = "gp2"
  }
  tags = merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-windows_jumpbox"
    )
  )
}

resource "aws_instance" "windows-system" {
  for_each = toset(var.windows_machines)
  ami           = var.win_amis[var.aws_region]
  associate_public_ip_address = false
  subnet_id = var.subnet_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.sshkey.key_name
  vpc_security_group_ids=[aws_security_group.allow-all.id]

  root_block_device {
    delete_on_termination = true
    volume_size = 1000
    volume_type = "gp2"
  }
  tags = merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-windows-${each.value}"
    )
  )
}
