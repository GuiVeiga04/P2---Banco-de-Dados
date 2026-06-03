-- 00_staging.sql
PRAGMA threads=4;

CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS oltp;
CREATE SCHEMA IF NOT EXISTS dw;


-- Views de staging lendo CSVs
CREATE OR REPLACE VIEW stg_energy AS
SELECT *
FROM read_csv_auto(
    'data/owid-energy-data.csv',
    delim=',',
    header=true
)
WHERE iso_code IS NOT NULL
  AND TRIM(iso_code) <> '';