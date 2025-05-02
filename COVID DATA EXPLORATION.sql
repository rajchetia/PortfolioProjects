use [Covid 19 Data Analytics Project]


select * from CovidDeaths_csv
where continent is not null
order by 3,4

select * from vaccination_data
order by 3,4

SELECT * FROM CovidDeaths_csv

SELECT location , date ,total_cases,new_cases,total_deaths,population
from CovidDeaths_csv
where continent is not null
order by 1,2

-- Looking at Total Cases vs Total  Deaths

SELECT 
location ,
date ,
total_cases,
total_deaths,
(CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS DeathPercentage
from CovidDeaths_csv
where location like 'India'
order by 1,2

-- BY COUNTRY 


--Looking at total cases v/s population
-- shows what percentage of population got infected by Covid
SELECT 
location ,
date ,
total_cases,
population,
(CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS InfectedPercentage
from CovidDeaths_csv
where location like 'India'
order by 1,2


--Looking at countries with highest cases in the world
SELECT 
location ,
MAX(CAST(total_cases AS FLOAT)) AS max_total_cases,
population,
(MAX(CAST(total_cases AS FLOAT)) / CAST(population AS FLOAT)) * 100 AS InfectedPercentage
from CovidDeaths_csv
where continent is not null
GROUP BY 
    location, population
ORDER BY 
 max_total_cases DESC  


 --Looking at countries with highest deathcount
 SELECT 
location ,
MAX(CAST(total_deaths AS FLOAT)) AS total_deathcount,
population
from CovidDeaths_csv
where continent is not null
GROUP BY 
    location, population
ORDER BY 
 total_deathcount DESC  

 -- BY CONTINENT

 SELECT 
continent ,
MAX(CAST(total_deaths AS FLOAT)) AS total_deathcount
from CovidDeaths_csv
where continent is not null
GROUP BY continent
ORDER BY  total_deathcount DESC  


SELECT 

SUM(CAST(new_cases as float)) as total_cases1,
SUM(cast(new_deaths as float))as total_deaths1,
SUM(cast(new_deaths as float))/SUM(CAST(new_cases as float))*100 as DeathPercentage
from CovidDeaths_csv
where continent  is not null
--GROUP BY date
ORDER BY  1,2


--GLOBAL NUMBERS
SELECT 
date,
SUM(CAST(new_cases AS FLOAT)) as newcase
from CovidDeaths_csv
where new_cases is not null
GROUP BY date
ORDER BY  1,2  


SELECT *
FROM CovidDeaths_csv as DEA
Join vaccination_data as vac
on DEA.location=vac.location
and DEA.Date=vac.date


SELECT dea.continent,dea.location,dea.population,dea.date,vac.new_vaccinations
FROM CovidDeaths_csv as DEA
Join vaccination_data as vac
on DEA.location=vac.location
and DEA.Date=vac.date
where dea.continent is not null
order by 1,2,3


--LOOKING AT TOTAL POPULATION VS VACCINATIONS


SELECT dea.continent,dea.location,dea.population,dea.date,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
FROM CovidDeaths_csv as DEA
Join vaccination_data as vac
on DEA.location=vac.location
and DEA.Date=vac.date
where dea.continent is not null
order by 1,2,3


-- USE CTE

WITH PopvsVac(Continent,Location,Date,Population,New_vaccinations,RollingPeopleVaccinated)
as (
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
FROM CovidDeaths_csv as DEA
Join vaccination_data as vac
on DEA.location=vac.location
and DEA.Date=vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/Population)*100 as Percentage_Of_People_Vaccinated
from PopvsVac


-- CREATING TEMP TABLE 
DROP TABLE IF EXISTS #PERCENTAGE_VACCINATED
CREATE TABLE #PERCENTAGE_VACCINATED
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PERCENTAGE_VACCINATED

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
FROM CovidDeaths_csv as DEA
Join vaccination_data as vac
on DEA.location=vac.location
and DEA.Date=vac.date
--where dea.continent is not null

select * ,(RollingPeopleVaccinated/Population)*100 as Percentage_Of_People_Vaccinated
from #PERCENTAGE_VACCINATED

-- CREATIINNG VIEWS FOR LATER VISUALIZATION


CREATE VIEW PERCENTAGE_VACCINATED AS 

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
FROM CovidDeaths_csv as DEA
Join vaccination_data as vac
on DEA.location=vac.location
and DEA.Date=vac.date
where dea.continent is not null