
SELECT * from Portfolio..['Covid Deaths$']
order by 3,4


--SELECT * from Portfolio..['Covid vacination$']
--order by 3,4

select location, date, total_cases,new_cases, total_deaths, population, (total_deaths/total_cases)*100 as deathpercentage, (total_cases/population)*100 
from Portfolio..['Covid Deaths$']
where location like '%India'
order by 1,2

select location, population , max(total_cases) as highestinfectioncount , max((total_cases/population))*100 as percentpopulationinfected 
from Portfolio..['Covid Deaths$']
group by location ,population
order by 4 desc

--show Dates with highest death count

select date, sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as totaldeathcount, sum(cast(new_deaths as int))/ sum(new_cases)*100 as persentage 
from Portfolio..['Covid Deaths$']
where continent is not null
group by date 
order by 1,2

-- total new cases on death ratio

select  sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as totaldeathcount, sum(cast(new_deaths as int))/ sum(new_cases)*100 as persentage 
from Portfolio..['Covid Deaths$']
where continent is not null
--group by date 
order by 1,2

--total vacination vs population

with popvsvac (continent, location, date, population, new_vaccinations, vaccinated)
as
(
select dea.continent,dea.location, dea.date,  dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (partition  by dea.location order by dea.location,dea.date) as vaccinated 
from Portfolio..['Covid vacination$'] vac
join Portfolio..['Covid Deaths$'] dea
   on vac.date = dea.date
   and vac.location = dea.location
where dea.continent is not null

)


select *, (vaccinated /Population)*100 as persentage 
From popvsvac
where location like '%india%'
order by 2,3

-- create view 

create view persentageofpeoplevaccinatedinindia as 

with popvsvac (continent, location, date, population, new_vaccinations, vaccinated)
as
(
select dea.continent,dea.location, dea.date,  dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (partition  by dea.location order by dea.location,dea.date) as vaccinated 
from Portfolio..['Covid vacination$'] vac
join Portfolio..['Covid Deaths$'] dea
   on vac.date = dea.date
   and vac.location = dea.location
where dea.continent is not null

)


select *, (vaccinated /Population)*100 as percentag
From popvsvac
where location like '%india%'
--order by 2,3

