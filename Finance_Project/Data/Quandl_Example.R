#-------------------------------------------------------------------------------
# QUANDL
#-------------------------------------------------------------------------------
#install.packages("Quandl")
library(Quandl)

#-------------------------------------------------------------------------------
# Macroeconomic data
#-------------------------------------------------------------------------------
# https://data.nasdaq.com/data/FRED-federal-reserve-economic-data/documentation
# GDP      = Gross Domestic Product
# CPIAUCSL = Consumer Price Index for All Urban Consumers: All Items 
# UNRATE   = Civilian Unemployment Rate
# TCU = Capacity Utilization: Total Industry

Quandl.api_key("9aKMYc6XUnLgxw4hS1kM")

macrodata = Quandl(c("FRED/GDP","FRED/CPIAUCSL","FRED/UNRATE", "FRED/TCU", "OPEC/ORB"))
tail(macrodata)


#-------------------------------------------------------------------------------
# Stock index data
#-------------------------------------------------------------------------------
#https://data.nasdaq.com/data/BCIW-barchart-global-index-prices

# S&P500 index
sp500 <- Quandl("BCIW/_INX", start_date="2010-01-01", end_date=Sys.Date())
head(sp500)

nasdaq <- Quandl("BCIW/_NASX")
head(nasdaq)

sp500 <- Quandl("MULTPL/SP500_REAL_PRICE_MONTH", start_date="1982-06-25")
plot(sp500)

sp500$change <- 

str(sp500)
tail(sp500)


#-------------------------------------------------------------------------------
# S&P500 index details
#-------------------------------------------------------------------------------
# https://data.nasdaq.com/data/MULTPL-sp-500-ratios
# S&P 500 PE ratio
plot(Quandl("MULTPL/SP500_PE_RATIO_MONTH"))
plot(Quandl("MULTPL/SHILLER_PE_RATIO_YEAR", start_date='1990-01-01'))

# S&P 500 divident yild and book value
plot(Quandl("MULTPL/SP500_DIV_YIELD_YEAR", start_date='1990-01-01'))
plot(Quandl("MULTPL/SP500_PBV_RATIO_QUARTER", start_date='1990-01-01'))


#-------------------------------------------------------------------------------
# Combining data
#-------------------------------------------------------------------------------
# Merging macrodata and SP500
df <- merge(macrodata, sp500,by="Date")
tail(df)
