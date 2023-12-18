
# Cloud Storage Module

This Terraform module, named "cloud storage," facilitates the provisioning of Google Cloud Storage resources for managing and storing various artifacts within a Google Cloud Platform (GCP) project.

## Prerequisites

Before using this module, ensure that you have the following prerequisites:

- Google Cloud Platform (GCP) account and project.
- Terraform installed on your local machine.


## Resources Created

### Storage Buckets

- Function Bucket:

     - Name: cloud-function-bucket-by-anagha
     - Location: US
     - Uniform Bucket Level Access: true


- Swagger Bucket:

    - Name: swagger-bucket-by-anagha
    - Location: Specified by the variable var.gcp_region
    - Uniform Bucket Level Access: true



### Usage

```
module "cloud_storage" {
  source = "path/to/cloud_storage"
  # Customize variables if needed
  # e.g., var.gcp_region = "us-central1"
}

```
## Note

Ensure that you have the necessary permissions and authentication for your GCP account to create and manage storage resources.


### Important!
Uncomment and customize the google_firestore_database resource if you also want to set up a Firestore database.


