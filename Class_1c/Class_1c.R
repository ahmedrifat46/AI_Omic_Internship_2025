# Practice Exercises 
# 1. Check Cholesterol level
cholesterol <- 230

if (cholesterol > 240){
  print("High Cholesterol")
}

# 2. Blood Pressure Status 
Systolic_bp <- 130

if (Systolic_bp < 120){
  print("Blood Pressure is normal")
}else{
  print("Blood Pressure is high")
}


# 3. Automating Data Type Conversion with for loop
patient_data <- read.csv(file.choose())
original_patient_data <- patient_data
metadata <- read.csv(file.choose())
original_metadata <- metadata
str(patient_data)
str(metadata)

factor_cols <- c("gender", "diagnosis", "smoker", "height")

for (col in factor_cols){
  if  (col %in% names(patient_data)){
    patient_data[[col]] <- as.factor(patient_data[[col]])
  }
  if (col %in% names(metadata)) {
    metadata[[col]] <- as.factor(metadata[[col]])
  }
}

# 4. Converting Factors to Numeric Codes
binary_cols <- c("smoker")
for (col in binary_cols) {
  patient_data[[col]] <- ifelse(patient_data[[col]] == "Yes", 1, 0)
}

str(original_patient_data)
str(patient_data)
str(original_metadata)
str(metadata)
