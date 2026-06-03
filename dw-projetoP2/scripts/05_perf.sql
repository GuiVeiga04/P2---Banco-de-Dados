-- 05_perf.sql
-- DuckDB não usa search_path como no Postgres

DROP TABLE IF EXISTS agg_country_year;

CREATE TABLE agg_country_year AS

SELECT
    dc.country,
    dd.year,

    SUM(f.renewables_consumption) AS renewables_total,
    SUM(f.fossil_fuel_consumption) AS fossil_total,
    AVG(f.low_carbon_share_energy) AS avg_low_carbon

FROM fact_energy f

JOIN dim_country dc
    ON f.country_key = dc.country_key

JOIN dim_date dd
    ON f.date_key = dd.date_key

GROUP BY
    dc.country,
    dd.year;