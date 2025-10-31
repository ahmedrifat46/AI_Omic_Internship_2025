## Class 3CB Assignment – Differential Expression Analysis (GSE19804)

Multiple probes mapped to the same gene due to overlapping transcript regions and redundant array design. I used the `hgu133plus2.db` annotation package with `AnnotationDbi::mapIds()` to assign gene symbols, and collapsed duplicate probes using `limma::avereps()` to ensure one expression value per gene.  
I performed differential gene expression analysis comparing **lung adenocarcinoma vs adjacent normal tissue** using the `limma` package.  
Based on adjusted p-value < 0.05 and |logFC| > 1, I identified **166 upregulated** and **604 downregulated** genes.  
A volcano plot was successfully generated to visualize DEGs. I attempted to generate a heatmap of the top 25 DEGs, but due to missing or non-numeric values in the expression matrix, the heatmap could not be rendered reliably.
