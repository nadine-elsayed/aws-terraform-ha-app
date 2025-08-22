output "nadine_vpc_id" {
  value = aws_vpc.nadine_vpc.id
}

output "nadine_public_subnets" {
  value = aws_subnet.nadine_public[*].id
}

output "nadine_private_subnets" {
  value = aws_subnet.nadine_private[*].id
}
