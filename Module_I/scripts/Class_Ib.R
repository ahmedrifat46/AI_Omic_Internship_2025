#opening different files
dir.create("raw_data")
dir.create("clean_data")
dir.create("scripts")
dir.create("results")
dir.create("plots")

#reading the provided .csv file
patient_data <- read.csv(file.choose())

#inspecting the structure of the dataset
str(patient_data)

#converting character type variables into factors and cleaning the previous one
patient_data$gender <- as.factor(patient_data$gender)
patient_data$diagnosis <- as.factor(patient_data$diagnosis)

#checking current status of those variables
class(patient_data$gender)
class(patient_data$diagnosis)

#creating new variable for smoking status as binary factor
patient_data$smoker_bin_factor <- factor(ifelse(patient_data$smoker == "Yes", 1, 0))
class(patient_data$smoker_bin_factor)

#saving cleaned data
write.csv(patient_data, file = "clean_data/patient_info_clean.csv", row.names = FALSE)
