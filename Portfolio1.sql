-- Data that will be used 
SELECT Continent, Location, Date, Total_cases, new_cases, Total_deaths, population
FROM CovidDeaths
ORDER BY [location], [date]

-- Total cases vs. Total death // percentage of people who had covid and died
-- This shows the likelihood of dying of contract covid-19 in the United States
SELECT Continent, Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Chance_of_Death
FROM PortfolioProject.dbo.CovidDeaths
WHERE [location] like '%states' and 'continent' is not NULL
ORDER BY [location], [date]


-- Total cases vs. population // percentage of the population that caught covid-19
SELECT Continent, Location, Date, population, total_cases, (total_cases/population)*100 AS Percentage_Population_Infected
FROM PortfolioProject.dbo.CovidDeaths
WHERE [location] like '%states'
ORDER BY [location], [date]

-- What countries have the highest infection rates when compared to the population
SELECT Continent, Location, Population, MAX(total_cases) AS Highest_Infection, MAX((total_cases/population))*100 AS Percentage_Population_Infected
FROM CovidDeaths
GROUP BY Continent, location, population
ORDER BY Percentage_Population_Infected DESC

-- Countries with the highest deaths per their population size
SELECT Continent, Location, Population, MAX(total_deaths) AS Highest_Deaths, MAX((total_deaths/population))*100 AS Percentage_Population_Deaths
FROM CovidDeaths
Group by [continent], [population]
ORDER BY Highest_Deaths DESC

-- Countries with the highest death counts
SELECT Continent,Location, MAX(total_deaths)AS Total_Death_Count
FROM CovidDeaths
WHERE [continent] is not NULL
GROUP by Continent,location
ORDER By Total_Death_Count DESC

-- Continent with the highest death counts
SELECT continent, MAX(total_deaths) AS Total_Death_Count
FROM CovidDeaths
WHERE continent is not NULL
GROUP by continent
ORDER BY Total_Death_Count DESC

-- Global Numbers 
SELECT SUM(new_cases) AS Total_cases, SUM(new_deaths) AS Total_deaths, SUM(new_deaths)/SUM(NULLIF(new_cases, 0))*100 AS Death_Percentage 
FROM CovidDeaths
ORDER BY 1, 2

-- I am going to look at the total population vs the vaccinations bewteen two different tables 
SELECT Deaths.Continent, Deaths.location, Deaths.DATE, Deaths.population, Vaccinations.new_vaccinations,
    SUM(Cast(Vaccinations.new_vaccinations AS bigint)) OVER (partition by deaths.location ORDER BY Deaths.Location, Deaths.Date) AS Rolling_Vaccinations
FROM CovidDeaths AS Deaths
JOIN CovidVaccinations AS Vaccinations
    ON Deaths.[location] = Vaccinations.[location] and Deaths.[date] = Vaccinations.[date]  
WHERE Deaths.continent is not NULL
ORDER BY [location], [date]

-- CTE
WITH PopulationVsVaccinations (Continent, Location, Date, Population, new_vaccinations, Rolling_Vaccinations)  
AS 
(
SELECT Deaths.Continent, Deaths.location, Deaths.DATE, Deaths.population, Vaccinations.new_vaccinations,
    SUM(Vaccinations.new_vaccinations) OVER (partition by deaths.location ORDER BY Deaths.Location, Deaths.Date) AS Rolling_Vaccinations
FROM CovidDeaths AS Deaths
JOIN CovidVaccinations AS Vaccinations
    ON Deaths.[location] = Vaccinations.[location] and Deaths.[date] = Vaccinations.[date]  
WHERE Deaths.continent is not NULL 
ORDER BY [location], [date]
)
SELECT *, (Rolling_Vaccinations/Population)*100
FROM PopulationVsVaccinations

-- Temp Table
DROP Table IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nVARCHAR(50),
location nVARCHAR(50),
DATE DATETIME,
Population numeric,
new_vaccinations numeric,
Rolling_Vaccinations numeric
)
Insert into #PercentPopulationVaccinated
SELECT Deaths.Continent, Deaths.location, Deaths.DATE, Deaths.population, Vaccinations.new_vaccinations,
    SUM(Vaccinations.new_vaccinations) OVER (partition by deaths.location ORDER BY Deaths.Location, Deaths.Date) AS Rolling_Vaccinations
FROM CovidDeaths AS Deaths
JOIN CovidVaccinations AS Vaccinations
    ON Deaths.[location] = Vaccinations.[location] and Deaths.[date] = Vaccinations.[date]  
WHERE Deaths.continent is not NULL
ORDER BY [location], [date]

SELECT *, (Rolling_Vaccinations/Population)*100
FROM #PercentPopulationVaccinated


