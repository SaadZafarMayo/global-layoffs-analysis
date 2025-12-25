-- =========================================
-- 02_deduplication.sql
-- Purpose: Remove duplicate records from the staging table
-- Raw data is preserved in 'layoffs', working on 'layoffs_staging'
-- =========================================


-- Step 1: Create a new table for cleaned data
CREATE TABLE layoffs_cleaned LIKE layoffs_staging;


-- Step 2: Add a helper column to identify duplicates
-- We cannot update the table directly using CTEs in MySQL
ALTER TABLE layoffs_cleaned
ADD COLUMN row_num INT;


-- Step 3: Insert data from staging table with row numbers
-- Partitioned by all columns to detect duplicates
INSERT INTO layoffs_cleaned
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off,
                        percentage_laid_off, `date`, stage, country, funds_raised_millions
       ) AS row_num
FROM layoffs_staging;


-- Step 4: Delete duplicate rows, keeping only the first occurrence
DELETE FROM layoffs_cleaned
WHERE row_num > 1;


-- Step 5: Drop the helper column as it is no longer needed
ALTER TABLE layoffs_cleaned
DROP COLUMN row_num;
