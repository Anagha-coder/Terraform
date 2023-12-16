
output "function_uri1" { 
  value = google_cloudfunctions2_function.getAllEmp.service_config[0].uri
}

output "function_uri2" { 
  value = google_cloudfunctions2_function.allEmpByID.service_config[0].uri
}

output "function_uri3" { 
  value = google_cloudfunctions2_function.createEmp.service_config[0].uri
}

output "function_uri4" { 
  value = google_cloudfunctions2_function.updateEmp.service_config[0].uri
}

output "function_uri5" { 
  value = google_cloudfunctions2_function.deleteEmp.service_config[0].uri
}