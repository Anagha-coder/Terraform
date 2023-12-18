package function5

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"strings"

	"example.com/task3gcp/utils"
	"github.com/GoogleCloudPlatform/functions-framework-go/functions"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func init() {
	functions.HTTP("DeleteEmployeeHandler", DeleteEmployeeHandler)
}

// DeleteEmployeeHandler deletes an existing employee by ID.
// @Summary Delete an existing employee
// @Description Delete an existing employee by ID
// @Accept json
// @Produce json
// @Param id path number true "Employee ID to be deleted"
// @Success 200 {object} map[string]string "Employee deleted successfully"
// @Failure 400 "Invalid employee ID"
// @Failure 404 "Employee not found"
// @Failure 500 "Internal Server Error"
// @Router /deleteEmployee/{id} [delete]
func DeleteEmployeeHandler(w http.ResponseWriter, r *http.Request) {
	utils.InitLogger()

	// Handle CORS preflight request
	if r.Method == http.MethodOptions {
		// Set CORS headers for preflight requests
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		w.WriteHeader(http.StatusOK)
		return
	}

	log.Print("Request is being Processed for DeleteEmployeeHandler")

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

	log.Print("Request received: DeleteEmployee, ID:", id)

	client, err := utils.CreateFirestoreClient()
	if err != nil {
		log.Print("Failed to create Firestore client:", err)
		respondWithError(w, http.StatusInternalServerError, "Failed to create Firestore client")
		return
	}
	defer client.Close()

	log.Print("Request received: DeleteEmployeeHandler")

	// Define a query to retrieve the document with the specified "ID" field value
	query := client.Collection("employees").Where("ID", "==", id).Limit(1)

	// Run the query
	iter := query.Documents(context.Background())
	doc, err := iter.Next()

	if err != nil {
		log.Print("Failed to retrieve employee from Firestore:", err)
		if status.Code(err) == codes.NotFound {
			// Employee not found, return an error response
			respondWithError(w, http.StatusNotFound, "Employee not found")
		} else {
			// Handle other errors
			respondWithError(w, http.StatusInternalServerError, "Employee not found. Check requested ID")
		}
		return
	}

	_, err = doc.Ref.Delete(context.Background())
	if err != nil {
		log.Print("Failed to delete employee from Firestore:", err)
		respondWithError(w, http.StatusInternalServerError, "Failed to delete employee from Firestore")
		return
	}

	log.Print("Employee deleted successfully")
	respondWithJSON(w, http.StatusOK, map[string]string{"message": "Employee deleted successfully"})
	log.Print("Response Sent")
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
