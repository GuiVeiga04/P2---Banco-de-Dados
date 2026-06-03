-- 04_analytics.sql
-- DuckDB não usa search_path como no Postgres

-- Q1. Top 10 países em renováveis
SELECT
    country,
    SUM(renewables_consumption) AS total_renewables
FROM energy_statistics
GROUP BY country
ORDER BY total_renewables DESC
LIMIT 10;

-- Q2. Evolução mundial das renováveis
SELECT
    year,
    SUM(renewables_consumption) AS renewable_energy
FROM energy_statistics
GROUP BY year
ORDER BY year;

-- Q3. Evolução dos combustíveis fósseis
SELECT
    year,
    SUM(fossil_fuel_consumption) AS fossil_energy
FROM energy_statistics
GROUP BY year
ORDER BY year;

-- Q4 Emissões por país
SELECT
    country,
    AVG(greenhouse_gas_emissions) AS avg_emissions
FROM energy_statistics
GROUP BY country
ORDER BY avg_emissions DESC;