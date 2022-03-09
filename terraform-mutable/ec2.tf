resource "aws_spot_instance_request" "ec2-spot" {
  count = var.INSTANCE_COUNT
  ami           = data.aws_ami.ami.id
  instance_type = var.INSTANCE_TYPE
  tags = {
    Name = "${var.COMPONENT}-${var.ENV}-${count.index+1}"
  }
 subnet_id = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS[count.index]
  #creates ec2 spot instance in that particular vpc and private subnet id getting data from data.tf remote state resource
  wait_for_fulfillment = true
}

resource "aws_ec2_tag" "spot-instances" {
  count = length(aws_spot_instance_request.ec2-spot)
  resource_id = aws_spot_instance_request.ec2-spot.*.spot_instance_id[count.index]
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}-${count.index+1}"
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.ENV}-${var.COMPONENT}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}

resource "aws_lb_target_group_attachment" "tg-attach" {
  count = length(aws_spot_instance_request.ec2-spot)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_spot_instance_request.ec2-spot.*.spot_instance_id[count.index]
  port             = 80
}