resource "aws_security_group" "DB-SG" {
  name = "DB-SG"
  vpc_id = var.vpc-id
  ingress {
    from_port = 3306
    to_port = 3306
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
resource "aws_db_subnet_group" "DB-SN-Group" {
  name = "my-db-group"
  subnet_ids = var.privateSNs[*].id

  tags = { name = "db-group"}
}
resource "aws_db_instance" "Database" {
    allocated_storage = 20
    engine = "mysql"
    engine_version = "8.0.35"
    instance_class = "db.t3.micro"
    username = "admin"
    password = "password"
    publicly_accessible = false
    skip_final_snapshot = true //set false if backup needed on destroy
    tags = { name = "mydatabase" }
    
    vpc_security_group_ids = [aws_security_group.DB-SG.id]
    db_subnet_group_name = aws_db_subnet_group.DB-SN-Group.name
}