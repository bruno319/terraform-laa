variable "project_id" {
  type = "string"
}

provider "google" {
  project = var.project_id
  region = "us-central1"
  zone = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name = "log-access-analytics"
  machine_type = "n1-standard-4"
  tags = ["web"]

  network_interface {
    network = "default"
    access_config {
    }
  }

  boot_disk {
    initialize_params {
      image = "log-access-analytics"
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name = "log-access-analytics-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "allow-http" {
  name = "allow-http"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "80",
      "8080",
      "8082",
      "8084"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web"]
}

output "ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}