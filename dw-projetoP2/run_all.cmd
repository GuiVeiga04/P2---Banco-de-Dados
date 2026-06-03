@echo off
REM run_all.cmd - Executa o pipeline 00→05 no Windows (CMD)
REM Uso: run_all.cmd

setlocal ENABLEDELAYEDEXPANSION

REM Ir para a pasta deste script
cd /d "%~dp0"

REM Selecionar executável do DuckDB: local ou PATH
set "DUCKDB=duckdb"
if exist "%~dp0duckdb.exe" set "DUCKDB=%~dp0duckdb.exe"

REM Arquivo de banco
set "DB=%~dp0demo.duckdb"

call :run "scripts/00_staging.sql" || goto :err
call :run "scripts/01_oltp.sql" || goto :err
call :run "scripts/02_dw_model.sql" || goto :err
call :run "scripts/03_etl_load.sql" || goto :err
call :run "scripts/04_analytics.sql" || goto :err
call :run "scripts/05_perf.sql" || goto :err

echo Pipeline concluido com sucesso.
goto :eof

:run
set "SCRIPT=%~1"
echo Executando: %SCRIPT%
"%DUCKDB%" "%DB%" -c ".read %SCRIPT%"
if errorlevel 1 exit /b 1
exit /b 0

:err
echo Houve uma falha na execucao. Verifique o passo acima.
exit /b 1
