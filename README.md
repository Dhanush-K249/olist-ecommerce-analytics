# Olist E-Commerce End-to-End Analytics Engine

A production-grade analytical repository designed to transform raw transactional marketplace data into structured executive insights.
This architecture spans programmatic Python data preparation, rigorous SQL time-series database design, complex cohort segmentation,\
and an interactive Power BI dashboard tracking growth health.

---

## 📂 Project Architecture & Pipeline Flow
* **`/data_preparation`**: Scripts running Python (Pandas) pipelines to standardize column encodings, fix text inconsistencies, handle missing categorical metrics, and automatically capture dynamic module dependencies.
* **`/sql_analytics`**: Chronological relational analytical scripts executing heavy aggregation windows, recursive CTE time series padding, and customer cohort grouping filters.
* **`/dashboards`**: Consolidated report models utilizing analytical measures for unified trend evaluation.

---

## ⚙️ How to Replicate and Run This Pipeline
1. **Acquire Raw Data**: Download the raw Brazilian E-Commerce public dataset from Kaggle and place the raw `.csv` files inside a local `/data/raw/` directory.
2. **Execute Python Environment & Cleaning Scripts**:
   ```bash
   pip install -r data_preparation/requirements.txt
   python data_preparation/standardize_column_names.py
