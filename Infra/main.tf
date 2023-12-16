# resource "google_service_account" "account" {
#   account_id   = "task5-Terraform"
#   display_name = "Test Service Account"
# }

# Bucket to store cloud functions
resource "google_storage_bucket" "bucket" {
    name = "cloud-function-bucket-by-anagha"
    location = "US"
    uniform_bucket_level_access = true
  
}

# firestore database
resource "google_firestore_database" "database" {
  project                 = "terraform-408108"
  name                    = "(default)"
  location_id             = "nam5"
  type                    = "FIRESTORE_NATIVE"
  
}

# Cloud functions

resource "google_storage_bucket_object" "object" {
  name = "getAllEmp.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.getAllEmp_zip.output_path
}

data "archive_file" "getAllEmp_zip" {
  type        = "zip"
  output_path = "../output/getAllEmp.zip"
  source_dir  = "../handlers/function1"
}

resource "google_cloudfunctions2_function" "getAllEmp" {
  name = "GetAllEmployees"
  location = var.gcp_region
  description = "Get all employees"

  build_config {
    runtime = "go121"
    entry_point ="GetAllEmployees"

    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name

      }
    }
    
  }

  service_config {
    max_instance_count = 1
    available_memory = "256M"
    timeout_seconds = 60
    service_account_email = "task5-terraform@terraform-408108.iam.gserviceaccount.com"
  }
  
}

output "function_uri1" { 
  value = google_cloudfunctions2_function.getAllEmp.service_config[0].uri
}

# resource "google_cloudfunctions2_function_iam_binding" "allow_unauthenticated1" {
#   cloud_function = google_cloudfunctions2_function.getAllEmp.name
#   location    = google_cloudfunctions2_function.getAllEmp.location
#   role        = "roles/cloudfunctions.invoker"
#   members     = ["allUsers"]
# }

# cf2
resource "google_storage_bucket_object" "object2" {
  name = "allEmpByID.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.allEmpByID_zip.output_path
}

data "archive_file" "allEmpByID_zip" {
  type        = "zip"
  output_path = "../output/allEmpByID.zip"
  source_dir  = "../handlers/function2"
}

resource "google_cloudfunctions2_function" "allEmpByID" {
  name = "allEmployeesByID"
  location = var.gcp_region
  description = "Get all employees by ID"
  

  build_config {
    runtime = "go121"
    entry_point ="GetEmployeeByID"

    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object2.name

      }
    }
    
  }

  service_config {
    max_instance_count = 1
    available_memory = "256M"
    timeout_seconds = 60
    service_account_email = "task5-terraform@terraform-408108.iam.gserviceaccount.com"
    
    
  }  
}


resource "google_cloudfunctions2_function_iam_member" "member" {
  project = var.gcp_project
  cloud_function = google_cloudfunctions2_function.allEmpByID.name
  location = google_cloudfunctions2_function.allEmpByID.location
  role = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

output "function_uri2" { 
  value = google_cloudfunctions2_function.allEmpByID.service_config[0].uri
}

# cf3 
resource "google_storage_bucket_object" "object3" {
  name = "createEmp.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.createEmp_zip.output_path
}

data "archive_file" "createEmp_zip" {
  type        = "zip"
  output_path = "../output/createEmp.zip"
  source_dir  = "../handlers/function3"
}

resource "google_cloudfunctions2_function" "createEmp" {
  name = "createEmployee"
  location = var.gcp_region
  description = "Create new employee"

  build_config {
    runtime = "go121"
    entry_point ="CreateEmployeeHandler"

    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object3.name

      }
    }
    
  }

  service_config {
    max_instance_count = 1
    available_memory = "256M"
    timeout_seconds = 60
    service_account_email = "task5-terraform@terraform-408108.iam.gserviceaccount.com"
    
  }
  
}

output "function_uri3" { 
  value = google_cloudfunctions2_function.createEmp.service_config[0].uri
}


# cf4
resource "google_storage_bucket_object" "object4" {
  name = "updateEmp.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.updateEmp_zip.output_path
}

data "archive_file" "updateEmp_zip" {
  type        = "zip"
  output_path = "../output/updateEmp.zip"
  source_dir  = "../handlers/function4"
}

resource "google_cloudfunctions2_function" "updateEmp" {
  name = "updateEmployee"
  location = var.gcp_region
  description = "Update employee by ID"

  build_config {
    runtime = "go121"
    entry_point ="UpdateEmployeeHandler"

    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object4.name

      }
    }
    
  }

  service_config {
    max_instance_count = 1
    available_memory = "256M"
    timeout_seconds = 60
    service_account_email = "task5-terraform@terraform-408108.iam.gserviceaccount.com"
    
  }
  
}

output "function_uri4" { 
  value = google_cloudfunctions2_function.updateEmp.service_config[0].uri
}


# cf5
resource "google_storage_bucket_object" "object5" {
  name = "deleteEmp.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.deleteEmp_zip.output_path
}

data "archive_file" "deleteEmp_zip" {
  type        = "zip"
  output_path = "../output/deleteEmp.zip"
  source_dir  = "../handlers/function5"
}

resource "google_cloudfunctions2_function" "deleteEmp" {
  name = "deleteEmployee"
  location = var.gcp_region
  description = "Delete employee by ID"

  build_config {
    runtime = "go121"
    entry_point ="DeleteEmployeeHandler"

    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object5.name

      }
    }
    
  }

  service_config {
    max_instance_count = 1
    available_memory = "256M"
    timeout_seconds = 60
    service_account_email = "task5-terraform@terraform-408108.iam.gserviceaccount.com"
    
  }
  
}

output "function_uri5" { 
  value = google_cloudfunctions2_function.deleteEmp.service_config[0].uri
}

