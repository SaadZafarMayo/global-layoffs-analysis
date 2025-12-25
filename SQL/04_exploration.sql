-- =========================================
-- 04_exploration.sql
-- Purpose: Explore 'layoffs_cleaned' table to uncover patterns and insights
-- =========================================


-- =====================
-- Step 1: Industries with spikes in layoffs year-over-year
-- Identify industries that had significant increase in layoffs compared to previous year
-- =====================
WITH industry_layoffs AS (
    SELECT
        industry,
        YEAR(`date`) AS year,
        SUM(total_laid_off) AS total_layoffs
    FROM layoffs_cleaned
    WHERE total_laid_off IS NOT NULL
    GROUP BY industry, YEAR(`date`)
),
industry_spikes AS (
    SELECT
        industry,
        year,
        total_layoffs,
        total_layoffs - LAG(total_layoffs) OVER (PARTITION BY industry ORDER BY year) AS spike_year,
        LAG(total_layoffs) OVER (PARTITION BY industry ORDER BY year) AS prev_year_layoffs
    FROM industry_layoffs
)
SELECT
    industry,
    year,
    total_layoffs,
    spike_year,
    spike_year / prev_year_layoffs * 100 AS spike_percentage
FROM industry_spikes
WHERE spike_year IS NOT NULL
ORDER BY industry, year;


-- =====================
-- Step 2: Industry-focused Analysis
-- =====================

-- Highest total layoffs by industry
WITH industry_highest_lay AS (
    SELECT 
        industry,
        SUM(total_laid_off) AS total_laid_off,
        RANK() OVER (ORDER BY SUM(total_laid_off) DESC) AS ranking
    FROM layoffs_cleaned
    GROUP BY industry
)
SELECT industry
FROM industry_highest_lay
WHERE ranking < 2;


-- Highest average percentage of employees laid off by industry
WITH highest_perc_lay_industry AS (
    SELECT 
        industry,
        AVG(percentage_laid_off) AS percent_lay,
        RANK() OVER (ORDER BY AVG(percentage_laid_off) DESC) AS ranking
    FROM layoffs_cleaned
    GROUP BY industry
)
SELECT industry, percent_lay
FROM highest_perc_lay_industry
WHERE ranking = 1;


-- Number of companies per industry that experienced layoffs
SELECT 
    industry,
    COUNT(company) AS num_comp
FROM layoffs_cleaned
WHERE total_laid_off IS NOT NULL AND total_laid_off != 0
GROUP BY industry
ORDER BY num_comp DESC;


-- =====================
-- Step 3: Country-focused Analysis
-- =====================

-- Countries with the most total layoffs
WITH country_most_lay AS (
    SELECT 
        country, 
        SUM(total_laid_off) AS summing,
        RANK() OVER (ORDER BY SUM(total_laid_off) DESC) AS ranking
    FROM layoffs_cleaned
    GROUP BY country
)
SELECT *
FROM country_most_lay
WHERE ranking = 1;


-- Countries with the highest average percentage of layoffs
WITH highest_perc_lay_country AS (
    SELECT 
        country,
        AVG(percentage_laid_off) AS percent_lay,
        RANK() OVER (ORDER BY AVG(percentage_laid_off) DESC) AS ranking
    FROM layoffs_cleaned
    GROUP BY country
)
SELECT country, percent_lay
FROM highest_perc_lay_country
WHERE ranking = 1;


-- =====================
-- Step 4: Company-focused Analysis
-- =====================

-- Companies with the largest total layoffs
SELECT 
    company,
    SUM(total_laid_off) AS summing
FROM layoffs_cleaned
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY summing DESC;


-- Companies with the highest percentage of layoffs
SELECT 
    company, 
    MAX(percentage_laid_off)
FROM layoffs_cleaned
WHERE percentage_laid_off IS NOT NULL
GROUP BY company
ORDER BY 2 DESC;


-- Top 5 companies by layoffs per industry
WITH company_industry_lay AS (
    SELECT 
        industry,
        company,
        SUM(total_laid_off) AS total_laid_off,
        RANK() OVER (PARTITION BY industry ORDER BY SUM(total_laid_off) DESC) AS ranking
    FROM layoffs_cleaned
    GROUP BY industry, company
)
SELECT industry, company, total_laid_off
FROM company_industry_lay
WHERE ranking <= 5
ORDER BY industry, ranking;


-- =====================
-- Step 5: Time-focused Analysis
-- =====================

-- Yearly layoffs trend
WITH yearly_trend AS (
    SELECT 
        YEAR(`date`) AS yearly, 
        SUM(total_laid_off), 
        RANK() OVER (ORDER BY SUM(total_laid_off) DESC) AS ranking
    FROM layoffs_cleaned 
    GROUP BY yearly
    ORDER BY yearly
)
SELECT * FROM yearly_trend;


-- Year with the highest total layoffs
WITH yearly_trend AS (
    SELECT 
        YEAR(`date`) AS yearly, 
        SUM(total_laid_off), 
        RANK() OVER (ORDER BY SUM(total_laid_off) DESC) AS ranking
    FROM layoffs_cleaned 
    GROUP BY yearly
    ORDER BY yearly
)
SELECT * 
FROM yearly_trend 
WHERE ranking = 1;


-- Monthly layoffs trend
WITH yearly_trend AS (
    SELECT 
        DATE_FORMAT(`date`, '%Y-%m') AS monthly, 
        SUM(total_laid_off) AS summing, 
        RANK() OVER (ORDER BY SUM(total_laid_off) DESC) AS ranking
    FROM layoffs_cleaned 
    WHERE total_laid_off IS NOT NULL 
    GROUP BY monthly
    ORDER BY monthly
)
SELECT * FROM yearly_trend;


-- =====================
-- Step 6: Funding stage Analysis
-- =====================

-- Average layoffs per funding stage
SELECT 
    stage,
    AVG(total_laid_off) AS avg_laid_off
FROM layoffs_cleaned
WHERE total_laid_off IS NOT NULL
GROUP BY stage
ORDER BY avg_laid_off DESC;
