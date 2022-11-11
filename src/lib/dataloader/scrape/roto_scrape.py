from time import sleep
from random import randint
from bs4 import BeautifulSoup
from tqdm import tqdm
import pandas as pd
import requests
import os
import io


### Scrape rotoguru1.com for draftkings, or fanduel, player salaries and save to csv
### Historical data for testing

encoding = 'ISO-8859-1'


def get_soup(
    url: str,
) -> BeautifulSoup:
    BASE_DIR="src/data/page_cache/"
    if not os.path.exists(BASE_DIR):
        os.makedirs(BASE_DIR)
    url_hash=url.replace("/","").replace(":","").replace("?","").replace(".","")
    try:
        with open(BASE_DIR+url_hash, "r", encoding=encoding,errors='ignore') as file:
            return BeautifulSoup(file.read(), "html.parser")
    except FileNotFoundError:
        sleep(randint(2,7))
        html_data = requests.get(url, headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"}).text
        soup_data = BeautifulSoup(html_data, "html.parser")
        with open(BASE_DIR+url_hash, "w", encoding=encoding,errors='ignore') as file:
            file.write(html_data)
        return soup_data
    except RuntimeError:
        print(RuntimeError)


def get_all_games() -> pd.DataFrame:
    BASE_URL = 'http://rotoguru1.com/cgi-bin/hyday.pl?game=dk&scsv=1&mon=MONTH&day=DAY&year=YEAR'
    MONTHS = list(map(str,range(1,13)))
    DAYS = list(map(str,range(1,32)))
    YEARS = list(map(str,range(2015,2017)))

    all_games = []
    for mon in tqdm(MONTHS):
        for day in DAYS:
            for yr in YEARS:
                soup: BeautifulSoup = get_soup(BASE_URL.replace('MONTH',mon).replace('DAY',day).replace('YEAR',yr))
                df = pd.read_csv(io.StringIO(soup.find("pre").text),sep=";")
                df = df.iloc[:-1]
                df = df.loc[:,['Date','Name','DK Salary']]
                all_games.append(df)
    
    return pd.concat(all_games)


def sal_preprocess(
    df: pd.DataFrame
):
    df = df[~df.Date.str.contains('file transm')]
    df = df[~df.Date.str.contains('For the')]
    df = df.iloc[:,:4]
    df['Date'] = pd.to_datetime(df['Date'])
    df = df.set_index('Date')
    df['DK Salary'] = df['DK Salary'].str.replace(r'\D','')
    df = df.loc[(df.index > '10-27-2015') & (df.index < '06-19-2016')]
    df = df.dropna(how='any')
    df.to_csv('dk_sal.csv')


if __name__ == "__main__":
    df: pd.DataFrame = get_all_games()
    sal_preprocess(df)
