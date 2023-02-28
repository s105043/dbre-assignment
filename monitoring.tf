resource "google_monitoring_alert_policy" "primary_db_alert_policy" {
  display_name = "Primary DB CPU and Disk Usage"
  combiner     = "OR"
  conditions {
    display_name = "High Disk Usage"
    condition_threshold {
      filter     = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\" AND resource.label.\"instance_id\"=\"${google_compute_instance.primary_db.id}\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 5
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

    conditions {
    display_name = "High CPU Usage"
    condition_threshold {
      filter            = "metric.type=\"compute.googleapis.com/instance/cpu/usage_time\" AND resource.type=\"gce_instance\" AND resource.label.\"instance_id\"=\"${google_compute_instance.primary_db.id}\""
      duration          = "60s"
      comparison        = "COMPARISON_GT"
      threshold_value = 5
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  enabled = true
}




