resource "google_storage_bucket" "backup_bucket" {
  name = var.backup_bucket_name
  location = var.region
  lifecycle_rule {
    condition {
      age = 15
    }
    action {
      type = "Delete"
    }
  }
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${var.Service_id}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket = google_storage_bucket.backup_bucket.name
  policy_data = data.google_iam_policy.admin.policy_data
}