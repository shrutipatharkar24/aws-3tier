# -------------------------
# Web Tier Security Group
# -------------------------

resource "aws_security_group" "web" {
  name        = "web-tier-sg"
  description = "Security group for Web Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "web-tier-sg"
    Tier = "Web"
  }
}

# -------------------------
# App Tier Security Group
# -------------------------

resource "aws_security_group" "app" {
  name        = "app-tier-sg"
  description = "Security group for App Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Application traffic from Web Tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-tier-sg"
    Tier = "App"
  }
}

# -------------------------
# Database Security Group
# -------------------------

resource "aws_security_group" "db" {
  name        = "db-tier-sg"
  description = "Security group for Database Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from App Tier only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-tier-sg"
    Tier = "Database"
  }
}