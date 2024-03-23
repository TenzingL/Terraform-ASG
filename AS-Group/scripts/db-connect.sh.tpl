#!/bin/bash
yum update -y
yum install mariadb105 -y
export endpoint="${rds_endpoint}"
cat > ~/db-connect.sh <<EOF
#!/bin/bash
mysql -h \$endpoint -u admin -p password1
EOF
chmod +x db-connect.sh