# DATA CLEANING
-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. NULL VALUES OR BLANK VALUES
-- 4. REMOVE ANY COLUMNS

SELECT * 
FROM layoffs_staging;

CREATE TABLE layoffs_staging
LIKE layoffs_raw;

INSERT layoffs_staging
SELECT *
FROM layoffs_raw;

--- 1 ---
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
ORDER BY row_num DESC
;

CREATE TABLE `layoffs_staging_num` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging_num
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging_num
WHERE row_num = 2
;

SELECT *
FROM layoffs_staging_num
ORDER BY row_num DESC
;


--- 2 ---
-----
SELECT *
FROM layoffs_staging_num
;

UPDATE layoffs_staging_num
SET company = TRIM(company);
-----

SELECT DISTINCT industry
FROM layoffs_staging_num
;

UPDATE layoffs_staging_num
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
;
-----

SELECT country
FROM layoffs_staging_num
;

UPDATE layoffs_staging_num
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'
;
-----

SELECT *
FROM layoffs_staging_num
;

UPDATE layoffs_staging_num
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
;

ALTER TABLE layoffs_staging_num
MODIFY COLUMN `date` DATE;
-----

SELECT *
FROM layoffs_staging_num
WHERE industry IS NULL
OR industry = '';

SELECT t1.company, t1.industry, t2.industry
FROM layoffs_staging_num t1
JOIN layoffs_staging_num t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging_num t1
JOIN layoffs_staging_num t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging_num
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging_num
WHERE company LIKE 'Bally%'
;
-----

SELECT *
FROM layoffs_staging_num
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

DELETE
FROM layoffs_staging_num
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;
-----

ALTER TABLE layoffs_staging_num
DROP COLUMN row_num;


