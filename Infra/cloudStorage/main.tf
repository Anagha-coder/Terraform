# Bucket to store cloud functions
resource "google_storage_bucket" "bucket" {
    name = "cloud-function-bucket-by-anagha"
    location = "US"
    uniform_bucket_level_access = true
  
}

resource "google_storage_bucket" "swagBucket" {
  name = "swagger-bucket-by-anagha"
  location = var.gcp_region
  uniform_bucket_level_access = true
  
}

resource "google_storage_bucket_object" "swagdocs" {
  name = "swagdocs.zip"
  bucket = google_storage_bucket.swagBucket.name
  source = data.archive_file.dist_zip.output_path
  
}

data "archive_file" "dist_zip" {
  type        = "zip"
  output_path = "../output/dist.zip"
  source_dir  = "../handlers/dist"
}

# firestore database
# resource "google_firestore_database" "database" {
#   project                 = "terraform-408108"
#   name                    = "(default)"
#   location_id             = "nam5"
#   type                    = "FIRESTORE_NATIVE"
  
# }