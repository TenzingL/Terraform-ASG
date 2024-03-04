resource "aws_vpc" "mainvpc" {
    cidr_block = "172.31.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    tags = { name = "mainvpc" }
}
output "mainvpc" {
  value = aws_vpc.mainvpc.id
}
output "cidr-block" {
  value = aws_vpc.mainvpc.cidr_block
}