Use Projects;

Select location, date, total_cases, new_cases, total_deaths, population
From deaths
Order By date

-- total cases vs total deaths ( likelihood of dying)

Select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) As death_percentage
From deaths
Order By date

-- total cases cs population (percentage of population infected 
Select location, date, total_cases, population, ((total_cases/population)*100) As infected_population_percentage
From deaths
Order By date


-- highest infection rate 
Select location, Max(total_cases) As infection_count_ceiling, population, Max((total_cases/population)*100) As infected_population_percentage
From deaths
Group By location, population 
Order By infected_population_percentage Desc

-- Big Common wealth countries 

Select date, Sum(new_cases) As total_cases, Sum(new_deaths) As total_deaths, (Sum(new_deaths)/ Sum(new_cases)) *100 As death_percentage
From deaths
Group By date

Select date, Sum(new_cases) As total_cases, Sum(new_deaths) As total_deaths, (Sum(new_deaths)/ Sum(new_cases)) *100 As death_percentage
From deaths
Where location != 'canada'
Group By date

Select date, Sum(new_cases) As total_cases, Sum(new_deaths) As total_deaths, (Sum(new_deaths)/ Sum(new_cases)) *100 As death_percentage
From deaths
Where location != '%united%'
Group By date

Select date, Sum(new_cases) As total_cases, Sum(new_deaths) As total_deaths, (Sum(new_deaths)/ Sum(new_cases)) *100 As death_percentage
From deaths
Where location != '%zealand%'
Group By date

Select date, Sum(new_cases) As total_cases, Sum(new_deaths) As total_deaths, (Sum(new_deaths)/ Sum(new_cases)) *100 As death_percentage
From deaths
Where location != '%austr%'
Group By date




-- total population vacination rate 

Select
d.location,
d.date,
d.population,
v.new_vaccinations, 
Sum(v.new_vaccinations) Over (Partition By d.location Order By d.location, d.date) As peaople_vaccinated_rolling_count
From deaths d
Join vaccine v
	On d.date = v.date
    And d.location = v.location 
Order By d.date

-- CTE 

With popvsvac( location, date, population, new_vaccinations, peaople_vaccinated_rolling_count)
As (
Select
d.location,
d.date,
d.population,
v.new_vaccinations, 
Sum(v.new_vaccinations) Over (Partition By d.location Order By d.location, d.date) As peaople_vaccinated_rolling_count
From deaths d
Join vaccine v
	On d.date = v.date
    And d.location = v.location 
)
Select * , ((peaople_vaccinated_rolling_count/ population) * 100) As rolling_population_vacination_percentage
From popvsvac

-- creating view for Tableau 

Create View percent_population_vaccinated As 
Select
d.location,
d.date,
d.population,
v.new_vaccinations, 
Sum(v.new_vaccinations) Over (Partition By d.location Order By d.location, d.date) As peaople_vaccinated_rolling_count
From deaths d
Join vaccine v
	On d.date = v.date
    And d.location = v.location 
    
Create View Big_common_wealth_deaths As
Select date, Sum(new_cases) As total_cases, Sum(new_deaths) As total_deaths, (Sum(new_deaths)/ Sum(new_cases)) *100 As death_percentage
From deaths
Group By date

Create View canada_vs_Uk_Nz_Aus As
Select date, Sum(new_cases) As total_cases, Sum(new_deaths) As total_deaths, (Sum(new_deaths)/ Sum(new_cases)) *100 As death_percentage
From deaths
Where location != 'canada'
Group By date

Create View Highest_infection_rate As 
Select location, Max(total_cases) As infection_count_ceiling, population, Max((total_cases/population)*100) As infected_population_percentage
From deaths
Group By location, population 
Order By infected_population_percentage Desc


Create View odds_of_dying As
Select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) As death_percentage
From deaths
Order By date

Create View percentage_of_population_infected As 
Select location, date, total_cases, population, ((total_cases/population)*100) As infected_population_percentage
From deaths
Order By date