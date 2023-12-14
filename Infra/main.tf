# Bucket to store cloud functions
resource "google_storage_bucket" "bucket" {
    name = "cloud-function-bucket-by-anagha"
    location = "US"
  
}

# firestore database
resource "google_firestore_database" "database" {
  project                 = "terraform-408108"
  name                    = "(default)"
  location_id             = "nam5"
  type                    = "FIRESTORE_NATIVE"
  
}