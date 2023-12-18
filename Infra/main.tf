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
  source_dir  = "../handlers/swaggerDoc"
}

# firestore database
# resource "google_firestore_database" "database" {
#   project                 = "terraform-408108"
#   name                    = "(default)"
#   location_id             = "nam5"
#   type                    = "FIRESTORE_NATIVE"
  
# }

# Cloud functions

resource "google_storage_bucket_object" "object" {
  name = "getAllEmp.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.getAllEmp_zip.output_path
}

data "archive_file" "getAllEmp_zip" {
  type        = "zip"
  output_path = "../output/getAllEmp.zip"
  source_dir  = "../handlers/GetAllEmployees"
}

# module "getAll" {
#   source = "./cloudFunction"
#   funcName="getAllEmployees"
#   gcp_region = var.gcp_region
#   entry_point= "GetAllEmployees"
  
# }

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
    service_account_email = var.service_account_email
  }
  
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloudfunctions2_function.getAllEmp.location
  service  = "getallemployees"
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# cf2
resource "google_storage_bucket_object" "object2" {
  name = "allEmpByID.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.allEmpByID_zip.output_path
}

data "archive_file" "allEmpByID_zip" {
  type        = "zip"
  output_path = "../output/allEmpByID.zip"
  source_dir  = "../handlers/GetEmployeeByID"
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
    service_account_email = var.service_account_email
    
    
  }  
}

resource "google_cloud_run_service_iam_member" "member2" {
  location = google_cloudfunctions2_function.allEmpByID.location
  service  = "allemployeesbyid"
  role     = "roles/run.invoker"
  member   = "allUsers"
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
  source_dir  = "../handlers/CreateEmployee"
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
    service_account_email = var.service_account_email
    
  }
  
}

resource "google_cloud_run_service_iam_member" "member3" {
  location = google_cloudfunctions2_function.createEmp.location
  service  = "createemployee"
  role     = "roles/run.invoker"
  member   = "allUsers"
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
  source_dir  = "../handlers/UpdateEmployee"
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
    service_account_email = var.service_account_email
    
  }
  
}

resource "google_cloud_run_service_iam_member" "member4" {
  location = google_cloudfunctions2_function.updateEmp.location
  service  = "updateemployee"
  role     = "roles/run.invoker"
  member   = "allUsers"
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
  source_dir  = "../handlers/DeleteEmp"
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
    service_account_email = var.service_account_email
    
  }
  
}

resource "google_cloud_run_service_iam_member" "member5" {
  location = google_cloudfunctions2_function.deleteEmp.location
  service  = "deleteemployee"
  role     = "roles/run.invoker"
  member   = "allUsers"
}


