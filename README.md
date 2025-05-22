# Data_Pipeline_EDA_project-



Welcome to the **Data Pipeline & Exploratory Data Analysis (EDA) Project** repository!
This project is inspired by the comprehensive tutorial by Baraa Khatib Salkini, titled *"SQL Data Warehouse from Scratch | Full Hands-On Data Engineering Project"*. The tutorial provides a step-by-step guide to building a data pipeline and performing exploratory data analysis using SQL. You can watch the full tutorial here: [SQL Data Warehouse from Scratch](https://www.youtube.com/watch?v=9GVqKuTVANE).

---

## 🧱 Data Architecture

The project follows a structured data architecture inspired by the Medallion Architecture, comprising three layers:([GitHub][1])

1. **Bronze Layer**: Ingests raw data from source systems (e.g., CSV files) into the database.
2. **Silver Layer**: Performs data cleansing, standardization, and transformation to prepare data for analysis.
3. **Gold Layer**: Contains business-ready data modeled into a star schema for reporting and analytics.([GitHub][1])

---

## 📌 Project Overview

This project encompasses:

* **Data Ingestion**: Loading raw datasets into the database.
* **Data Transformation**: Cleaning and transforming data to ensure quality and consistency.
* **Data Modeling**: Designing fact and dimension tables optimized for analytical queries.
* **Exploratory Data Analysis (EDA)**: Generating insights through data visualization and statistical analysis.

---

## 🛠️ Tools & Technologies

* **Database**: SQL Server Express
* **SQL Client**: SQL Server Management Studio (SSMS)
* **Scripting**: Python, SQL
* **Visualization**: Matplotlib, Seaborn
* **Project Management**: Notion
* **Diagramming**: Draw\.io([datawithbaraa.com][2], [YouTube][3], [GitHub][1])

---

## 📁 Repository Structure

```
data-pipeline-eda-project/
├── datasets/                 # Raw datasets used for the project
├── docs/                     # Documentation and diagrams
│   ├── data_architecture.drawio
│   ├── data_flow.drawio
│   └── data_models.drawio
├── scripts/                  # Scripts for data processing and analysis
│   ├── bronze/               # Data ingestion scripts
│   ├── silver/               # Data transformation scripts
│   └── gold/                 # Data modeling and EDA scripts
├── tests/                    # Test cases to validate scripts
├── README.md                 # Project overview and instructions
├── LICENSE                   # Licensing information
└── requirements.txt          # Python dependencies
```

---

## 🚀 Getting Started

### Prerequisites

* Python 3.x
* SQL Server Express
* SQL Server Management Studio (SSMS)([GitHub][1])

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/data-pipeline-eda-project.git
   cd data-pipeline-eda-project
   ```



2. **Install Python dependencies:**

   ```bash
   pip install -r requirements.txt
   ```

3. **Set up the database:**

   * Use SSMS to create a new database.
   * Execute the scripts in the `scripts/bronze/` directory to ingest raw data.([datawithbaraa.com][4], [GitHub][1])

4. **Run data transformation and modeling scripts:**

   * Execute scripts in `scripts/silver/` for data cleaning and transformation.
   * Execute scripts in `scripts/gold/` to create analytical models.([GitHub][1])

5. **Perform Exploratory Data Analysis:**

   * Run the EDA scripts in `scripts/gold/` to generate insights and visualizations.

---

## 📊 Features

* Structured data pipeline following industry best practices.
* Comprehensive data cleaning and transformation processes.
* Robust data modeling using star schema.
* Insightful exploratory data analysis with visualizations.([GitHub][1])

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🙌 Acknowledgements

This project is inspired by the tutorial from [DataWithBaraa](https://github.com/DataWithBaraa/sql-data-warehouse-project).

---
