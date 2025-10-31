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

library(GEOquery)


gse <- getGEO(filename = "C:/Users/iarif/Downloads/GSE19804_series_matrix.txt.gz")
phenotype_data <- pData(gse)
colnames(phenotype_data)
unique(phenotype_data$source_name_ch1)


# sample names from normalized data
used_samples <- sampleNames(normalized_data)

# Subset phenotype data to match
phenotype_data <- phenotype_data[used_samples, ]

phenotype_data$Group <- ifelse(grepl("adjacent normal", phenotype_data$source_name_ch1, ignore.case = TRUE),
                               "Normal", "Cancer")


table(phenotype_data$Group)




write.csv(filtered_matrix, "filtered_expression_matrix.csv")
write.csv(phenotype_data, "phenotype_labels.csv")


BiocManager::install("hgu133plus2.db")


library(AnnotationDbi)
library(hgu133plus2.db)

probe_ids <- rownames(filtered_matrix)
gene_symbols <- mapIds(hgu133plus2.db,
                       keys = probe_ids,
                       keytype = "PROBEID",
                       column = "SYMBOL",
                       multiVals = "first")
library(tibble)
library(dplyr)
library(limma)

filtered_df <- filtered_matrix %>%
  as.data.frame() %>%
  rownames_to_column("PROBEID") %>%
  mutate(SYMBOL = gene_symbols[PROBEID]) %>%
  filter(!is.na(SYMBOL))

expr_only <- filtered_df %>% select(-PROBEID, -SYMBOL)
averaged_data <- limma::avereps(expr_only, ID = filtered_df$SYMBOL)
colnames(averaged_data) <- gsub("\\.CEL\\.gz$", "", colnames(averaged_data))
phenotype_data <- phenotype_data[colnames(averaged_data), ]


groups <- factor(phenotype_data$Group, levels = c("Normal", "Cancer"))
design <- model.matrix(~0 + groups)
colnames(design) <- levels(groups)

fit <- lmFit(averaged_data, design)
contrast_matrix <- makeContrasts(Cancer_vs_Normal = Cancer - Normal, levels = design)
fit2 <- eBayes(contrasts.fit(fit, contrast_matrix))

dir.create("Results")
deg_results <- topTable(fit2, coef = "Cancer_vs_Normal", number = Inf, adjust.method = "BH")
write.csv(deg_results, "Results/DEG_all.csv", row.names = TRUE)

deg_up <- deg_results %>% filter(adj.P.Val < 0.05 & logFC > 1)
write.csv(deg_up, "Results/DEG_upregulated.csv", row.names = TRUE)

deg_down <- deg_results %>% filter(adj.P.Val < 0.05 & logFC < -1)
write.csv(deg_down, "Results/DEG_downregulated.csv", row.names = TRUE)

library(ggplot2)

deg_results$threshold <- as.factor(ifelse(
  deg_results$adj.P.Val < 0.05 & deg_results$logFC > 1, "Upregulated",
  ifelse(deg_results$adj.P.Val < 0.05 & deg_results$logFC < -1, "Downregulated", "No")
))

ggplot(deg_results, aes(x = logFC, y = -log10(adj.P.Val), color = threshold)) +
  geom_point(alpha = 0.6) +
  scale_color_manual(values = c("Upregulated" = "red", "Downregulated" = "blue", "No" = "gray")) +
  theme_minimal() +
  labs(title = "Volcano Plot: Cancer vs Normal", x = "log2 Fold Change", y = "-log10 Adjusted P-Value")

ggsave("Results/volcano_plot.png", width = 8, height = 6)
install.packages("pheatmap")

library(pheatmap)
deg_results$SYMBOL <- gene_symbols[rownames(deg_results)]


head(rownames(averaged_data))

top25 <- deg_results %>%
  filter(adj.P.Val < 0.05 & !is.na(SYMBOL)) %>%
  arrange(desc(abs(logFC))) %>%
  distinct(SYMBOL, .keep_all = TRUE) %>%
  slice_head(n = 25) %>%
  pull(SYMBOL)

valid_genes <- intersect(top25, rownames(averaged_data))
heatmap_data <- averaged_data[valid_genes, ]

pheatmap(heatmap_data,
         scale = "row",
         show_rownames = TRUE,
         filename = "C:/Users/iarif/Downloads/AI_Omics_Internship_2025/Results/heatmap_top25.png")
heatmap_data <- averaged_data[valid_genes, ]
summary(heatmap_data)

top_genes <- rownames(averaged_data)[order(apply(averaged_data, 1, var, na.rm = TRUE), decreasing = TRUE)][1:5]
heatmap_data <- averaged_data[top_genes, ]
library(pheatmap)
heatmap_data <- averaged_data[top_genes, ]



pheatmap(heatmap_data,
         scale = "row",
         show_rownames = TRUE,
         filename = "C:/Users/iarif/Downloads/AI_Omics_Internship_2025/Results/heatmap_top25.png")


table(phenotype_data$Group)
unique(phenotype_data$title)
colnames(phenotype_data)
unique(phenotype_data$characteristics_ch1)
unique(phenotype_data$characteristics_ch1.1)
unique(phenotype_data$characteristics_ch1.2)

unique(phenotype_data$source_name_ch1)

gse <- getGEO("GSE19804", GSEMatrix = TRUE)
gse <- gse[[1]]
phenotype_data <- pData(gse)
library(GEOquery)
colnames(averaged_data)
rownames(phenotype_data)
table(deg_results$threshold)


