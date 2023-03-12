# setwd('src/lib/dataloader/')
source('scrape/south_scrape_funct.R')

### Constants
SEASON <- 2023

### Read files
team_abrev <- read.csv('../../data/team_abbreviations.csv', header=FALSE)[,2]
stopifnot(length(team_abrev)==30)

### Run GET requests
Defenses.All <- GetDefensesAll(team_abrev, SEASON)

