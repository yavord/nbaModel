from time import sleep
from random import randint
from bs4 import BeautifulSoup
from tqdm import tqdm
import pandas as pd
import requests
import os
import io


encoding = 'ISO-8859-1'

def get_soup(url):
    BASE_DIR="page_cache/"
    if not os.path.exists(BASE_DIR):
        os.makedirs(BASE_DIR)
    url_hash=url.replace("/","").replace(":","").replace("?","").replace(".","")
    try:
        with open(BASE_DIR+url_hash, "r", encoding=encoding,errors='ignore') as file:
            print('ok')
            return BeautifulSoup(file.read(), "html.parser")
    except FileNotFoundError:
        print(url)
        sleep(randint(2,7))
        html_data = requests.get(url, headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"}).text
        soup_data = BeautifulSoup(html_data, "html.parser")
        with open(BASE_DIR+url_hash, "w", encoding=encoding,errors='ignore') as file:
            file.write(html_data)
        return soup_data
    except RuntimeError:
        print(RuntimeError)


def get_all_games():
    BASE_URL = 'http://rotoguru1.com/cgi-bin/hyday.pl?game=dk&scsv=1&mon=MONTH&day=DAY&year=YEAR'
    MONTHS = list(map(str,range(1,13)))
    DAYS = list(map(str,range(1,32)))
    YEARS = list(map(str,range(2016,2017)))

    all_games = []
    for mon in tqdm(MONTHS):
        for day in DAYS:
            for yr in YEARS:
                soup: BeautifulSoup = get_soup(BASE_URL.replace('MONTH',mon).replace('DAY',day).replace('YEAR',yr))
                df = pd.read_csv(io.StringIO(soup.find("pre").text),sep=";")
                print(df.iloc[-1:])
                df = df.iloc[:-1]
                all_games.append(df)
    
    all_games_df = pd.concat(all_games)
    print(all_games_df)


# all_games=pd.DataFrame()
# URL = 'http://rotoguru1.com/cgi-bin/hyday.pl?game=dk&mon=10&day=27&year=2015'
# URL2 = 'http://rotoguru1.com/cgi-bin/fyday.pl?game=fd&scsv=1&week=1&year=2011'
# URL3 = 'http://rotoguru1.com/cgi-bin/hyday.pl?game=dk&scsv=1&mon=10&day=27&year=2015'
# x=get_soup(URL3)
# print(x.find('pre'))
# print(x.prettify())
# df = pd.read_csv(io.StringIO(x.find("pre").text),sep=";")
# print(df)
# all_games=pd.concat([all_games,pd.read_csv(io.StringIO(x.find("pre").text),sep=";")])
# all_games = all_games.iloc[:-1]
# print(all_games.columns)
