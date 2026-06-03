# Tutorial (Windows): Mini Data Warehouse com DuckDB


Guia passo a passo para montar um mini data warehouse de e-commerce usando DuckDB no Windows. Ao final você terá o arquivo `demo.duckdb` pronto, consultas analíticas funcionando e sete gráficos em PNG.



---

## 0. Resultado Esperado

- Banco `demo.duckdb` criado ou atualizado na raiz do projeto.
- Tabelas preenchidas nos esquemas `staging`, `oltp` e `dw`.
- Scripts `scripts/00` → `scripts/05` executados sem erros.
- Sete gráficos salvos em `outputs/`.

---

## 1. Pré-requisitos
- Windows 10 ou superior com PowerShell.
- Permissão para ajustar a política de execução de scripts (escopo do usuário).
- [DuckDB CLI para Windows](https://duckdb.org/docs/installation/cli) (arquivo `duckdb.exe`).
- Python 3.9 ou superior instalado.

> **Dica**: use uma pasta sem espaços, por exemplo `C:\data\dw-atividade-olist-sample`.

---

## 2. Baixar o projeto
1. Baixe o ZIP ou clone o repositório para um diretório acessível.
2. Abra o PowerShell e entre na raiz do projeto:
   ```powershell
   cd "C:\data\dw-atividade-olist-sample"
   ```
3. Rode `dir` e confirme que você enxerga as pastas `scripts\` e `data\`.

---

## 3. Permitir scripts no PowerShell
1. Execute uma vez para o seu usuário:
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
   ```
2. Se o Windows reclamar de assinatura, desbloqueie os arquivos baixados:
   ```powershell
   Unblock-File .\run_all.ps1
   Unblock-File .\scripts\*.sql
   ```
3. Alternativa temporária (não altera a política):
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\run_all.ps1
   ```

---

## 4. Disponibilizar o DuckDB CLI
1. Extraia o `duckdb.exe` do ZIP baixado.
2. Coloque-o **na raiz do projeto** 
3. Teste se o PowerShell encontra o executável:
   ```powershell
   Get-Command duckdb -ErrorAction SilentlyContinue
   ```
   - Se o comando não retornar nada, use `./duckdb.exe` sempre que o tutorial mencionar `duckdb`.
4. Valide a execução:
   ```powershell
   .\duckdb.exe demo.duckdb -c "SELECT 'ok' AS status;"
   ```

---

## 5. Rodar o pipeline completo
1. Certifique-se de estar na raiz do projeto.
2. Execute o script principal:
   ```powershell
   ./run_all.ps1
   ```
   - Ele tenta usar `duckdb` do PATH e, se não achar, usa `./duckdb.exe` local.
   - Os scripts SQL são executados em ordem (`00` → `05`).
3. Ao finalizar, confira se o arquivo `demo.duckdb` foi criado/atualizado.

> **Importante**: feche qualquer shell interativo do DuckDB (`\q`) antes de rodar `run_all.ps1` novamente. Caso contrário, o arquivo fica bloqueado.

---

## 6. Validar rapidamente os dados
1. Abra o shell do DuckDB apontando para o banco recém-criado:
   ```powershell
   ./duckdb.exe demo.duckdb
   ```
2. Dentro do shell (`D>`), execute:
   ```sql
   SELECT COUNT(*) FROM staging.orders;
   SELECT COUNT(*) FROM oltp.orders;
   SELECT COUNT(*) FROM dw.dim_customer WHERE is_current;
   SELECT COUNT(*) FROM dw.fact_sales;
   ```
3. Se todas retornarem valores positivos, o ETL rodou corretamente. Saia com `\q`.

---

## 7. Explorar consultas analíticas
1. Com o shell aberto, experimente trechos do arquivo `scripts/04_analytics.sql`:
   ```sql
   SELECT 
  dd.year,
  dd.month,
  dp.category,
  SUM(f.revenue) AS revenue
FROM dw.fact_sales f
JOIN dw.dim_date dd ON dd.date_key = f.date_key
JOIN dw.dim_product dp ON dp.product_key = f.product_key AND dp.is_current = TRUE
GROUP BY 1, 2, 3
ORDER BY 1, 2, 4 DESC;
   ```
   Consulta 2 - top 10 produtos
   SELECT 
  dp.product_name,
  SUM(f.revenue) AS revenue_total
FROM dw.fact_sales f
JOIN dw.dim_product dp ON dp.product_key = f.product_key AND dp.is_current = TRUE
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

2. Quando terminar, digite `\q`ou ctrl + c para sair.

---

## 8. Preparar o ambiente Python
1. Verifique a versão:
   ```powershell
   python --version
   ```
   - Se o comando abrir a Microsoft Store, desative o alias em Configurações → Aplicativos → Aliases de execução.
2. Crie um ambiente virtual na raiz do projeto:
   ```powershell
   python -m venv .venv
   ```
3. Ative a venv:
   ```powershell
   .\.venv\Scripts\Activate.ps1
   ```
4. Atualize o `pip` e instale as dependências:
   ```powershell
   python -m pip install --upgrade pip
   pip install --only-binary=:all: duckdb pandas plotly kaleido
   ```
   - O parâmetro `--only-binary=:all:` evita tentativas de compilação local do `duckdb`.

---

## 9. Gerar os gráficos

1. Certifique-se de que o ETL rodou antes (passo 5)..\duckdb.exe demo.duckdb -c ".read scripts/00_setup_duckdb.sql"

2. Com a venv ativa, execute:.\duckdb.exe demo.duckdb -c ".read scripts/01_oltp.sql"   ```powershell   ```powershell

   ```powershell

   python gerar_graficos.py

   ``````

3. O script cria uma pasta `outputs/` com sete gráficos PNG:

   - Receita mensal por categoria.

   - Top 10 produtos por receita e quantidade.   - Se o Windows bloquear o script por falta de assinatura, desbloqueie com:   - Se o Windows bloquear o script por falta de assinatura, desbloqueie com:

   - Evolução de novos clientes.

   - Ticket médio por UF.## 5. Conferir resultados

   - Curva ABC de receita.

   - Pizza de receita por categoria.Abra uma sessão interativa do DuckDB (o prompt muda para `D>`):     ```powershell     ```

   - Evolução mensal de pedidos versus receita.```powershell

4. Quando terminar, desative a venv:

   ```powershell

   deactivate

   ``````


## 10. Trocar os dados (opcional)

1. Substitua os arquivos da pasta `data/` pelos seus CSVs mantendo os nomes e colunas mínimas.

2. Rode novamente o pipeline (`./run_all.ps1`).SELECT COUNT(*) FROM dw.fact_sales;2. O script cria/atualiza `demo.duckdb` e executa, em ordem:2. O script cria/atualiza `demo.duckdb` e executa, em ordem:

3. Gere os gráficos (`python gerar_graficos.py`).- Pressione Enter após cada linha; o DuckDB executa quando encontra o `;`.   - `00_setup_duckdb.sql`: staging lendo os CSVs   - `00_setup_duckdb.sql`: staging lendo os CSVs



---- Para sair do shell, use `\q` ou `CTRL+D`.

Parte 1: Validação
-- 1. Quantos pedidos existem no total?
SELECT COUNT(*) FROM dw.fact_sales;

-- 2. Quantos clientes únicos estão ativos?
SELECT COUNT(*) FROM dw.dim_customer WHERE is_current = TRUE;

-- 3. Quantas categorias de produtos diferentes existem?
SELECT COUNT(DISTINCT category) FROM dw.dim_product WHERE is_current = TRUE;

Parte 2: Análise de Receita


-- 4. Qual foi a receita total de vendas?
SELECT SUM(revenue) AS receita_total FROM dw.fact_sales;

-- 5. Qual categoria gerou mais receita?
SELECT 
  dp.category,
  SUM(f.revenue) AS receita_total
FROM dw.fact_sales f
JOIN dw.dim_product dp ON dp.product_key = f.product_key AND dp.is_current = TRUE
GROUP BY dp.category
ORDER BY receita_total DESC
LIMIT 1;

-- 6. Em qual mês houve mais vendas?
SELECT 
  dd.year,
  dd.month,
  dd.month_name,
  SUM(f.revenue) AS receita
FROM dw.fact_sales f
JOIN dw.dim_date dd ON dd.date_key = f.date_key
GROUP BY dd.year, dd.month, dd.month_name
ORDER BY receita DESC
LIMIT 1;

Parte 3: Análise Geográfica

-- 7. Qual estado (UF) dos vendedores teve mais receita?
SELECT 
  ds.seller_state,
  SUM(f.revenue) AS receita_total,
  COUNT(DISTINCT f.order_id) AS total_pedidos
FROM dw.fact_sales f
JOIN dw.dim_seller ds ON ds.seller_key = f.seller_key AND ds.is_current = TRUE
GROUP BY ds.seller_state
ORDER BY receita_total DESC
LIMIT 3;

