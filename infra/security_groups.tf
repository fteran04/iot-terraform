# ─── Security Group: Load Balancer ───────────────────────────────────────────
resource "aws_security_group" "lb" {
  name        = "sg_loadbalancer"
  vpc_id = var.vpc_id 
  description = "Allow HTTP traffic to the load balancer"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg_loadbalancer" }
}

# ─── Security Group: API instances ───────────────────────────────────────────
resource "aws_security_group" "api" {
  name        = "sg_api"
  vpc_id = var.vpc_id 
  description = "Allow traffic from load balancer and SSH"

  ingress {
    description     = "FastAPI from load balancer"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg_api" }
}

# ─── Security Group: PostgreSQL ───────────────────────────────────────────────
resource "aws_security_group" "postgres" {
  name        = "sg_postgres"
  vpc_id = var.vpc_id 
  description = "Allow PostgreSQL access from API and worker"

  # conexión con gestor de base de datos
  ingress {
    description = "PostgreSQL acceso externo"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # -------------------------
  ingress {
    description     = "PostgreSQL from API"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.api.id]
  }

  ingress {
    description     = "PostgreSQL from worker"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.worker.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg_postgres" }
}

# ─── Security Group: RabbitMQ ─────────────────────────────────────────────────
resource "aws_security_group" "rabbitmq" {
  name        = "sg_rabbitmq"
  vpc_id = var.vpc_id 
  description = "Allow RabbitMQ access from API and worker"

  ingress {
    description     = "AMQP from API"
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = [aws_security_group.api.id]
  }

  ingress {
    description     = "AMQP from worker"
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = [aws_security_group.worker.id]
  }

  ingress {
    description     = "AMQP from producer"
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = [aws_security_group.producer.id]
  }

  ingress {
    description = "RabbitMQ Management UI"
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg_rabbitmq" }
}

# ─── Security Group: Worker ───────────────────────────────────────────────────
resource "aws_security_group" "worker" {
  name        = "sg_worker"
  vpc_id = var.vpc_id 
  description = "Allow SSH access to worker"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg_worker" }
}

# ─── Security Group: Producer ─────────────────────────────────────────────────
resource "aws_security_group" "producer" {
  name        = "sg_producer"
  vpc_id = var.vpc_id
  description = "Allow SSH access to producer"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg_producer" }
}
