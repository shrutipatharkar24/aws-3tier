data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
# -------------------------
# Web Tier EC2
# -------------------------

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.web.id
  vpc_security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = true

  user_data = <<-EOF
            #!/bin/bash
            dnf install -y nginx
            systemctl enable nginx
            systemctl start nginx

            cat > /usr/share/nginx/html/index.html <<'HTML'
            <html>
            <head>
              <title>AWS 3-Tier Application</title>
            </head>
            <body>
              <h1>AWS 3-Tier Web Application</h1>
              <h2>Web Tier</h2>
              <p>Web Server: Amazon EC2 + Nginx</p>
              <p>Architecture: Web → App → Database</p>
            </body>
            </html>
            HTML
            EOF

  tags = {
    Name = "web-tier-server"
    Tier = "Web"
  }
}

# -------------------------
# App Tier EC2
# -------------------------

resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.app.id
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Application Tier is running" > /tmp/app-status.txt
            EOF

  tags = {
    Name = "app-tier-server"
    Tier = "App"
  }
}