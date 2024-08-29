select location , date, total_vaccinations, new_vaccinations
from CovidVaccinations
where continent is not null
and location like 'Brunei'
order by 3,4
--------------------------------------------------------------------------------------------
select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from CovidDeaths
where location like 'Morocco'
order by 1,2
------------------------------Infection_Per_Population--------------------------------------
select location, date, total_cases, population, (total_cases/population)*100 as Population_Infected
from CovidDeaths
where location like 'Morocco'
order by 1,2
-----------------------------------------DONE-VIEW---------------------------------------------------
select location, population, max(total_cases)as Total_infection,max((total_cases/population))*100 as Infected_percentage
from CovidDeaths
where continent is not null
group by population, location
order by 1
-----------------------------------------DONE-VIEW----------------------------------------------
select location, max(cast(total_deaths as bigint)) as death_count , population , (MAX(CAST(total_deaths AS bigint))/population)*100 AS dead_population
from CovidDeaths
where continent is not null
group by location , population 
order by 1
-----------------------------------------DONE-VIEW----------------------------------------------------
with increment_cases (date, total_cases, total_Deaths, Death_percentage)
as(
SELECT date,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    CASE
        WHEN SUM(new_cases) = 0 THEN 0
        ELSE SUM(CAST(new_deaths AS INT)) / SUM(new_cases)   
 * 100
    END AS Death_percentage
FROM CovidDeaths
where continent is not null
group by date
)
select *,
      sum(total_cases) over (order by date ) as increment_totalcases,
	  sum(total_deaths) over (order by date ) as increment_totaldeaths,
	  sum(total_deaths) over (order by date ) / sum(total_cases) over (order by date) * 100 as increment_Deathpercentage
from increment_cases
order by 1
-----------------------------------------DONE-VIEW---------------------------------------------------
select location, sum(new_cases) as total_cases,
	   sum(cast(new_deaths as int)) as total_deaths,
	   sum(cast(new_deaths as int)) / sum(new_cases)*100 as Death_precentage
from CovidDeaths
where continent is not null
group by location
order by 1,2
-----------------------------------------DONE-VIEW----------------------------------------------------
select vac.continent, vac.location, death.population, sum(cast(vac.total_vaccinations as bigint)) as Total_ofvaccinations
from CovidVaccinations as vac
join CovidDeaths as death
on   vac.location = death.location
and  vac.date = death.date
where vac.continent is not null
group by vac.continent , vac.location, death.population
order by 1,2
--------------------------------------------------------------------------------------------
select vac.continent, 
       vac.location,
	   death.population, 
	   vac.new_vaccinations,
	   sum(cast(vac.new_vaccinations as bigint)) 
	   over (partition by death.location order by death.location, death.date) as increment_vac
from CovidVaccinations as vac
join CovidDeaths as death
on   vac.location = death.location
and  vac.date = death.date
where death.continent is not null
and death.location like 'Morocco'
order by 2,3
--------------------------------------------------------------------------------------------
select death.continent, 
       death.location,
	   death.date,
	   death.population, 
	   vac.total_vaccinations,
	   (total_vaccinations/population)*100 as popvac_perday
from CovidVaccinations as vac
join CovidDeaths as death
on   death.location = vac.location
and  death.date = vac.date
where vac.continent is not null
and vac.total_vaccinations is not null
order by 2,3

----------------------------------------------------------------------------------------------------
create view PopVacPerDay as
select death.continent, 
       death.location,
	   death.date,
	   death.population, 
	   vac.total_vaccinations,
	   (total_vaccinations/population)*100 as popvac_perday
from CovidVaccinations as vac
join CovidDeaths as death
on   death.location = vac.location
and  death.date = vac.date
where vac.continent is not null
and vac.total_vaccinations is not null





