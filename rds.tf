# -------------------------
# DB Subnet Group
# -------------------------

resource "aws_db_subnet_group" "database" {
  name = "three-tier-db-subnet"

  subnet_ids = [
    aws_subnet.db.id,
    aws_subnet.db2.id
  ]

  tags = {
    Name = "three-tier-db-subnet"
    Tier = "Database"
  }
}

# -------------------------
# Database Tier
# -------------------------

resource "aws_db_instance" "database" {
  identifier = "three-tier-database"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "studentdb"
  username = "admin"
  password = "StudentDB12345!"

  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false

  skip_final_snapshot = true

  deletion_protection = false

  tags = {
    Name = "three-tier-database"
    Tier = "Database"
  }
}