provider "google" {
  project = "sodium-crane-436519-u1"
  region  = "us-central1"
}

terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "tls" {
  // no config needed
}
