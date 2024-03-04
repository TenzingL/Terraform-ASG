variable "publicSN-availability-zones"{

}
resource "aws_internet_gateway" "iGW" {
    vpc_id = aws_vpc.mainvpc.id
    tags = { name = "App-Gateway" }
}
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = aws_vpc.mainvpc.cidr_block
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iGW.id  
  }
}
resource "aws_route_table_association" "public-network" {
  count = length(aws_subnet.publicSNs) //Loops the associations
  route_table_id = aws_route_table.public-RT.id
  subnet_id = aws_subnet.publicSNs[count.index].id
}

resource "aws_subnet" "publicSNs" {
    
    count = length(var.publicSN-availability-zones)
    vpc_id = aws_vpc.mainvpc.id
    cidr_block = cidrsubnet(aws_vpc.mainvpc.cidr_block, 4, count.index)
    availability_zone = var.publicSN-availability-zones[count.index]
    map_public_ip_on_launch = true
    tags = { name = "PublicSN-${count.index+1}"}
}
output "publicSNs"{
    value = aws_subnet.publicSNs
}