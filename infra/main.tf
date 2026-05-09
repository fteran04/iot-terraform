# ─── PostgreSQL EC2 ──────────────────────────────────────────────────────────
resource "aws_instance" "postgres" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id     = var.subnet_id 
  vpc_security_group_ids = [aws_security_group.postgres.id]

  user_data = templatefile("${path.module}/scripts/install_postgres.sh", {
    db_user     = var.db_user
    db_password = var.db_password
    db_name     = var.db_name
  })

  tags = { Name = "postgres-server" }
}

# ─── RabbitMQ EC2 ────────────────────────────────────────────────────────────
resource "aws_instance" "rabbitmq" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id     = var.subnet_id 
  vpc_security_group_ids = [aws_security_group.rabbitmq.id]

  user_data = templatefile("${path.module}/scripts/install_rabbitmq.sh", {
    rabbitmq_user     = var.rabbitmq_user
    rabbitmq_password = var.rabbitmq_password
  })

  tags = { Name = "rabbitmq-server" }
}

# ─── API 1 EC2 ───────────────────────────────────────────────────────────────
resource "aws_instance" "api1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id     = var.subnet_id 
  vpc_security_group_ids = [aws_security_group.api.id]

  user_data = templatefile("${path.module}/scripts/install_api.sh", {
    dockerhub_username = var.dockerhub_username
    db_host            = aws_instance.postgres.private_ip
    db_user            = var.db_user
    db_password        = var.db_password
    db_name            = var.db_name
    rabbitmq_host      = aws_instance.rabbitmq.private_ip
    rabbitmq_user      = var.rabbitmq_user
    rabbitmq_password  = var.rabbitmq_password
    init_db            = "true"
  })

  tags = { Name = "api1-server" }
}

# ─── API 2 EC2 ───────────────────────────────────────────────────────────────
resource "aws_instance" "api2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id     = var.subnet_id 
  vpc_security_group_ids = [aws_security_group.api.id]

  user_data = templatefile("${path.module}/scripts/install_api.sh", {
    dockerhub_username = var.dockerhub_username
    db_host            = aws_instance.postgres.private_ip
    db_user            = var.db_user
    db_password        = var.db_password
    db_name            = var.db_name
    rabbitmq_host      = aws_instance.rabbitmq.private_ip
    rabbitmq_user      = var.rabbitmq_user
    rabbitmq_password  = var.rabbitmq_password
    init_db            = "false"
  })

  tags = { Name = "api2-server" }
}

# ─── Worker EC2 ──────────────────────────────────────────────────────────────
resource "aws_instance" "worker" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id     = var.subnet_id 
  vpc_security_group_ids = [aws_security_group.worker.id]

  user_data = templatefile("${path.module}/scripts/install_worker.sh", {
    dockerhub_username = var.dockerhub_username
    db_host            = aws_instance.postgres.private_ip
    db_user            = var.db_user
    db_password        = var.db_password
    db_name            = var.db_name
    rabbitmq_host      = aws_instance.rabbitmq.private_ip
    rabbitmq_user      = var.rabbitmq_user
    rabbitmq_password  = var.rabbitmq_password
  })

  tags = { Name = "worker-server" }
}

# ─── Producer EC2 ────────────────────────────────────────────────────────────
resource "aws_instance" "producer" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id     = var.subnet_id 
  vpc_security_group_ids = [aws_security_group.producer.id]

  user_data = templatefile("${path.module}/scripts/install_producer.sh", {
    dockerhub_username = var.dockerhub_username
    lb_host            = aws_instance.loadbalancer.public_ip
  })

  tags = { Name = "producer-server" }
}

# ─── Load Balancer EC2 (HAProxy) ─────────────────────────────────────────────
resource "aws_instance" "loadbalancer" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id     = var.subnet_id 
  vpc_security_group_ids = [aws_security_group.lb.id]

  user_data = templatefile("${path.module}/scripts/install_loadbalancer.sh", {
    api1_private_ip = aws_instance.api1.private_ip
    api2_private_ip = aws_instance.api2.private_ip
  })

  tags = { Name = "loadbalancer-server" }
}
