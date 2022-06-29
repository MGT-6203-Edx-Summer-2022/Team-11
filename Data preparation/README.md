
1. Data Preparation.py : 
  (1) access FRED API and NASDAQ API to pull macroeconomic index information
  (2) Combine the the information with some information from other sources such as yahoo finance, Wall street Journal etc
  (3) Data cleansing and aggragation on monthly or quarterly level
  (4) Conversion to perchange change MOM or QoQ
  
  
 2. SPX.CSV S&P 500 data
  (1) data source: WSJ+kaggle 
  (2) kaggle : https://www.kaggle.com/datasets/henryhan117/sp-500-historical-data 
  (3) wsj : https://www.wsj.com/market-data/quotes/index/SPX/historical-prices
  
 3. DXY data from yahoo finance
  (1) https://finance.yahoo.com/quote/DX-Y.NYB/historyperiod1=31795200&period2=1656288000&interval=1d&filter=history&frequency=1d&includeAdjustedClose=true
  
 4. api.json: API keys for FRED and NASDAQ link
 5. metadata: independent variable names and their full name
 6. Macro_SP.csv: combined raw data on day level
 7. Macro_SP_month.csv: combined raw data on month level
 8. Macro_SP_MoM.csv: percent change of indexes(month on month)
 9. Macro_SP_QoQ.csv: perchent change of indexes(quarter on quarter)
