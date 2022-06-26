import pandas as pd
import yfinance as yf
import matplotlib.pyplot as plt
import numpy as np
import nasdaqdatalink



def cal_ema(prices, days, smoothing=2):
    ema = [sum(prices[:days]) / days]
    for price in prices[days:]:
        ema.append((price * (smoothing / (1 + days))) + ema[-1] * (1 - (smoothing / (1 + days))))
    return ema

# test yfinance API
ticker = 'AAPL'
time = '2y'
tk = yf.Ticker(ticker)
hist_df = tk.history(period=time)
info = tk.info
fin = tk.quarterly_financials
cash = tk.quarterly_cashflow
balancesheet = tk.quarterly_balancesheet
earnings = tk.quarterly_earnings
news = tk.news



# plot moving average and stock price
# plot price and moving averages
#
# ema_20 = cal_ema(hist_df['Close'], 20)
# ema_60 = cal_ema(hist_df['Close'], 60)
# ema_120 = cal_ema(hist_df['Close'], 120)
#
# price_X = np.arange(hist_df['Close'].shape[0])
# ema_20_X = np.arange(20, hist_df['Close'].shape[0] + 1)
# ema_60_X = np.arange(60, hist_df['Close'].shape[0] + 1)
# ema_120_X = np.arange(120, hist_df['Close'].shape[0] + 1)
#
# vol_ema_20 = cal_ema(hist_df['Volume'], 20)
# vol_ema_60 = cal_ema(hist_df['Volume'], 60)
# vol_ema_120 = cal_ema(hist_df['Volume'], 120)
#
# fig, ax1 = plt.subplots(figsize=(15, 8))
# ax1.set_xlabel('Days')
# ax1.set_ylabel('Price')
# ax1.plot(price_X, hist_df['Close'], label='Closing Prices')
# ax1.plot(ema_20_X, ema_20, label='EMA20', color='silver')
# ax1.plot(ema_60_X, ema_60, label='EMA60', color='grey')
# ax1.plot(ema_120_X, ema_120, label='EMA120', color='black')
# ax1.legend(loc="center left")
#
# ax2 = ax1.twinx()
#
# ax2.bar(price_X, hist_df['Volume'], label='Volume')
# ax2.plot(ema_20_X, vol_ema_20, label='Vol EMA20', color='lightsteelblue')
# ax2.plot(ema_60_X, vol_ema_60, label='Vol EMA60', color='royalblue')
# ax2.plot(ema_120_X, vol_ema_120, label='Vol EMA120', color='midnightblue')
# ax2.legend(loc="upper left")
# ax2.tick_params(axis='y')
# ax2.set_ylabel('Volume')
# ax2.set_ylim([0, 2500000000])
#
# plt.legend(loc="best")
# plt.show() plot

# test Nasdaq data link API
nasdaqdatalink.ApiConfig.api_key = "JALPe5q2Tjzx5N6sTXni"

# fred data, huge data set, refers to the metadata * problem**
GDP = nasdaqdatalink.get("FRED/GDP")
GDP.to_csv('GDP.csv')

REAL_GDP = nasdaqdatalink.get("FRED/GDPC1")
REAL_GDP.to_csv('REAL_GDP.csv')

# Consumer Price Index for All Urban Consumers: All Items Less Food & Energy
CPILFESL = nasdaqdatalink.get("FRED/CPILFESL")
CPILFESL.to_csv('CPILFESL.csv')

# Consumer Price Index for All Urban Consumers: All Items
CPIAUCSL = nasdaqdatalink.get("FRED/CPIAUCSL")
CPIAUCSL.to_csv('CPIAUCSL.csv')

# Effective Federal Funds Rate
DFF = nasdaqdatalink.get("FRED/DFF")
DFF.to_csv('DFF.csv')

# 10-Year Treasury Constant Maturity Rate
DGS10 = nasdaqdatalink.get("FRED/DGS10")
DGS10.to_csv('DGS10.csv')

# 2-Year Treasury Constant Maturity Rate
DGS2 = nasdaqdatalink.get("FRED/DGS2")
DGS2.to_csv('DGS2.csv')

# All Employees: Total Nonfarm Payrolls seasonally adjusted *** doesn't match the investing.com***
PAYEMS = nasdaqdatalink.get("FRED/PAYEMS")
PAYEMS.to_csv('PAYEMS.csv')

# All Employees: Total Nonfarm Payrolls not seasonally adjusted *** doesn't match the investing.com***
PAYEMA = nasdaqdatalink.get("FRED/PAYNSA")

# 	Initial Claims
ICSA = nasdaqdatalink.get("FRED/ICSA")
ICSA.to_csv('ICSA.csv')

# Retail Sales: Total (Excluding Food Services) *** doesn't match the investing.com***
RSXFS = nasdaqdatalink.get("FRED/RSXFS")
RSXFS.to_csv('RSXFS.csv')

