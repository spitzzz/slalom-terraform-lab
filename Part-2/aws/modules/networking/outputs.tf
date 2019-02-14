output "vpc-id" {
    value = "${aws_vpc.vpc.id}"
}

output "public-subnet1-id" {
    value = "${aws_subnet.public-subnet1.id}"
}