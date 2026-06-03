-- 03_etl_load.sql
-- DuckDB não usa search_path como no Postgres

-- Limpeza das tabelas DW
DELETE FROM fact_energy;
DELETE FROM dim_energy_profile;
DELETE FROM dim_country;
DELETE FROM dim_date;

-- Carregar dim_country
INSERT INTO dim_country
SELECT
    ROW_NUMBER() OVER(),
    iso_code,
    country,
    CURRENT_DATE,
    NULL,
    TRUE
FROM countries;

-- Carregar dim_date
INSERT INTO dim_date
SELECT
    year,
    year,
    FLOOR(year / 10) * 10
FROM years;

--Carregar dim_energy_profile
INSERT INTO dim_energy_profile
SELECT DISTINCT

    ROW_NUMBER() OVER(),

    CASE
        WHEN renewables_consumption > fossil_fuel_consumption
        THEN 'HIGH'
        ELSE 'LOW'
    END,

    CASE
        WHEN fossil_fuel_consumption > renewables_consumption
        THEN 'HIGH'
        ELSE 'LOW'
    END,

    CASE
        WHEN low_carbon_share_energy >= 50
        THEN 'HIGH'
        ELSE 'LOW'
    END,

    CURRENT_DATE,
    NULL,
    TRUE

FROM energy_statistics;

--Carregar fato

INSERT INTO fact_energy

SELECT

    dc.country_key,

    dd.date_key,

    1 AS profile_key,

    e.population,
    e.gdp,

    e.primary_energy_consumption,

    e.renewables_consumption,
    e.fossil_fuel_consumption,

    e.solar_consumption,
    e.wind_consumption,
    e.hydro_consumption,

    e.electricity_generation,
    e.electricity_demand,

    e.greenhouse_gas_emissions,

    e.carbon_intensity_elec,

    e.low_carbon_share_energy

FROM energy_statistics e

JOIN dim_country dc
ON e.iso_code = dc.iso_code

JOIN dim_date dd
ON e.year = dd.year;