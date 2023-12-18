# Cloud Functions Module

This Terraform module facilitates the deployment of a Google Cloud Function and its associated resources. The function is packaged as a ZIP archive and stored in a Google Cloud Storage bucket. Additionally, it grants permission to invoke the function to all users through Google Cloud Run.

## Prerequisites

Before using this module, ensure that you have the following prerequisites:

- Google Cloud Platform (GCP) account and project.
- Terraform installed on your local machine.


## Usage

```
module "getAllEmp" {
  source                  = "./cloud_functions"
  function_name           = "GetAllEmployees"
  entry_point             = "GetAllEmployees"
  source_directory        = "../handlers/GetAllEmployees"
  gcp_region              = var.gcp_region
  bucket_name             = var.bucket_name
  service_account_email   = var.service_account_email
}

```

## Module Inputs

- function_name: Name of the Google Cloud Function.
- entry_point: Entry point for the function code.
- source_directory: Path to the directory containing the function code.
- gcp_region: Google Cloud Platform region where the function will be deployed.
- bucket_name: Name of the Google Cloud Storage bucket to store the function code.
- service_account_email: Email address associated with the service account used for the function.


## Resources Created

### Cloud Storage Object:

    Name: ${var.function_name}.zip
    Bucket: var.bucket_name
    Source: The output path of the ZIP archive created from the var.source_directory.


### Archive File Data Source:

    Type: zip
    Output Path: ../output/${var.function_name}.zip
    Source Directory: var.source_directory


### Cloud Function:

    Name: var.function_name
    Location: var.gcp_region
    Description: Cloud function: ${var.function_name}
    Runtime: go121
    Entry Point: var.entry_point
    Source: Referencing the Cloud Storage object created.
    Cloud Run Service IAM Member:

    Location: Derived from the Cloud Function location
    Service: var.function_name
    Role: roles/run.invoker
    Member: allUsers


## Note

Ensure that you have the necessary permissions and authentication for your GCP account to create and manage storage resources.    