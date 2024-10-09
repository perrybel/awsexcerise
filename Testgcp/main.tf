

resource "google_compute_instance" "default" {
  for_each = var.instances

  name         = each.value.name
  machine_type = each.value.instance_type
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  depends_on = [local_file.ssh_public_key_pem]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "${var.user}:${("${var.public_key}")}"
  }
}



resource "google_compute_firewall" "default" {
  name    = "test-firewall2"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

