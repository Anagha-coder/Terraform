variable "gcp_svc_key" {
  
}

variable "gcp_project" {
  
}

variable "gcp_region" {
  
}

variable "service_account_email" {
  
}

variable "function_name" {
  description = "The name of the cloud function"
  type        = string
}

variable "entry_point" {
  description = "The entry point for the cloud function"
  type        = string
}

variable "source_directory" {
  description = "The source directory for the cloud function code"
  type        = string
}


variable "bucket_name" {
  description = "The name of the storage bucket"
  type        = string
}



