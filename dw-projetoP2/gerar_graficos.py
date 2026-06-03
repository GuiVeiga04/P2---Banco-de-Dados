import duckdb
import pandas as pd
import plotly.express as px

# Conectar ao banco de dados DuckDB do projeto
conn = duckdb.connect(database='energy_dw.db', read_only=True)

# ============================================================================
# Gráfico 1: Evolução Global do Consumo de Energia por Década
# ============================================================================

query1 = """
SELECT 
    d.decade AS decada, 
    AVG(f.renewables_consumption) AS consumo_renovavel,
    AVG(f.fossil_fuel_consumption) AS consumo_fossil
FROM fact_energy f 
JOIN dim_date d ON f.date_key = d.date_key 
WHERE d.decade IS NOT NULL
GROUP BY d.decade 
ORDER BY d.decade;
"""
df1 = conn.execute(query1).df()

if not df1.empty:
    fig1 = px.line(df1, x='decada', y=['consumo_fossil', 'consumo_renovavel'],
                   title='Evolução Global do Consumo de Energia por Década',
                   labels={'decada': 'Década', 'value': 'Consumo de Energia', 'variable': 'Fonte'},
                   markers=True,
                   color_discrete_map={'consumo_fossil': '#ef553b', 'consumo_renovavel': '#00cc96'}) # Cores personalizadas
    
    fig1.update_layout(template="plotly_white", legend=dict(orientation="h", y=-0.2, x=0.5, xanchor="center"))
    
    fig1.write_image('grafico_1_evolucao_temporal.png', width=1200, height=600)
    print("✅ Gráfico 1 salvo: grafico_1_evolucao_temporal.png")
else:
    print("⚠️  Gráfico 1: sem dados")


# ============================================================================
# Gráfico 2: Top 10 Países com Maior Participação de Energia de Baixo Carbono
# ============================================================================

query2 = """
SELECT 
    c.country AS pais, 
    AVG(f.low_carbon_share_energy) AS percentual_baixo_carbono
FROM fact_energy f 
JOIN dim_country c ON f.country_key = c.country_key 
GROUP BY c.country 
ORDER BY percentual_baixo_carbono DESC
LIMIT 10;
"""
df2 = conn.execute(query2).df()

if not df2.empty:
    fig2 = px.bar(df2, 
                  x='percentual_baixo_carbono', 
                  y='pais',
                  orientation='h', 
                  title='Top 10 Países com Maior Participação de Energia de Baixo Carbono',
                  labels={'percentual_baixo_carbono': '% Médio de Energia de Baixo Carbono', 'pais': 'País'},
                  text_auto='.2f') 
    
    fig2.update_yaxes(categoryorder='total ascending')
    
    fig2.write_image('grafico_2_top_baixo_carbono.png', width=1200, height=600)
    print("✅ Gráfico 2 salvo: grafico_2_top_baixo_carbono.png")
else:
    print("⚠️  Gráfico 2: sem dados")

# ============================================================================
# Gráfico 3: Correlação entre o Consumo de Energia, Emissões de Carbono e a Riqueza (PIB)
# ============================================================================

query3 = """
SELECT 
    c.country AS pais, 
    f.primary_energy_consumption AS consumo_energia,
    f.greenhouse_gas_emissions AS emissoes_gases,
    f.gdp AS pib
FROM fact_energy f 
JOIN dim_country c ON f.country_key = c.country_key 
JOIN dim_date d ON f.date_key = d.date_key
WHERE d.year = 2022 
  AND f.primary_energy_consumption IS NOT NULL 
  AND f.greenhouse_gas_emissions IS NOT NULL
  AND f.gdp IS NOT NULL;
"""
df3 = conn.execute(query3).df()

if not df3.empty:

    paises_destaque = ['China', 'United States', 'India', 'Russia', 'Japan', 'Brazil', 'Germany']
    df3['rotulo_pais'] = df3['pais'].apply(lambda x: x if x in paises_destaque else '')

    fig3 = px.scatter(df3, 
                      x='consumo_energia', 
                      y='emissoes_gases',
                      size='pib',           
                      text='rotulo_pais',   
                      title='Correlação: Consumo de Energia vs. Emissões de Gases (Ano: 2022)',
                      labels={'consumo_energia': 'Consumo de Energia Primária', 
                              'emissoes_gases': 'Emissões de Gases de Efeito Estufa',
                              'pib': 'PIB (Tamanho da Bolha)'},
                      size_max=60)             
    fig3.update_traces(textposition='top center', textfont=dict(size=10))
    
    fig3.write_image('grafico_3_dispersao_correlacao.png', width=1200, height=600)
    print("✅ Gráfico 3 salvo: grafico_3_dispersao_correlacao.png")
else:
    print("⚠️  Gráfico 3: sem dados")