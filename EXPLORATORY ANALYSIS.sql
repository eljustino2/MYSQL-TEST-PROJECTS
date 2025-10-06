-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoffs_staging2;


SELECT MAX(total_laid_off)
FROM layoffs_staging2;


SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

CREATE TABLE layoffs_clean AS
SELECT DISTINCT
    TRIM(company) AS company,
    TRIM(location) AS location,
    NULLIF(TRIM(industry), '') AS industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    TRIM(country) AS country,
    funds_raised_millions
FROM layoffs_staging2;


RENAME TABLE layoffs_clean TO layoff_staging2;


SELECT *
FROM layoff_staging2;


SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT MIN(`date`), MAX(`date`)
FROM layoff_staging2;


SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT country, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoff_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;


WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoff_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;


SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;



SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
;


WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;

SELECT company, SUM(funds_raised_millions)
FROM layoff_staging2
GROUP BY company
ORDER BY SUM(funds_raised_millions) DESC
LIMIT 5;


SELECT *
FROM layoff_staging2;


SELECT company, SUM(funds_raised_millions)
FROM layoff_staging2
GROUP BY company, funds_raised_millions
ORDER BY SUM(funds_raised_millions) DESC;















