--DATA EXPLORATION WITH COVID CASES

--Select *
--From PortfolioProject..CovidDeaths
--order by 3,4



--Select *
--From PortfolioProject..CovidDeaths
----order by 3,4


-- SELECT DATA WE GOING TO BE USING


--Select location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeaths
--Order by 1,2

-- looking at total cases vs total deaths
--Select location, date, total_cases, total_deaths, (total_deaths/total_cases)
--From PortfolioProject..CovidDeaths
--Order by 1,2

-- looking at total cases vs total deaths in percentage

--Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as deathPercentage
--From PortfolioProject..CovidDeaths
--Order by 1,2


-- SHOWS THE LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as deathPercentage
From PortfolioProject..CovidDeaths
where location like '%africa%'
Order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as deathPercentage
From PortfolioProject..CovidDeaths
where location like '%united states%'
Order by 1,2



--LOOKING @ THE TOAL CASE VS POPULATON
-- SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID


Select Location, date, population, total_cases,  (total_cases/population) * 100 AS CovidCases
From PortfolioProject..CovidDeaths
where location like '%Africa%'
Order by 1, 2

Select Location, date, population, total_cases,  (total_cases/population) * 100 AS CovidCases
From PortfolioProject..CovidDeaths
--where location like '%Africa%'
Order by 1, 2

-- LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

Select Location, population, MAX(total_cases) AS HighestInectionCount,  MAX((total_cases/population)) * 100 As 
PercentOfPopulationInected
From PortfolioProject..CovidDeaths
--where location like '%Africa%'
Where continent is not null
Group by Location, population
Order by PercentOfPopulationInected desc




--SHOWING THE COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

--Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
----where location like '%Africa%'
--Group by Location
--Order by TotalDeathCount desc

Select Location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%Africa%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

Select location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%Africa%'
Where continent is null
Group by location
Order by TotalDeathCount desc


Select continent, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%Africa%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


-- SHOWING THE CONTINIENT WITH THE HIGHEST DEATH COUNT PER POPULATION




-- GLOBAL NUMBERS

Select date, SUM(new_cases) as TotalCasePerDay
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
where continent is not null
Group by date
order by TotalCasePerDay desc



Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths) / SUM(new_cases) as
DeathPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
where continent is not null
Group by date
order by 1, 2

--GENERAL TOTAL CASE


Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths) / SUM(new_cases) as
DeathPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
where continent is not null
--Group by date
order by 1, 2

--STAGE 2


--Select *
--from PortfolioProject..CovidVaccinations


--Select *
--From PortfolioProject..CovidDeaths as dea
--Join PortfolioProject..CovidVaccinations as vac
--    On dea.location = vac.location
--	and dea.date = vac.date



--LOOKIN AT TOTAL POPULATION VS VACCINATION


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
	order by 1,2,3



--LOOKIN AT TOTAL POPULATION VS VACCINATION USING ROLLING UP

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
	order by 2,3



-- USE CTE

With PopvsVac (Contininet, Location, date, Population, new_vaccinations, RollingPeopleVaccinated)
as

(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--	order by 2,3
)


Select *, (RollingPeopleVaccinated/Population) * 100
From PopvsVac






-- USING TEMP TABLE

--Create Table #PercentPopulationVaccinateds
--(
--continent nvarchar(255),
--Location nvarchar(255),
--Date datetime, 
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--Insert into #PercentPopulationVaccinateds
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--From PortfolioProject..CovidDeaths as dea
--Join PortfolioProject..CovidVaccinations as vac
--    On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
----	order by 2,3

--Select *, (RollingPeopleVaccinated/Population) * 100
--From #PercentPopulationVaccinateds


--LET SAY YOU MADE A MISTAKE AND WANT TO MAKE A CORRECTION TO YOUR TEMP TABLE

DROP Table if exists #PercentPopulationVaccinateds
Create Table #PercentPopulationVaccinateds
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinateds
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--	order by 2,3

Select *, (RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinateds


--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select *
from dbo.PercentPopulationVaccinated
