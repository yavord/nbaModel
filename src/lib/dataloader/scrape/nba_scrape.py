from selenium import webdriver
# from selenium.webdriver.support.ui import Select
# from selenium.webdriver.support.ui import WebDriverWait
# from selenium.webdriver.support import expected_conditions as EC
# from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup
import pandas as pd
from time import sleep
import re
import os


cwd = os.getcwd()


driver = webdriver.Firefox()
#statsDF = pd.DataFrame()
timeout = 30



url = r"https://www.nba.com/stats/gamebooks/?Date=02%2F08%2F2021"
driver.get(url)
sleep(5)



#This gets all of the links to each day of games. The Sleep ranges can probably be adjusted, but NBA.com is very IP-ban-happy.
#This could be more efficient by actually getting each of the individual game links from this page
#but it felt easier to just get all of the main links and then iterate through them again in the next section
#obviously very redundant.
listOfMainLinks = []
for i in range(13):
    sleep(5)
    nba_button = driver.find_element_by_xpath("/html/body/main/div/div/div[2]/div/div/div[1]/div[1]/div/div[1]/div/i[1]")
    nba_button.click()
    listOfMainLinks.append(driver.current_url)



#Get all of the links for individual game pages.
print("Getting links for individual games")
listOfAllLinks = []
for links in listOfMainLinks:
    url = f"{links}"
    driver.get(url)
    sleep(5)
    src = driver.page_source
    parser = BeautifulSoup(src, "html")
    tables = parser.find('tbody')
    if tables == None:
        continue
    headers = tables.findAll('a', href=True)
    headerlist = [h.text.strip() for h in headers[1:]]
    for a in headers:
        listOfAllLinks.append(a['href'])

correctLinks = [a for a in listOfAllLinks if "box-score" in a]
#print(correctLinks)



#go through all of the individual links to individual games and pull all of the players stats.
print("Getting player stats")
statsDF = pd.DataFrame()

for links in correctLinks:
    url = f"https://www.nba.com{links}"
    driver.get(url)
    sleep(5)

    for j in range(2):
 #get webpage
        src = driver.page_source
        parser = BeautifulSoup(src, "html")
        #find all tables on page (2)
        tables = parser.find('body').find_all('table')
        #find all headers and strip extraneous html
        headers = tables[j].findAll('th')
        headerlist = [h.text.strip() for h in headers]
        #find all rows strip first and last row
        rows = tables[j].findAll('tr')[1:]
        rows = rows[:(len(rows)-1)]
        #try to get rid of players that didn't play, but fail at it.
        properRows = [a for a in rows if "None" in a]
        #strip extraneous html and add to master dataframe
        player_stats = [[td.getText().strip() for td in rows[i].findAll('td')] for i in range(len(rows))]
        stats = pd.DataFrame(player_stats, columns=headerlist)
        index = 0
        #This will eventually have to updated with additional months. Sure I could've done this from the start
        #but I made this in january when february seemed like a lifetime away
        date = parser.find("title")
        strList = ['Jan', 'Feb', 'Dec']
        matchDate = date.text.strip()
        x = re.split("(Jan|Feb|Dec|NBA.com|2021|2020)", matchDate)
        stats['DATE'] = x[1] + x[2] + x[3]
        stats['MATCHUP'] = x[0]


 #sometimes a player has their position attached to their name so remove it
        for x in stats['PLAYER']:
            index += 1
            if x[len(x)-1].isupper():
                stats.loc[index-1, 'PLAYER'] = x[:-1]
        statsDF = statsDF.append(stats)


statsDF = statsDF.dropna()


# statsDF.tail()


# this updates the previous stats file. If you don't already have a stats file, this isn't necessary.
# obviously has to be changed to your local repository.
# df = pd.read_excel(r"/home/yavor/projects/PythonProjects/nba/DailyGameLogs/stats.xlsx")

# statsDF



# df


# dfres = statsDF.append(df)


# to get rid of the list indexes created by continually appending to a previous dataframe.
# not necessary if it's the first time running this code.
# dfres = dfres.drop(['Unnamed: 0', 'Unnamed: 0'], axis=1)


# dfres



# obviously change this to your local repository
print('writing csv')
pd.DataFrame.to_csv(statsDF, f"stats.csv")
