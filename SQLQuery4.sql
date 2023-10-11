select *
FROM ['covidDeaths']
order by 3,4

SELECT *
FROM CovidVaccinations
order by 3,4


-- selecting data to use

Select Location, date, new_cases, total_cases,  new_deaths, total_deaths, population
FROM ['covidDeaths']
order by 1,2

-- total cases vs total deaths
-- shows likelihood of dying if you got Covid in Poland
SELECT 
    Location, 
    date, 
    total_cases, 
    new_deaths, 
    total_deaths, 
    (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 as DeathPercentage
FROM ['covidDeaths']
where Location like '%Poland%'
ORDER BY 1, 2;


-- Total cases vs Population in Poland

SELECT
CASE WHEN total_cases < 50000 and total_cases IS NOT NULL THEN 'Small amount'
	WHEN total_cases > 50000 and total_cases IS NOT NULL THEN 'Huge amount'
	ELSE 'Cannot define'
	END as AmountCategory,
Location,
date,
total_cases,
population,
    (CAST(total_cases AS float) / CAST(population AS float)) * 100 as IllnessPercent
FROM ['covidDeaths']
WHERE location LIKE '%Poland%'
ORDER BY date


-- Countries with Highest Infection Rate compared to Population
SELECT
    Location,
    population,
    MAX(total_cases) as MaxTotalCases,
    (MAX(total_cases) / CAST(population AS float)) * 100 as IllnessPercent
FROM ['covidDeaths']
GROUP BY Location, population
order by IllnessPercent desc

-- Countries with highest deaths 

SELECT
    Location,
	MAX(CAST (total_deaths AS int)) as TotalDeathCount
FROM ['covidDeaths']
WHERE continent is not null
GROUP BY Location
order by TotalDeathCount desc

-- highest deaths on continents 

SELECT
    Location,
	MAX(CAST (total_deaths AS int)) as TotalDeathCount
FROM ['covidDeaths']
WHERE continent is null
GROUP BY Location
order by TotalDeathCount desc

-- global stats

-- new cases daily

Select date, SUM(new_cases) as NewCasesDaily
FROM ['covidDeaths']
WHERE continent is not null
group by date
order by 1,2

-- new deaths&cases daily

Select date, SUM(new_cases) as NewCasesDaily, SUM(new_deaths) as NewDeathsDaily
FROM ['covidDeaths']
WHERE continent is not null
group by date, new_deaths
order by 1,2

-- including death percentage daily

SELECT 
    date, 
    SUM(new_cases) as NewCasesDaily, 
    SUM(new_deaths) as NewDeathsDaily, 
    CASE 
        WHEN SUM(new_cases) > 0 THEN (SUM(new_deaths) / SUM(new_cases) * 100) 
        ELSE 0 
    END as DeathPercentageDaily
FROM ['covidDeaths']
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- overall cases & deaths %


SELECT  
    SUM(new_cases) as NewCases, 
    SUM(new_deaths) as NewDeaths, 
    CASE 
        WHEN SUM(new_cases) > 0 THEN (SUM(new_deaths) / SUM(new_cases) * 100) 
        ELSE 0 
    END as DeathPercentage
FROM ['covidDeaths']
WHERE continent IS NOT NULL
ORDER BY 1,2


-- COVID VACCINATION CASES



SELECT *
from ['covidDeaths'] as cd
join CovidVaccinations as cv
	on cd.location = cv.location
	and cd.date = cv.date

	-- total population vs vaccinations

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
FROM ['covidDeaths'] as cd
JOIN CovidVaccinations as cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL;