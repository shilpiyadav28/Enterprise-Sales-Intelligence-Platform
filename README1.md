# 📊 Enterprise Sales Intelligence Platform

An **end-to-end data warehouse and analytics solution** built using SQL Server and Power BI.
This project demonstrates how raw data from multiple enterprise systems can be transformed into a structured data warehouse to support **advanced analytics and business intelligence reporting**.

The system integrates data from **CRM and ERP systems**, processes it through **ETL pipelines**, and transforms it into an analytics-ready format using **Medallion Architecture (Bronze → Silver → Gold)**.

The final output is an interactive **Power BI dashboard** that enables stakeholders to analyze sales performance, customer behavior, and product insights.

---

# 🚀 Project Highlights

• Built an **end-to-end retail sales data warehouse** using SQL Server

• Implemented **Medallion Architecture (Bronze → Silver → Gold)**

• Developed **SQL-based ETL pipelines** for data ingestion and transformation

• Designed a **Star Schema data model** for analytical queries

• Performed **Exploratory Data Analysis (EDA)** on sales datasets

• Built **Power BI dashboards** to deliver business insights

---

# 🧩 Business Problem

Retail organizations often store sales data across multiple systems such as **CRM platforms and ERP systems**.
Because this data is fragmented across systems, it becomes difficult for business teams to analyze:

* Customer purchasing behavior
  
* Product performance
  
* Sales trends
  
* Revenue growth patterns

This project solves that problem by building a **centralized data warehouse** that integrates data from multiple sources and transforms it into a format optimized for **analytical reporting and decision making**.

---

# 🏗 Data Architecture

The project follows **Medallion Architecture**, a modern approach used in data engineering to organize data into multiple layers.

```
CRM System        ERP System
     │                 │
     ▼                 ▼
   CSV Files       CSV Files
        \           /
         \         /
          ▼       ▼
        Bronze Layer
      (Raw Data Storage)
              │
              ▼
        Silver Layer
   (Data Cleaning & Transformation)
              │
              ▼
         Gold Layer
   (Business Ready Data Model)
              │
              ▼
        Power BI Dashboard
```

### Bronze Layer

* Stores raw data from CRM and ERP systems
* Data is loaded as-is from CSV files
* Maintains original data for traceability

### Silver Layer

* Performs data cleaning and standardization
* Handles missing values and duplicates
* Prepares structured datasets for analytics

### Gold Layer

* Contains business-ready data models
* Implements a **Star Schema design**
* Optimized for analytical queries and BI dashboards

---

# 🗂 Repository Structure

```
Retail-Sales-Data-Warehouse
│
├── README.md
│
├── dataset
│   ├── crm
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── erp
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── scripts
│   ├── bronze
│   │   ├── ddl_for_bronze.sql
│   │   └── load_bronze_data.sql
│   │
│   ├── silver
│   │   ├── ddl_for_silver_layer.sql
│   │   └── sp_loading_data_silver.sql
│   │
│   ├── gold
│   │   ├── ddl_for_golds.sql
│   
│ ── EDA
│       ├── Analysis.sql
│       ├── Magnitude_analysis.sql
│       ├── Ranking_analysis.sql
│
│── Advanced Analysis
│        ├──Change_over_Time_Analysis.sql
│        ├──Cumulative_Analysis.sql
│        ├──Data_Segmentation_Analysis.sql
│        ├──Part-to-whole_Analysis.sql
│        ├──Performance_Analysis.sql
│
│── Reports
│         ├──
│         ├──
│
├── dashboards
│   └── retail_sales_dashboard.pbix
│
├── images
│   ├── architecture_diagram.png
│   ├── data_model.png
│   ├── dashboard_overview.png
│
└── docs
    └── project_documentation.md
```

---

# 🧠 Data Modeling

The Gold layer uses a **Star Schema** to support fast analytical queries.

```
               Dim_Customers
                    │
                    │
Dim_Date ───── Fact_Sales ───── Dim_Products
                    │
                    │
               Dim_Location
```

### Fact Table

**Fact_Sales**

Contains transactional sales data including:

* Order ID
  
* Product ID
  
* Customer ID
  
* Sales Amount
  
* Quantity
  
* Order Date

### Dimension Tables

* **Dim_Customers** → customer attributes
  
* **Dim_Products** → product attributes
  
* **Dim_Date** → time dimension
  
* **Dim_Location** → store/location information

This structure enables efficient analysis of **customer behavior, product performance, and sales trends**.

---

# 🔍 Exploratory Data Analysis

EDA was performed using SQL queries to explore the dataset and understand key patterns.

Analysis included:

* Sales growth over time
  
* Product category performance
  
* Customer purchasing patterns
  
* Revenue contribution analysis

This helped define key **business metrics and KPIs** used in the dashboard.

---

# 📈 Analytics Reports

Two analytical reports were developed to generate business insights.

### Customer Analysis Report

Provides a comprehensive view of **customer purchasing behavior**.

Metrics include:

* Total orders
  
* Total sales
  
* Total products purchased
  
* Customer lifespan
  
* Average order value
  
* Average monthly spending

Customers were segmented into:

* **VIP customers**
  
* **Regular customers**
  
* **New customers**

---

### Product Performance Report

Analyzes **product revenue performance**.

Metrics include:

* Total orders
  
* Total sales
  
* Quantity sold
  
* Unique customers
  
* Average monthly revenue

Products were categorized into:

* High performing products
  
* Mid-range products
  
* Low performing products

---

# 📊 Power BI Dashboard

An interactive **Power BI dashboard** was created to visualize business metrics.

Key visualizations include:

* Revenue trends
  
* Monthly sales performance
  
* Product category performance
  
* Customer purchasing patterns
  
* Regional sales distribution


---

# 🛠 Technology Stack

* SQL Server
  
* T-SQL
  
* Data Warehousing
  
* ETL Pipelines
  
* Power BI
  
* Excel
  
* Data Modeling
  
* Business Intelligence

---

# 🎯 Key Skills Demonstrated

This project demonstrates expertise in:

* Data Warehousing Architecture
  
* SQL Development
  
* ETL Pipeline Design
  
* Data Modeling
  
* Exploratory Data Analysis
  
* Business Intelligence
  
* Dashboard Development

---

# 📌 Project Impact

The solution transforms fragmented enterprise data into a **centralized analytics platform** that enables:

* Better understanding of customer behavior
  
* Identification of top-performing products
  
* Monitoring of sales performance trends
  
* Data-driven business decision making

---
