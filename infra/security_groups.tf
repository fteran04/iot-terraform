# -------- EC2 --------
resource "aws_instance" "api" {

  count = length(var.subnets)

  ami           = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = var.subnets[count.index]

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  # script automático
  user_data = file("${path.module}/script.sh")

  tags = {
    Name = "FastAPI-${count.index + 1}"
  }
}

# -------- Target Group --------
resource "aws_lb_target_group" "tg" {

  name = "fastapi-tg"

  port     = 8000
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {

    path = "/debug"

    interval = 10
    timeout  = 5

    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# -------- Attach EC2 --------
resource "aws_lb_target_group_attachment" "attach" {

  count = length(var.subnets)

  target_group_arn = aws_lb_target_group.tg.arn

  target_id = aws_instance.api[count.index].id

  port = 8000
}

# -------- ALB --------
resource "aws_lb" "alb" {

  name = "fastapi-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = var.subnets
}

# -------- Listener --------
resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg.arn
  }
}