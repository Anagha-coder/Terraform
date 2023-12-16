
output "GetAllEmployees" { 
  value = google_cloudfunctions2_function.getAllEmp.service_config[0].uri
}

output "GetAllEmployeesByID" { 
  value = google_cloudfunctions2_function.allEmpByID.service_config[0].uri
}

output "CreateEmployee" { 
  value = google_cloudfunctions2_function.createEmp.service_config[0].uri
}

output "UpdateEmployee" { 
  value = google_cloudfunctions2_function.updateEmp.service_config[0].uri
}

output "DeleteEmployee" { 
  value = google_cloudfunctions2_function.deleteEmp.service_config[0].uri
}