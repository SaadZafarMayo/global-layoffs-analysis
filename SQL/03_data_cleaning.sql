-- =========================================
-- 03_data_cleaning.sql
-- Purpose: Further clean and standardize data in 'layoffs_cleaned'
-- =========================================


-- Step 1: Trim whitespace from company names
-- Remove extra spaces at the start and end of company names
UPDATE layoffs_cleaned
SET company = TRIM(company);


-- Step 2: Fill missing industry values
-- 1) Set empty strings to NULL
-- 2) Fill NULLs using other records for the same company and location
UPDATE layoffs_cleaned
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_cleaned t1
JOIN layoffs_cleaned t2
  ON t1.company = t2.company
 AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;


-- Step 3: Standardize industry names
-- Examples: 'crypto', 'cryptoCurrency', 'crypto Currency' → 'Crypto'
UPDATE layoffs_cleaned
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Step 4: Clean and convert dates
-- Replace invalid 'NONE' values with NULL
UPDATE layoffs_cleaned
SET `date` = NULL
WHERE `date` LIKE 'NONE';

-- Convert text dates to proper DATE format
UPDATE layoffs_cleaned
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Ensure column type is DATE
ALTER TABLE layoffs_cleaned
MODIFY COLUMN `date` DATE;


-- Step 5: Fix country names with trailing dots
UPDATE layoffs_cleaned
SET country = 'United States'
WHERE country LIKE 'United States.';


-- Step 6: Convert numeric columns to proper types
-- percentage_laid_off from text to FLOAT
ALTER TABLE layoffs_cleaned
MODIFY COLUMN percentage_laid_off FLOAT;


-- Step 7: Adjust text column lengths
ALTER TABLE layoffs_cleaned
MODIFY COLUMN company VARCHAR(100),
MODIFY COLUMN location VARCHAR(100),
MODIFY COLUMN industry VARCHAR(50),
MODIFY COLUMN stage VARCHAR(50),
MODIFY COLUMN country VARCHAR(50);
