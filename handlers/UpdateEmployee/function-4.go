package function4

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"strings"

	"example.com/task3gcp/models"
	"example.com/task3gcp/utils"

	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
	"github.com/go-playground/validator/v10"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

var validate = validator.New()

func init() {
	functions.HTTP("UpdateEmployeeHandler", UpdateEmployeeHandler)
}

// UpdateEmployeeHandler updates an existing employee by ID.
// @Summary Update an existing employee
// @Description Update an existing employee by ID
// @Accept json
// @Produce json
// @Param id path number true "Employee ID to be updated"
// @Param employee body Employee true "Updated employee object"
// @Success 200 {object} map[string]string "Employee updated successfully"
// @Failure 400 "Invalid employee ID"
// @Failure 400 "Invalid request payload"
// @Failure 404 "Employee not found"
// @Failure 500 "Internal Server Error"
// @Router /updateEmployee/{id} [put]
func UpdateEmployeeHandler(w http.ResponseWriter, r *http.Request) {
	utils.InitLogger()

	// Handle CORS preflight request
	if r.Method == http.MethodOptions {
		// Set CORS headers for preflight requests
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "PUT, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		w.WriteHeader(http.StatusOK)
		return
	}
	log.Print("Request is being Processed for UpdateEmployeeHandler")

	uri := r.RequestURI

	// Split the URI using '/'
	parts := strings.Split(uri, "/")

	// Check if the URI has at least 4 parts and the last part is a valid integer
	if len(parts) < 2 {
		log.Print("Invalid URI format")
		respondWithError(w, http.StatusBadRequest, "Invalid URI format")
		return
	}

	// Extract the last part of the URL as the employee ID
	id, err := strconv.Atoi(parts[len(parts)-1])
	if err != nil {
		log.Print("Invalid employee ID:", err)
		respondWithError(w, http.StatusBadRequest, "Invalid employee ID")
		return
	}

	log.Print("Request received: UpdateEmployeeID:", id)

	// Log the request body
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Println("Failed to read request body:", err)
	}
	log.Println("Request Body:", string(body))
	log.Print("Decode started:")

	var updatedEmployee models.Employee
	if err := json.Unmarshal(body, &updatedEmployee); err != nil {
		log.Println("Failed to unmarshal JSON:", err)
		respondWithError(w, http.StatusBadRequest, "Invalid JSON payload")
		return
	}

	defer r.Body.Close()

	log.Print("Request payload decoded")

	// Validate input data
	if err := validate.Struct(updatedEmployee); err != nil {
		log.Print("Validation error:", err)
		respondWithError(w, http.StatusBadRequest, err.Error())
		return
	}

	log.Print("Input data validated")

	client, err := utils.CreateFirestoreClient()
	if err != nil {
		log.Print("Failed to create Firestore client:", err)
		respondWithError(w, http.StatusInternalServerError, "Failed to create Firestore client")
		return
	}
	defer client.Close()

	log.Print("Firestore client created")

	// Define a query to retrieve the document with the specified "ID" field value
	query := client.Collection("employees").Where("ID", "==", id).Limit(1)

	// Run the query
	iter := query.Documents(context.Background())
	doc, err := iter.Next()

	if err != nil {
		if status.Code(err) == codes.NotFound {
			log.Print("Employee not found:", err)
			respondWithError(w, http.StatusNotFound, "Employee not found")
			return
		}
		log.Print("Failed to retrieve employee from Firestore:", err)
		respondWithError(w, http.StatusInternalServerError, "Failed to retrieve employee from Firestore. Check requested ID, Employee not Found")
		return
	}

	log.Print("Employee retrieved from Firestore")

	// Exclude ID field from the updated data
	updatedEmployee.ID = id

	_, err = doc.Ref.Set(context.Background(), updatedEmployee)
	if err != nil {
		log.Print("Failed to update employee in Firestore:", err)
		respondWithError(w, http.StatusInternalServerError, "Failed to update employee in Firestore")
		return
	}

	log.Print("Employee updated successfully in Firestore")

	respondWithJSON(w, http.StatusOK, updatedEmployee)
	log.Print("Response Sent: UpdateEmployeeHandler")
}

func respondWithError(w http.ResponseWriter, code int, message string) {
	respondWithJSON(w, code, map[string]string{"error": message})
}

func respondWithJSON(w http.ResponseWriter, code int, payload interface{}) {
	response, err := json.Marshal(payload)
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Set CORS headers to allow requests from any origin
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write(response)
}
