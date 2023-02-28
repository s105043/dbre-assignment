# Deploy standby PostgreSQL instance
resource "google_compute_instance" "standby_db" {
  name         = "standby-db"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet.self_link

    access_config {
      // Include a public IP for external access
    }
  }

metadata = {
    # Install PostgreSQL and configure streaming replication
    startup-script = <<-SCRIPT
    #!/bin/bash

sudo apt-get install -y wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'

# Import PostgreSQL repository GPG key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7FCC7D46ACCC4CF8

# Update system packages
sudo apt-get update -y

sudo apt-get install -y postgresql-14 google-cloud-sdk cron
sudo updatedb

sudo sed -i "s/#wal_level = replica/wal_level = replica/" /etc/postgresql/14/main/postgresql.conf
sudo sed -i "s/#max_wal_senders = 10/max_wal_senders = 5/" /etc/postgresql/14/main/postgresql.conf
sudo sed -i "s/#wal_keep_segments = 0/wal_keep_segments = 32/" /etc/postgresql/14/main/postgresql.conf
sudo systemctl restart postgresql

sudo -u postgres psql -c "CREATE ROLE replica LOGIN REPLICATION PASSWORD '${var.replication_password}'"
sudo -u postgres pg_basebackup -h ${google_compute_instance.primary_db.network_interface[0].network_ip} -D /var/lib/postgresql/14/main/ -U replica -v -P
# Create the user for cron
sudo useradd -m pg_dumpall
# Set up daily cron job to create backup and upload to GCS
sudo sh -c 'echo "0 0 * * * pg_dumpall | gzip > /tmp/backup.sql.gz && gsutil cp /tmp/backup.sql.gz gs://dbre-assignment-bucket-plswork/$(date +\%Y-\%m-\%d)/backup.sql.gz" >> /etc/crontab'
sudo chmod -R 0700 /var/lib/postgresql/14/main/
sudo systemctl start postgresql
sudo systemctl restart cron
SCRIPT
  }




  # Use the same availability zone as the primary DB instance
  zone = google_compute_instance.primary_db.zone

}