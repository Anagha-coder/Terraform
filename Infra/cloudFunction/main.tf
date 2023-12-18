resource "google_storage_bucket_object" "object" {
  name   = "${var.function_name}.zip"
  bucket = var.bucket_name
  source = data.archive_file.function_zip.output_path
}

data "archive_file" "function_zip" {
  type       = "zip"
  output_path = "../output/${var.function_name}.zip"
  source_dir  = var.source_directory
}

resource "google_cloudfunctions2_function" "function" {
  name        = var.function_name
  location    = var.gcp_region
  description = "Cloud function: ${var.function_name}"

  build_config {
    runtime     = "go121"
    entry_point = var.entry_point

    source {
      storage_source {
        bucket = var.bucket_name
        object = google_storage_bucket_object.object.name 
        // different object names are required 
      }
    }
  }

  service_config {
    max_instance_count     = 1
    available_memory       = "256M"
    timeout_seconds        = 60
    service_account_email = var.service_account_email
    
  }
}
// will this reference "member" create a object duplication 
resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloudfunctions2_function.function.location
  service  = var.function_name // different service name for each func
  role     = "roles/run.invoker"
  member   = "allUsers"
}

















