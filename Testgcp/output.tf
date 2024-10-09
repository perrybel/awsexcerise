output "instance_names" {
  value = {
    for key, instance in google_compute_instance.default : key => instance.name
  }
}

output "instance_ips" {
  value = {
    for key, instance in google_compute_instance.default : key => instance.network_interface[0].access_config[0].nat_ip
  }
}
