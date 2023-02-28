variable "project_id" {
  description = "Google Cloud Platform project ID."
  default = "dbre-home-assignment"
}

variable "region" {
  description = "Google Cloud Platform region."
  default     = "us-central1"
}

variable "zone" {
  description = "Google Cloud Platform zone."
  default     = "us-central1-a"
}

# variable "db_password" {
#   description = "Password for the primary and standby databases."
#   default = "password"
# }

variable "backup_bucket_name" {
  description = "Name of the backup bucket."
  default = "dbre-assignment-bucket-plswork"
}

# variable "pgbench_scale" {
#   description = "The scale factor to use for pgbench."
#   default     = 10
# }

variable "replication_password" {
  description = "Password for replication DB"  
  #default = "password"
}

variable "postgres_user" {
  description = "Enter your desired Username for the PostgreSQL database to be created"
  default = "ultim8beatz"
}

variable "postgres_password" {
  description = "Enter your desired Password for PostgreSQL database to be created"
  #default = "password"
}

variable "Service_id" {
  description = "service email address of your project"
  default = "dbre-home-assignment@dbre-home-assignment.iam.gserviceaccount.com"
}
