# Global Company Layoffs Analysis

## Project Overview
This project analyzes **global company layoffs** to uncover trends across industries, countries, companies, and over time. It demonstrates **end-to-end SQL skills** including data cleaning, transformation, and exploratory analysis, using **real-world messy data**.

The analysis provides actionable insights on:  
- Industries and companies most impacted by layoffs  
- Geographic trends and country-level patterns  
- Layoffs trends over time (yearly/monthly)  
- Correlations with company funding stage  

---

## Workflow & Methodology

1. **Raw Data Import (`01_raw.sql`)**  
   - Load the raw global layoffs dataset into a staging table (`layoffs_staging`) while preserving original data.

2. **Deduplication (`02_deduplication.sql`)**  
   - Added a `row_num` using `ROW_NUMBER()` over key columns.  
   - Removed duplicate rows to create a clean working table (`layoffs_cleaned`).

3. **Data Cleaning & Standardization (`03_data_cleaning.sql`)**  
   - Trim whitespace and standardize text (company, industry, country).  
   - Convert `date` column to proper `DATE` type.  
   - Convert numeric columns to `INT` or `FLOAT`.  
   - Fill missing industry values based on company and location.  

4. **Exploratory Analysis (`04_exploration.sql`)**  
   - **Industry-focused**: total layoffs, average percentage, number of affected companies  
   - **Country-focused**: total layoffs, highest average layoffs  
   - **Company-focused**: total layoffs, percentage layoffs, top companies per industry  
   - **Time-focused**: yearly and monthly trends, industry layoffs spikes using **CTEs and window functions**  
   - **Funding stage analysis**: average layoffs per stage  

---

## Key Insights

- **Industry trends**: Identify industries with sudden year-over-year layoffs spikes.  
- **Country trends**: Highlights countries most affected globally.  
- **Company insights**: Pinpoints companies with the largest layoffs and harshest single events.  
- **Temporal trends**: Shows peak layoffs periods, monthly and yearly.  
- **Funding stage correlation**: Demonstrates relationship between company maturity and layoffs.  


---

## Skills Demonstrated

- **SQL Querying & Analysis**: `SELECT`, `JOIN`, `GROUP BY`, `HAVING`, **CTEs**, window functions (`ROW_NUMBER()`, `RANK()`, `LAG()`)  

- **Data Cleaning & Preparation**: Handling duplicates, nulls, inconsistent text, and date conversions

- **Analytical Thinking**: Extracting patterns and insights across multiple dimensions (industry, country, company, time)  


---

## How to Run

1. Open your SQL environment (MySQL Workbench, DataGrip, etc.).  
2. Execute the scripts **in order**:  
   - `01_raw.sql`  
   - `02_deduplication.sql`  
   - `03_data_cleaning.sql`  
   - `04_exploration.sql`  
3. Review results and explore trends and insights in the database.  

---

