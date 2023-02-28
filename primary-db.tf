resource "google_compute_instance" "primary_db" {
  name         = "primary-db"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
allow_stopping_for_update = true

  network_interface {
    network = google_compute_network.vpc_network2.self_link

    access_config {
      // Ephemeral IP
    }
  }

metadata_startup_script = <<-SCRIPT
#!/bin/bash

# Install wget, gnupg, and ufw
sudo apt-get update
sudo apt-get install wget gnupg ufw -y

# Add PostgreSQL repository to system
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Import PostgreSQL repository GPG key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7FCC7D46ACCC4CF8

# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install PostgreSQL 14
sudo apt-get install postgresql-14 -y

# Initialize PostgreSQL with pgbench schema
sudo -u postgres pg_ctlcluster 14 main start
sudo -u postgres createdb pgbench
sudo -u postgres pgbench -i pgbench

# Create a role and grant access
sudo -u postgres psql -c "CREATE ROLE ${var.postgres_user} WITH LOGIN PASSWORD '${var.postgres_password}';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE pgbench TO ${var.postgres_user};"


# Open firewall port for PostgreSQL
sudo ufw allow 5432/tcp

# Allow remote connections (optional)
# Replace "0.0.0.0/0" with your preferred IP range or specific IP address
echo "host all all 0.0.0.0/0 trust" | sudo tee -a /etc/postgresql/14/main/pg_hba.conf
echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/14/main/postgresql.conf

# Restart PostgreSQL for changes to take effect
sudo systemctl restart postgresql

# Print message indicating installation is complete
echo "PostgreSQL 14 has been installed and initialized with pgbench schema."
SCRIPT

  lifecycle {
    ignore_changes = [
      metadata_startup_script,
    ]
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.Service_id
    scopes = ["cloud-platform"]
  }
}


resource "google_compute_instance_iam_binding" "binding" {
  project = google_compute_instance.primary_db.project
  zone = google_compute_instance.primary_db.zone
  instance_name = google_compute_instance.primary_db.name
  role = "roles/compute.osLogin"
  members = [
    "serviceAccount:${var.Service_id}",
  ]
}