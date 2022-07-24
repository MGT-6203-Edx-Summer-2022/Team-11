Data Preparation.py : (1) access FRED API and NASDAQ API to pull macroeconomic index information (2) Combine the the information with some information from other sources such as yahoo finance, Wall street Journal etc (3) Data cleansing and aggragation on monthly or quarterly level (4) Conversion to perchange change MOM or QoQ. Datasets exported to CSV in Final Data Source folder.

api.json: API keys for FRED and NASDAQ link

Bin_MACRO_SP_MoM.rmd: Binning modeling

Exploratory Data Analysis.Rmd: Exploratory Data Analysis

MoM.Rmd: Month over Month dataset modeling. Includes Lag/Lead analysis.

QoQ.Rmd: Quarter over Quarter dataset modeling

requirements.txt : provide python package requirements. Rmd files include require() and will install packages if user does not have the package installed.