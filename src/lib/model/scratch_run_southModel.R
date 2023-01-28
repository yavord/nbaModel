source(paste0(getwd(),'/src/lib/model/south_model.R'))

### Load df
data_dir <- '/home/yavor/projects/multi_projects/nba/nbaModel/src/data/south_data/'

daily.pred.data <- readRDS(paste0(data_dir,'daily_pred_data_final.rds'))

Teams.All <- read.csv(paste0(data_dir,'final_1516 player2.csv'))
Defenses.All <- read.csv(paste0(data_dir,'final_1516_defense.csv'))
All.Player.Previous <- read.csv(paste0(data_dir,'All_Player_Previous2.csv'))
Salaries.All <- read.csv(paste0(data_dir,'salary_final.csv'))
Matchup.History <- read.csv(paste0(data_dir,'lines_ou.csv'))

Team.Names <- unique(Teams.All$Tm)
Teams.All$Date <- as.Date(Teams.All$Date, "%m/%d/%Y")
Defenses.All$Date <- as.Date(Defenses.All$Date, "%m/%d/%Y")
All.Player.Previous$Date <- as.Date(All.Player.Previous$Date, "%m/%d/%Y")
Salaries.All$Date <- as.Date(Salaries.All$Date, "%m/%d/%Y")
Matchup.History$Date <- as.Date(Matchup.History$Date,"%m/%d/%Y")

First.Date <- as.Date("11/16/2015","%m/%d/%Y")  #TODO: fix
All.Dates <- unique(Teams.All$Date)
All.Dates <- sort(All.Dates[All.Dates>=First.Date])


### Run full.1day.stuff over all possible game days
days <- seq(1,141)  # TODO: automate over which days to run
lineup_block <- list()
for (i in days) {
  message(i)
  gc()
  df <- tryCatch({
    full.1day.stuff(day=i)
  },
  error = function(e) {
    message("Insufficient memory, lowering cut.value")
    gc()
    full.1day.stuff(day=i, cut1.value = 50000, cut2.value = 20000)
  },
  warning = function(w) {},
  finally = {}
  )
  lineup_block <- append(lineup_block, df[2])
  gc()
}

saveRDS(lineup_block, file="lineup_block.rds")
