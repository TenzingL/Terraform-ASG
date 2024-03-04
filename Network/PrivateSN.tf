variable "privateSN-availability-zones"{

}
resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = aws_vpc.mainvpc.cidr_block
    gateway_id = "local"
  }
}
resource "aws_route_table_association" "private-network" {
  count = length(aws_subnet.PrivateSNs) 
  route_table_id = aws_route_table.private-RT.id
  subnet_id = aws_subnet.PrivateSNs[count.index].id
}

resource "aws_subnet" "PrivateSNs" {
    count = length(var.privateSN-availability-zones)
    vpc_id = aws_vpc.mainvpc.id
    cidr_block = cidrsubnet(aws_vpc.mainvpc.cidr_block, 4, count.index + length(var.publicSN-availability-zones))
    availability_zone = var.privateSN-availability-zones[count.index]
    map_public_ip_on_launch = false
    tags = { name = "PrivateSN-${count.index+1}"}
}