Automated Provisioning and Configuration of PostgreSQL on Google Cloud Platform

This project describes an automated way to provision and configure PostgreSQL on Google Cloud Platform using Terraform. The setup includes a primary database instance running on PostgreSQL 14 and a standby database instance that replicates the primary database. Additionally, I create a cloud storage bucket to hold daily backups, and I implement monitoring alerts on Google Cloud Monitoring.

Prerequisites

Before starting this project, you need to have the following:

A Google Cloud Platform account
Terraform installed
A Google Cloud Platform project with billing enabled
A service account with the necessary roles and permissions
Architecture

The architecture of this project includes the following components:

Primary Database: A PostgreSQL compute engine instance running on PostgreSQL 14 that serves as the primary (master) server. It is initialized with pgbench schema.
Standby Database: A PostgreSQL compute engine instance that replicates the primary database. It has a daily cron that generates a backup and uploads it to Cloud Storage.
Cloud Storage: A Cloud Storage bucket that contains daily backups. The retention period is 15 days (after that, backups are automatically deleted).
Monitoring: The following alerts are implemented on Google Cloud Monitoring.
When CPU Usage > 90% on Primary Database.
When Disk Usage > 85% on Primary Database.
Getting Started

Clone the repository to your local machine.
Create a service account and download the JSON file containing the credentials.
Create a Google Cloud Storage bucket to hold the backups.
Edit the variables.tf file with your project and region,db username, bucket name and service email details.
Also input your desired passwords for the primary and standby db upon provisioning (terraform apply)
Edit the credentials.json file with the contents of the JSON file containing the service account credentials.
Run terraform init to initialize the Terraform environment.
Run terraform apply to provision the resources.
After provisioning, connect to the primary and standby databases and verify that replication is working.
Verify that the daily backups are being uploaded to the Cloud Storage bucket.
Check the Google Cloud Monitoring alerts to verify that they are working correctly.
Conclusion

This project provides an automated way to provision and configure PostgreSQL on Google Cloud Platform using Terraform. The setup includes a primary database instance running on PostgreSQL 14 and a standby database instance that replicates the primary database. Additionally, we create a cloud storage bucket to hold daily backups, and we implement monitoring alerts on Google Cloud Monitoring.


Why I choose Terraform for the task
 Using Terraform to deploy a PostgreSQL instance in GCP can save time, reduce errors, improve consistency, and make it easier to manage your infrastructure over time.
