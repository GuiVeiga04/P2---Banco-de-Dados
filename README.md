# 🌍 Data Warehouse: Energia e Sustentabilidade

Este repositório contém o projeto final de implementação de um Data Warehouse (DW) focado na análise da evolução energética global, sustentabilidade, transição energética e emissões de gases de efeito estufa.

**Grupo:** DB Adventurers

**Alunos:**
* Guilherme Rodrigues Veiga
* Anita Shu Xian Zhu
* Alexandre Amador Silva

**Domínio:** Energia e Sustentabilidade  

---

## 🎯 Objetivo do Projeto

O objetivo principal deste projeto é consolidar e estruturar dados históricos globais de energia para permitir análises complexas sobre o consumo de combustíveis fósseis, a adoção de fontes renováveis e a intensidade de carbono das principais economias mundiais.

## 🛠️ Tecnologias Utilizadas

* **Banco de Dados / DW:** DuckDB (Modelagem Dimensional - Star Schema)
* **Linguagem:** Python
* **Visualização de Dados:** Plotly (Python) e PowerBI
* **Estratégia de Histórico:** Slowly Changing Dimension (SCD) Tipo 2

## 📊 Fonte de Dados

Utilizamos o dataset **"Data on Energy"** disponibilizado pelo *Our World in Data*.
* **Fonte:** [owid/energy-data](https://github.com/owid/energy-data)
* **Período Coberto:** 1900 a 2025
* **Volume:** 23.377 registros e 130 atributos cobrindo 314 países e regiões.

## 🏗️ Arquitetura e Modelagem (Pipeline ETL)

O projeto segue um fluxo de dados estruturado em múltiplas camadas:

1. **Staging:** Extração dos dados brutos do arquivo CSV.
2. **OLTP (Normalizado):** Tratamento e normalização inicial dos dados.
3. **Data Warehouse (Star Schema):** Estruturação analítica contendo 4 dimensões e tabelas fato.
4. **SCD Tipo 2:** Implementação de controle de histórico (`start_date`, `end_date`, `is_current`) para rastrear mudanças nas classificações dos países e perfis energéticos ao longo do tempo.
5. **Otimização:** Criação de tabelas agregadas (`agg_country_year`), resultando em uma **redução de 85,7%** no tempo de execução das consultas analíticas.

## 💡 Principais Insights e Análises

Através das consultas e dashboards construídos, foi possível identificar que:
* **Brasil e França** possuem a menor intensidade de carbono entre as grandes economias globais.
* O consumo global de combustíveis fósseis praticamente **dobrou** entre as décadas de 1960 e 1990.
* A **Índia** ainda apresenta uma dependência crítica de combustíveis fósseis com altas taxas de emissão.

## 🚀 Como Executar o Projeto

1. Clone este repositório:
```bash
   git clone https://github.com/GuiVeiga04/P2---Banco-de-Dados