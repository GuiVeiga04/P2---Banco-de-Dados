#!/usr/bin/env bash
# run_all.sh - Executa o pipeline 00→05 no macOS/Linux
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v duckdb >/dev/null 2>&1; then
  echo "duckdb não encontrado no PATH. Instale com: brew install duckdb" >&2
  exit 1
fi

DB="demo.duckdb"
for f in 00_staging.sql 01_oltp.sql 02_dw_model.sql 03_etl_load.sql 04_analytics.sql 05_perf.sql; do
  echo "Executando: scripts/$f"
  duckdb "$DB" -c ".read scripts/$f"
done

echo "Pipeline concluído com sucesso."
