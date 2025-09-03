# Defining the classification function
classify_gene <- function(logFC, padj) {
  if (is.na(padj)) padj <- 1
  
  if (logFC > 1 & padj < 0.05) {
    return("Upregulated")
  } else if (logFC < -1 & padj < 0.05) {
    return("Downregulated")
  } else {
    return("Not_Significant")
  }
}

# Defining input and output directories
input_dir <- "Raw_Data"
output_dir <- "Results"

# Creating output folder if it doesn't exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Listing of files to process
files_to_process <- c("DEGs_Data_1.csv", "DEGs_Data_2.csv")

# Looping through each file
for (file_name in files_to_process) {
  cat("\nProcessing:", file_name, "\n")
  
  # Building full path and read data
  input_path <- file.path(input_dir, file_name)
  data <- read.csv(input_path, header = TRUE)
  
  # Replacing missing padj values with 1
  if ("padj"  %in% names(data)) {
    data$padj[is.na(data$padj)] <- 1
  }
  
  # starting the empty status column
  data$status <- NA
  
  # Applying classification function row by row
  for (i in 1:nrow(data)) {
    data$status[i] <- classify_gene(data$logFC[i], data$padj[i])
  }
  
  # Saving processed data
  output_path <- file.path(output_dir, paste0("Processed_", file_name))
  write.csv(data, output_path, row.names = FALSE)
  cat("Saved to:", output_path, "\n")
  
  # Printing summary counts
  cat("Summary for", file_name, ":\n")
}
