-- Exploratory Data Analysis

SELECT company, SUM(total_laid_off)
FROM layoffs_staging_num
GROUP BY company
ORDER BY 2 DESC
LIMIT 10
;


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_num
GROUP BY industry
ORDER BY 2 DESC
LIMIT 10
;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging_num
GROUP BY country
ORDER BY 2 DESC
LIMIT 10
;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_num
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1
;

WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_num
GROUP BY company, YEAR(`date`)
), company_year_ranking AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_ranking
WHERE ranking <= 3
;











