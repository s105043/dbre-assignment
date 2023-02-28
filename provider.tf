terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.54.0"
    }
  }
}

provider "google" {
  credentials = "dbre-home-assignment-724ec6a198f6.json"
  project     = "dbre-home-assignment"
  region      = "us-central1"
  zone        = "us-central1-c"
}

provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-c"
}

