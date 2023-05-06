-- Covid 19 Data Exploration 


USE Covid
-- Viewing the datasets

SELECT * FROM Covid.coviddeaths;

SELECT * FROM Covid.covidvaccinations;

-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid.coviddeaths
WHERE continent IS NOT NULL
ORDER BY location;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if a person contract covid

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Covid.coviddeaths
Where continent is not null 
order by 1;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From Covid.coviddeaths
order by 1;


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid.coviddeaths
Group by location, Population
order by PercentPopulationInfected desc;


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Covid.coviddeaths
Where continent is not null 
group by location
order by TotalDeathCount desc;



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Covid.coviddeaths
-- Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc;



-- GLOBAL NUMBERS

Select  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid.coviddeaths
where continent is not null 
Group By date
order by 2,3;



-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/ dea.population) * 100 as Percentage_Vaccinated
From Covid.coviddeaths dea
Join Covid.covidvaccinations vac
On dea.location = vac.location and dea.date = vac.date
where dea.continent is not null 
order by 2,3;


-- Using CTE to perform Calculation on Partition By in previous query
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From Covid.coviddeaths dea
Join Covid.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 3 desc
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentVaccinated
From PopvsVac;



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From Covid.coviddeaths dea
Join Covid.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date;
where dea.continent is not null 
-- order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated;



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From Covid.coviddeaths dea
Join Covid.covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

