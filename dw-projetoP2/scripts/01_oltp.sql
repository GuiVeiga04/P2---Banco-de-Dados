-- 01_oltp.sql
-- DuckDB não usa search_path como no Postgres

-- Tabela de países
DROP TABLE IF EXISTS countries;

CREATE TABLE countries AS
SELECT DISTINCT
    iso_code,
    country
FROM stg_energy
WHERE iso_code IS NOT NULL
  AND iso_code <> '';

-- Tabela de anos
DROP TABLE IF EXISTS years;

CREATE TABLE years AS
SELECT DISTINCT
    CAST(year AS INTEGER) AS year
FROM stg_energy
WHERE year IS NOT NULL;

-- Tabela principal
DROP TABLE IF EXISTS energy_statistics;

CREATE TABLE energy_statistics AS
SELECT

    country,
    iso_code,

    TRY_CAST(population AS DOUBLE) AS population,
    TRY_CAST(year AS INTEGER) AS year,

    TRY_CAST(gdp AS DOUBLE) AS gdp,

    TRY_CAST(primary_energy_consumption AS DOUBLE)
        AS primary_energy_consumption,

    TRY_CAST(renewables_consumption AS DOUBLE)
        AS renewables_consumption,

    TRY_CAST(fossil_fuel_consumption AS DOUBLE)
        AS fossil_fuel_consumption,

    TRY_CAST(solar_consumption AS DOUBLE)
        AS solar_consumption,

    TRY_CAST(wind_consumption AS DOUBLE)
        AS wind_consumption,

    TRY_CAST(hydro_consumption AS DOUBLE)
        AS hydro_consumption,

    TRY_CAST(greenhouse_gas_emissions AS DOUBLE)
        AS greenhouse_gas_emissions,

    TRY_CAST(carbon_intensity_elec AS DOUBLE)
        AS carbon_intensity_elec,

    TRY_CAST(electricity_generation AS DOUBLE)
        AS electricity_generation,

    TRY_CAST(electricity_demand AS DOUBLE)
        AS electricity_demand,

    TRY_CAST(low_carbon_share_energy AS DOUBLE)
        AS low_carbon_share_energy

FROM stg_energy
WHERE iso_code IS NOT NULL
  AND iso_code <> '';