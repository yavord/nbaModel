from time import sleep
from random import randint
from bs4 import BeautifulSoup
import pandas as pd
import requests
import os
import io

encoding = 'ISO-8859-1'
def soup(url):
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


all_games=pd.DataFrame()
URL = 'http://rotoguru1.com/cgi-bin/hyday.pl?game=dk&mon=10&day=27&year=2015'
URL2 = 'http://rotoguru1.com/cgi-bin/fyday.pl?game=fd&scsv=1&week=1&year=2011'
URL3 = 'http://rotoguru1.com/cgi-bin/hyday.pl?game=dk&scsv=1&mon=10&day=27&year=2015'
x=soup(URL3)
print(x.find('pre'))
# print(x.prettify())
# all_games=pd.concat([all_games,pd.read_csv(io.StringIO(x.find("pre").text),sep=";")])
# print(all_games)