# Overnight London Interbank Offered Rate (LIBOR), based on U.S. Dollar
OverNight_libor = nasdaqdatalink.get("FRED/USDONTD156N")
OverNight_libor.to_csv('OverNight_libor.csv')

# there are several unemployment rate, short term, long term, civilian
unemployment = nasdaqdatalink.get('FRED/UNRATE')
unemployment.to_csv('unemployment.csv')

# 	M1 Money Stock
M1 = nasdaqdatalink.get('FRED/M1')
M1.to_csv('M1.csv')


# Consumer Sentiment Index - University of Michigan
Consumer_Sentiment = nasdaqdatalink.get('UMICH/SOC1')
Consumer_Sentiment.to_csv('Consumer_sentiment.csv')

# Real Median Household Income in the United States
MEHOINUSA672N = nasdaqdatalink.get('FRED/MEHOINUSA672N')
MEHOINUSA672N.to_csv('MEHOINUSA672N.csv')

# Real Disposable Personal Income
DSPIC96 = nasdaqdatalink.get('FRED/DSPIC96')
DSPIC96.to_csv('DSPIC96.csv')

# Personal Consumption Expenditures * not matching**
PCE = nasdaqdatalink.get('FRED/PCE')
PCE.to_csv('PCE.csv')

# 	Federal Debt: Total Public Debt
GFDEBTN = nasdaqdatalink.get('FRED/GFDEBTN')
GFDEBTN.to_csv('GFDEBTN.csv')

# MULTPL/SHILLER_PE_RATIO_YEAR

Shiller_PE = nasdaqdatalink.get('MULTPL/SHILLER_PE_RATIO_MONTH')
Shiller_PE.to_csv('Shiller_PE.csv')

# Domestic Producer Prices Index: Manufacturing for the United States
GFDEBTN = nasdaqdatalink.get('FRED/GFDEBTN')
GFDEBTN.to_csv('GFDEBTN.csv')

# S&P 20 datapoints???
SP = nasdaqdatalink.get('BCIW/_INX')

# New orders for consumer goods and materials
new_order_consumer_goods = nasdaqdatalink.get('FRED/UCDGNO')

new_order_durable_goods = nasdaqdatalink.get('FRED/ACDGNO')

# Total Business Inventories
Total_Biz_Inv = nasdaqdatalink.get('FRED/TOTBUSIMNSA')

# PPI Producer Price Index for All Commodities
PPI = nasdaqdatalink.get('FRED/PPIACO')


# New Privately-Owned Housing Units Authorized in Permit-Issuing Places: Total Units
house_permit = nasdaqdatalink.get('FRED/PERMIT')

# Government total expenditures
Gov_tot_expenditures = nasdaqdatalink.get('FRED/W068RCQ027SBEA')

# Trade Balance: Goods and Services, Balance of Payments Basis
Trade_Balance = nasdaqdatalink.get('FRED/BOPGSTB')

# Industrial Production: Total Index
Industrial_output = nasdaqdatalink.get('FRED/INDPRO')

# average weekly hour quarterly change
AVE_WK_HR = nasdaqdatalink.get('FRED/PRS85006023')

# test Alphavantage API
import requests

# exchange rate 20 years  EURO to USD
url_exchange_rate = 'https://www.alphavantage.co/query?function=FX_DAILY&from_symbol=EUR&to_symbol=USD&outputsize=full&apikey=C6BQMN0FDSBEZDO4'
r = requests.get(url_exchange_rate)
exchange_rate = r.json()

# CPI 90 years
url_CPI = 'https://www.alphavantage.co/query?function=CPI&interval=monthly&apikey=C6BQMN0FDSBEZDO4'
r = requests.get(url_CPI)
CPI = r.json()

# cryptocurrencies
url_Bitcoin = 'https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_DAILY&symbol=BTC&market=USD&apikey=C6BQMN0FDSBEZDO4'
r = requests.get(url_Bitcoin)
Bitcoin = r.json()

# Retail sales
url_Retail_sales = 'https://www.alphavantage.co/query?function=RETAIL_SALES&apikey=C6BQMN0FDSBEZDO4'
r = requests.get(url_Retail_sales)
Retail_sales = r.json()

# nonfarm payroll
url_nonfarm = 'https://www.alphavantage.co/query?function=NONFARM_PAYROLL&apikey=C6BQMN0FDSBEZDO4'
r = requests.get(url_nonfarm)
nonfarm = r.json()

# REAL_GDP
url_REAL_GDP = 'https://www.alphavantage.co/query?function=REAL_GDP&interval=quarterly&apikey=C6BQMN0FDSBEZDO4'
r = requests.get(url_REAL_GDP)
REAL_GDP = r.json()