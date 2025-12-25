

--  Create staging table from raw data

create table layoffs_staging like layoffs;

Insert into layoffs_staging select * from layoffs;



