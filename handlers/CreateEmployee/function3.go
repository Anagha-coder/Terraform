package function3

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"

	"example.com/task3gcp/models"
	"example.com/task3gcp/utils"
	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
	"github.com/go-playground/validator"
	"google.golang.org/api/iterator"
)

func init() {
	functions.HTTP("CreateEmployeeHandler", CreateEmployeeHandler)
}

var validate = validator.New()

// CreateEmployeeHandler creates a new employee.
// @Summary Create a new employee
// @Description Create a new employee
// @Accept json
// @Produce json
// @Param employee body Employee true "Employee object to be created"
// @Success 201 {object} map[string]string "Employee created successfully"
// @Failure 400 "Invalid request payload"
// @Failure 500 "Internal Server Error"
// @Router /createEmployee [post]
func CreateEmployeeHandler(w http.ResponseWriter, r *http.Request) {
	utils.InitLogger()

	// Handle CORS preflight request
	if r.Method == http.MethodOptions {
		// Set CORS headers for preflight requests
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		w.WriteHeader(http.StatusOK)
		return
	}

	// Log the request body
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Println("Failed to read request body:", err)
	}
	log.Println("Request Body:", string(body))
	log.Print("Decode started:")

	var employee models.Employee
	if err := json.Unmarshal(body, &employee); err != nil {
		log.Println("Failed to unmarshal JSON:", err)
		respondWithError(w, http.StatusBadRequest, "Invalid JSON payload")
		return
	}

	defer r.Body.Close()

	// Create a Firestore client
	client, err := utils.CreateFirestoreClient()
	if err != nil {
		log.Print("Failed to create Firestore client:", err)
		respondWithError(w, http.StatusInternalServerError, "Failed to create Firestore client")
		return
	}
	defer client.Close()

	log.Print("Firestore client created")

	// Read existing employees from Firestore (assuming you have a collection named "employees")
	iter := client.Collection("employees").Documents(context.Background())
	var existingEmployees []models.Employee
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Print("Failed to read employee data from Firestore:", err)
			respondWithError(w, http.StatusInternalServerError, "Failed to read employee data from Firestore")
			return
		}
		var emp models.Employee
		if err := doc.DataTo(&emp); err != nil {
			log.Print("Failed to parse employee data from Firestore:", err)
			respondWithError(w, http.StatusInternalServerError, "Failed to parse employee data from Firestore")
			return
		}
		existingEmployees = append(existingEmployees, emp)
	}

	log.Print("Existing employees read from Firestore")

	// Generate a unique ID for the new employee
	newEmployeeID := generateUniqueEmployeeID(existingEmployees)

	// Set the new employee ID
	employee.ID = newEmployeeID

	// Add the new employee to Firestore
	_, _, err = client.Collection("employees").Add(context.Background(), employee)

	if err != nil {
		log.Print("Failed to create employee in Firestore:", err)
		respondWithError(w, http.StatusInternalServerError, "Failed to create employee in Firestore")
		return
	}

	log.Print("Employee created successfully in Firestore")

	respondWithJSON(w, http.StatusCreated, map[string]string{"message": "Employee created successfully"})
	log.Print("Response Sent: CreateEmployeeHandler")
}

func generateUniqueEmployeeID(existingEmployees []models.Employee) int {
	highestID := 0

	// Find the highest existing ID from the Firestore data
	for _, employee := range existingEmployees {
		if employee.ID > highestID {
			highestID = employee.ID
		}
	}

	// Increment the highest existing ID to generate a new unique ID
	return highestID + 1
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

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write(response)
}
