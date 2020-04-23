import requests
import urllib.request
import pandas as pd
from bs4 import BeautifulSoup


world_url = 'https://www.worldometers.info/coronavirus/'
usa_url = 'https://www.worldometers.info/coronavirus/country/us/'
world_divs = ['main_table_countries_today', 'main_table_countries_yesterday']
usa_divs = ['usa_table_countries_yesterday', 'usa_table_countries_today']
master_df = pd.DataFrame()


def convert_url_to_df(url, div):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    results = soup.find(id=div)
    df = pd.read_html(str(results))[0]

    return df


if __name__ == '__main__':

    for div in world_divs:
        df = convert_url_to_df(world_url, div)
        df = df.iloc[:, 0:7]
        df.columns = ['Region', 'TotalCases', 'NewCases', 'TotalDeaths', 'NewDeaths', 'TotalRecovered', 'ActiveCases']
        df['type'] = div
        master_df = pd.concat([master_df, df], axis=0, ignore_index=True)
    for div in usa_divs:
        df = convert_url_to_df(usa_url, div)
        df = df.iloc[:, 0:6]
        df.columns = ['Region', 'TotalCases', 'NewCases', 'TotalDeaths', 'NewDeaths', 'ActiveCases']
        df['type'] = div
        master_df = pd.concat([master_df, df], axis=0, ignore_index=True)


    master_df.to_csv("worldometer_data.csv", index=False)
