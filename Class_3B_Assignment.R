# Bioconductor provides R packages for analyzing omics data (genomics, transcriptomics, proteomics etc).

if (!requireNamespace("BiocManager", quietly = TRUE)) 
  install.packages("BiocManager")

# Install Bioconductor packages
BiocManager::install(c("GEOquery","affy","arrayQualityMetrics"))

# Install CRAN packages for data manipulation
install.packages("dplyr")

# Load Required Libraries
library(GEOquery)             # Download GEO datasets (series matrix, raw CEL files)
library(affy)                 # Pre-processing of Affymetrix microarray data (RMA normalization)
library(arrayQualityMetrics)  # QC reports for microarray data
library(dplyr)                # Data manipulation


raw_data <- ReadAffy(celfile.path = "C:/Users/iarif/Downloads/AI_Omics_Internship_2025/Class_3B_Assignment/Raw_Data/GSE19804_RAW_1")


arrayQualityMetrics(expressionset = raw_data,
                    outdir = "Results/QC_Before",
                    force = TRUE,
                    do.logtransform = TRUE)

normalized_data <- rma(raw_data)

arrayQualityMetrics(expressionset = normalized_data,
                    outdir = "Results/QC_After",
                    force = TRUE)

exprs_matrix <- exprs(normalized_data)
nrow(exprs_matrix)
row_median <- apply(exprs_matrix, 1, median)
filtered_matrix <- exprs_matrix[row_median > 3.5, ]

cat("Remaining transcripts after filtering:", nrow(filtered_matrix), "\n")

gse <- getGEO(filename = "C:/Users/iarif/Downloads/AI_Omics_Internship_2025/Class_3B_Assignment/Raw_Data/GSE19804_series_matrix.txt/GSE19804_series_matrix.txt")
phenotype_data <- pData(gse)
# sample names from normalized data
used_samples <- sampleNames(normalized_data)

# Subset phenotype data to match
phenotype_data <- phenotype_data[used_samples, ]


phenotype_data$Group <- ifelse(grepl("normal", phenotype_data$title, ignore.case = TRUE),
                               "Normal", "Cancer")

table(phenotype_data$Group)

write.csv(filtered_matrix, "filtered_expression_matrix.csv")
write.csv(phenotype_data, "phenotype_labels.csv")
