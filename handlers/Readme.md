# Cloud Functions

Google Cloud Functions serve as a platform for deploying serverless functions designed to respond to HTTP events. These functions act as the backend logic for the API, managing diverse requests and engaging with Firestore to perform data operations.


## Features

The designated cloud function within the directory performs the following tasks

- Employee Management: Facilitates the creation, retrieval, updating, and deletion of employee records.

- Serverless Architecture: Utilizes Google Cloud Functions for efficient and scalable deployment in a serverless environment.

- Interactive API Documentation: Offers extensive Swagger documentation for all API endpoints to enhance user interaction and understanding.

- Seamless Integration with Google Cloud Firestore: Ensures smooth integration with Google Cloud Firestore for the storage and efficient management of employee data through Firestore collections.


## Code Structure 

All the functions outlined below adhere to a consistent code structure:

- Go Function File: Houses the logic for the respective function, ensuring modular and organized code.

- go.mod File: Includes dependencies required for the project.

- Directories

  - models: Encompasses a structure for storing employee information.

  - utils: Incorporates functionalities for logging and establishing connections with the Firestore client.





## Documentation

- Cloud Functions [Basics Of Cloud Functions](https://cloud.google.com/functions#)
     - Deploy individual Cloud Functions for each API endpoint.

- [Configure Security Rules for Firestore](https://cloud.google.com/firestore/docs/security/get-started)

- Deploy Swagger UI on a web server to provide interactive API documentation. [Swagger Static Files](https://swagger.io/docs/open-source-tools/swagger-ui/usage/installation/) 

### Security Considerations

- Ensure that appropriate IAM roles and permissions are set for Cloud Functions to access Firestore.

- Configure Cross-Origin Resource Sharing (CORS) for each cloud function.