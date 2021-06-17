library(readxl)
library(lubridate)
library(reshape2)
library(purrr)
library(dplyr)
library(magrittr)

# import data
data <- read_xlsx("data/stats.xlsx")

# Convert min:sec to hour:min:sec to seconds
minToSec <- function(x) {
  toHms <- paste("00:",x,sep="")
  result <- period_to_seconds(hms(toHms))
  return(result)
}

# Apply to data
data_numeric <- data %>% select(c(1,3:22))
data_numeric[2] <- data_numeric[2] %>% map(minToSec)

# Make sure everything is numeric
data_numeric <- mutate_all(data_numeric, 
                           function(x) as.numeric(as.character(x)))

write.csv(data_numeric, "data/statsNumeric.csv")
