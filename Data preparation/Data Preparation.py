import json
import pandas as pd
import requests
import openpyxl
import nasdaqdatalink
import numpy as np

# load the api key

with open('api.json', 'r') as f:
    api_json = json.load(f)

api = api_json['fred_api_key']


# FRED class to obtain observations
class FRED:
    def __init__(self, token=None):
        self.token = token
        self.url = 'https://api.stlouisfed.org/fred/series/observations' \
                   '?series_id={seriesID}' \
                   '&api_key={token}&file_type=json' \
                   '&observation_start={start}&observation_end={end}&units={units}'

    def set_token(self, token):
        self.token = token

    def get_series(self, seriesID, start, end, units):

        # the url string with the values inserted into it
        url_formatted = self.url.format(seriesID=seriesID, token=self.token, start=start, end=end, units=units)
        response = requests.get(url_formatted)

        if self.token:
            # in the response was successful, extract the data from it
            if response.status_code == 200:
                data = pd.DataFrame(response.json()['observations'])[['date', 'value']] \
                    .assign(date=lambda cols: pd.to_datetime(cols['date'])) \
                    .rename(columns={'value': seriesID})

                return data

            else:
                raise Exception('Bad response from API, status code {}'.format(response.status_code))
        else:
            raise Exception('You did not specify an API Key')


variables = pd.read_excel('metadata.xlsx', 'Sheet1')
fred_vars = variables[variables['API'] == 'FRED']['FRED Code'].reset_index()
fred = FRED()
fred.set_token(api)

start_date = '1967-01-01'
end_date = '2022-03-31'

Macro_SP = pd.DataFrame(data=pd.date_range(start_date, end_date, freq='d'), columns=['date'])

# join all the fred data
for index in fred_vars['FRED Code']:
    other_var = fred.get_series(index, start_date, end_date, units='lin')
    Macro_SP = Macro_SP.merge(other_var, left_on='date', right_on='date', how='left')

# read other data from other source
nasdaqdatalink.ApiConfig.api_key = api_json['Nas_API']
Shiller_PE = nasdaqdatalink.get('MULTPL/SHILLER_PE_RATIO_MONTH').reset_index()
shiller_PE = Shiller_PE.assign(Date=lambda cols: pd.to_datetime(cols['Date'])) \
    .rename(columns={'Date': 'date', 'Value': 'shiller_PE'})

# data source: WSJ+kaggle
# kaggle : https://www.kaggle.com/datasets/henryhan117/sp-500-historical-data
# wsj : https://www.wsj.com/market-data/quotes/index/SPX/historical-prices

SP500 = pd.read_csv('SPX.csv')[['Date', 'Close']].assign(Date=lambda cols: pd.to_datetime(cols['Date'])) \
    .rename(columns={'Close': 'SP500', 'Date': 'date'})
# yahoo finance
# https://finance.yahoo.com/quote/DX-Y.NYB/history?period1=31795200&period2=1656288000&interval=1d&filter=history&frequency=1d&includeAdjustedClose=true
DXY = pd.read_csv('DX-Y.NYB.csv')[['Date', 'Close']].assign(Date=lambda cols: pd.to_datetime(cols['Date'])) \
    .rename(columns={'Close': 'DXY', 'Date': 'date'})

# join the other data
Macro_SP = Macro_SP.merge(shiller_PE, left_on='date', right_on='date', how='left')
Macro_SP = Macro_SP.merge(DXY, left_on='date', right_on='date', how='left')
Macro_SP = Macro_SP.merge(SP500, left_on='date', right_on='date', how='left')

# data cleansing
Macro_SP = Macro_SP.replace('.', np.nan)

# aggregation on quarter level by mean()
Macro_SP.loc[:, Macro_SP.columns != 'date'] = Macro_SP.loc[:, Macro_SP.columns != 'date'].astype('float')
Macro_SP_quarter = Macro_SP.groupby(pd.Grouper(key='date', freq='Q')).agg(np.nanmean)
Macro_SP_month = Macro_SP.groupby(pd.Grouper(key='date', freq='M')).agg(np.nanmean)


# forward fill nan with preceding values for monthly data
# UMCSENT still have some issues so bfill
Macro_SP_month = Macro_SP_month.fillna(method='ffill')
Macro_SP_month = Macro_SP_month.fillna(method='bfill')

# convert to Quarter on quarterly change and MoM change
Macro_SP_QoQ = Macro_SP_quarter.pct_change()
Macro_SP_QoQ = Macro_SP_QoQ.drop(index=Macro_SP_QoQ.index[0])
Macro_SP_MoM = Macro_SP_month.pct_change()
Macro_SP_MoM = Macro_SP_MoM.drop(index=Macro_SP_MoM.index[0])

# save data to CSV
Macro_SP.to_csv('Macro_SP.csv')
Macro_SP_month.to_csv("Macro_SP_month.csv")
Macro_SP_quarter.to_csv('Macro_SP_QoQ.csv')
Macro_SP_MoM.to_csv('Macro_SP_MoM.csv')
Macro_SP_QoQ.to_csv('Macro_SP_QoQ.csv')

