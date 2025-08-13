[README.md](https://github.com/user-attachments/files/21757934/README.md)
# Module I – AI_Omics_Internship_2025

## Project Overview
This project is part of the **AI Omics Internship 2025 – Module I** assignment.  
The goal is to:
- Create a structured RStudio project.
- Download and clean the `patient_info.csv` dataset from a GitHub repository.
- Convert variables to the correct data types.
- Create a binary smoking status variable.
- Save the cleaned dataset for further analysis.

---

## Repository Structure
```
Module_I/
│
├── raw_data/             # Original datasets (patient_info.csv)
├── clean_data/           # Cleaned datasets (patient_info_clean.csv)
├── scripts/              # R scripts (class_Ib.R)
├── results/              # Output tables or task results (if any)
├── plots/                # Graphical outputs (if any)
├── Module_I.Rproj        # RStudio project file
└── README.md             # Project description (this file)
```

---

## How to Run
1. Clone or download this repository.
2. Open the `Module_I.Rproj` file in RStudio.
3. Open `scripts/class_Ib.R` and run the code from start to finish.
4. The script will:
   - Create necessary folders (if not already present)
   - Load the dataset from `raw_data/`
   - Clean and transform variables
   - Save the cleaned dataset in `clean_data/`

---

## 📊 Dataset Information
**File:** `patient_info.csv`  
**Rows:** 20  
**Columns:**  
- `patient_id` – Unique patient identifier  
- `age` – Age in years  
- `gender` – Male/Female  
- `diagnosis` – Medical diagnosis  
- `bmi` – Body Mass Index  
- `smoker` – Yes/No  

---

## Requirements
- R (version 4.0 or above recommended)
- RStudio
- Base R functions only (no extra packages required)

---

##  Author
**Your Name** – AI Omics Internship 2025 Participant  
