resource "aws_key_pair" "bastion-pem" {
  key_name   = format("%s", "${var.env_name}-bastion-key")
  public_key = var.bastion_public_key
}

resource "aws_instance" "ec2" {
  count                       = var.count_ec2_instance
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip
  key_name                    = aws_key_pair.bastion-pem.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  vpc_security_group_ids      = [module.bastion_security_group.sg_id]
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  tags = merge(
    {
      Name = format("%s-%d", var.name, count.index + 1)
    },
    {
      PROVISIONER = "Terraform"
    },
    var.tags,
  )
}