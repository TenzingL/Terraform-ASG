resource "aws_security_group" "app-SG" {
    name = "app-SG"
    vpc_id = var.vpc-id
    ingress {
        from_port = 1
        to_port = 1024
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}
resource "tls_private_key" "private-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "aws_key_pair" "app-key" {
  key_name = "app-key"
  public_key = tls_private_key.private-key.public_key_openssh
}
resource "local_file" "private-key-file" {
  content = tls_private_key.private-key.private_key_pem
  filename = "${path.module}/${aws_key_pair.app-key.key_name}.pem"
}
resource "aws_launch_template" "app" {
    name_prefix = "APP-INSTANCE-"
    instance_type = "t2.micro"
    image_id = "ami-0440d3b780d96b29d"
    vpc_security_group_ids = [ aws_security_group.app-SG.id ]
    key_name = aws_key_pair.app-key.key_name
    lifecycle {
      create_before_destroy = true //Ensures higher availability incase of updates to the launch template
    }
    tags = {name = "launch template"}
}
resource "aws_autoscaling_group" "AS-group" {
  min_size = 2
  max_size = 4
  vpc_zone_identifier = var.publicSNs[*].id
  launch_template {
    id = aws_launch_template.app.id
    version = "$Latest"
  }
}
resource "aws_lb" "app-lb" {
  name = "app-lb"
  internal = false
  load_balancer_type = "application"
  //security_groups = [aws_security_group.app-SG.id] use if launch template doesn't have SG
  subnets = var.publicSNs[*].id
  enable_deletion_protection = false

  tags = { name = "app-lb" }
}
resource "aws_lb_target_group" "app-tg" {
  name = "app-tg"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc-id
}
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}
