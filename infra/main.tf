# -------- VPC --------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" # red privada principal

  tags = {
    Name = "mi-vpc"
  }
}

# -------- Internet Gateway --------
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id # conecta la VPC a internet

  tags = {
    Name = "mi-gw"
  }
}

# -------- Subnet pública --------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24" # segmento de la red
  map_public_ip_on_launch = true          # IP pública automática

  tags = {
    Name = "mi-subnet-publica"
  }
}

# -------- Tabla de rutas --------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"              # todo el tráfico
    gateway_id = aws_internet_gateway.gw.id # sale por internet
  }
}

# Asociar subnet a la tabla de rutas
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -------- Security Group --------
resource "aws_security_group" "ssh" {
  name   = "permitir-ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22      # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # luego restringimos
  }

  ingress {
    from_port   = 8000    # tu API
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0       # salida libre
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------- EC2 --------
resource "aws_instance" "api" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu (us-east-1)
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ssh.id]

  key_name = "mi-clave" # clave SSH creada en AWS

  tags = {
    Name = "mi-api"
  }
}