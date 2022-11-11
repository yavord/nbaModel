library(tidyverse)
library(readxl)
library(lubridate)

df <- read_excel('../data/stats.xlsx')

# convert 'MIN' to seconds
minToSec <- function(x) {
  toHms <- paste("00:",x,sep="")
  return(period_to_seconds(hms(toHms)))
}
df[3] <- df[3] %>% map(minToSec)

# select numeric vars and write to csv
df_numeric <- df[, c(3:22)]
df_numeric <- mutate_all(df_numeric, 
                         function(x) as.numeric(as.character(x)))

write_csv(df_numeric, "../data/stats_numeric_R.csv")
