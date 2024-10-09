output "vpc_name" {
  value = google_compute_network.custom-vpc.name
}

output "subnet_cidr" {
  value = google_compute_subnetwork.subnet.ip_cidr_range
}
