-- 02_dw_model.sql
-- DuckDB não usa search_path como no Postgres

-- Sequências para surrogate keys (SCD2)
DROP SEQUENCE IF EXISTS seq_country;
DROP SEQUENCE IF EXISTS seq_profile;

CREATE SEQUENCE seq_country START 1;
CREATE SEQUENCE seq_profile START 1;

-- Dimensão Tempo
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_key INTEGER,
    year INTEGER,
    decade INTEGER
);

-- Dimensão País
DROP TABLE IF EXISTS dim_country;

CREATE TABLE dim_country (
    country_key INTEGER DEFAULT nextval('seq_country'),
    iso_code VARCHAR,
    country VARCHAR,
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN
);

-- Dimensão Perfil Energético
DROP TABLE IF EXISTS dim_energy_profile;

CREATE TABLE dim_energy_profile (
    profile_key INTEGER DEFAULT nextval('seq_profile'),
    renewable_level VARCHAR,
    fossil_level VARCHAR,
    low_carbon_level VARCHAR,
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN
);


-- Tabela Fato
DROP TABLE IF EXISTS dw.fact_sales;
DROP TABLE IF EXISTS fact_energy;

CREATE TABLE fact_energy (

    country_key INTEGER,
    date_key INTEGER,
    profile_key INTEGER,

    population DOUBLE,
    gdp DOUBLE,

    primary_energy_consumption DOUBLE,

    renewables_consumption DOUBLE,
    fossil_fuel_consumption DOUBLE,

    solar_consumption DOUBLE,
    wind_consumption DOUBLE,
    hydro_consumption DOUBLE,

    electricity_generation DOUBLE,
    electricity_demand DOUBLE,

    greenhouse_gas_emissions DOUBLE,

    carbon_intensity_elec DOUBLE,

    low_carbon_share_energy DOUBLE
);