# Create VPC network
resource "google_compute_network" "vpc_network2" {
  name = "vpc-network2"
}

# Create subnetwork
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "vpc-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc_network2.self_link
  ip_cidr_range = "10.0.0.0/24"
}

# Create firewall rules to allow internal communication
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc_network2.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/8"]
}

#Create firewall rule to allow incoming PostgreSQL traffic
resource "google_compute_firewall" "allow_postgresql" {
  name    = "allow-postgresql"
  network = google_compute_network.vpc_network2.self_link

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Grant the replica user permission to connect to the primary DB
resource "google_compute_firewall" "primary_db_replica_access" {
  name        = "primary-db-replica-access"
  network     = google_compute_network.vpc_network2.self_link
  source_tags = ["standby-db"]
  target_tags = ["primary-db"]
  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
}

resource "google_compute_firewall" "primary_db_firewall" {
  name    = "primary-db-firewall"
  network = google_compute_network.vpc_network2.self_link

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_tags = ["primary-db"]
}
