# Employee Management System | Deploying GCP services using Terraform

## Infrastructure as Code (IaC):

Infrastructure as Code (IaC) is a methodology that treats infrastructure provisioning and management as code. With IaC, infrastructure components, such as servers, networks, and databases, are defined and managed using code rather than manual processes. This approach enhances automation, scalability, and consistency in deploying and managing infrastructure.

## Continuous Integration and Continuous Deployment (CI/CD):

Continuous Integration (CI) and Continuous Deployment (CD) are practices in software development that aim to automate and streamline the process of building, testing, and deploying code changes.

   - Continuous Integration (CI): Involves regularly integrating code changes into a shared repository. Automated builds and tests are triggered with each integration, ensuring early detection of integration issues.

   - Continuous Deployment (CD): Extends CI by automatically deploying code changes to production or staging environments after passing the CI pipeline. This enables faster and more reliable releases.
## Modules

- [Cloud Storage](https://github.com/tasdikrahman/terraform-gcp-examples/tree/master/gcs-bucket/)
- [Cloud Functions](https://github.com/tasdikrahman/terraform-gcp-examples/tree/master/single-and-multi-node-compute-vm)


### Setup

Don't forget to place the file `service_acc_key.json` inside the `credentials` dir in the root directory before running which would contain your service Account Key file.

This contains your authentication required for Terraform to talk to the Google API.

You can get it under 

`Google Cloud Platform -> IAM -> Service Accounts -> Create Service Account -> Create Service account key.`

For the Key type field chose JSON. Put the downloaded file right were your Terraform config file is and name it `service_acc_key.json`.

If you are using the gcs as the backend, you will need to give it the `Storage Admin` role for the `storage.buckets.create` permission.

