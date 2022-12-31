### Load data
data_dir <- '/home/yavor/projects/multi_projects/nba/nbaModel/src/data/south_data/'
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


Current.Day.Data <- function(Team=Home.Tm, date.today=Game.Date, Type='Home')
{
  Today.Data <- subset(Teams.All.Today, Tm %in% Team)
  Today.player.list <- as.vector(unique(Today.Data$Name))
  k.today <- length(Today.player.list)
  
  df.today <- data.frame(matrix(ncol = 94, nrow = 0))  #TODO: fix
  
  for(j.today in 1:k.today)
  {
    ##Subsets current data for the specified player
    player.data.today <- subset(Today.Data, Name==Today.player.list[j.today])
    player.data.today <- player.data.today[order(player.data.today[,3], decreasing=FALSE),]
    ##Pulls last row of data and keeps select statistics
    player.today <- player.data.today[nrow(player.data.today),]
    player.keep.today <- player.today[,c(1:9,13,21:25,27,43:44)]
    ##Replaces all statistics for prediction in WinBUGS with NA
    player.keep.today[,c(9:18)] <- NA
    ##Sets the correct date
    player.keep.today[,3] <- date.today
    player.keep.today[,3] <- as.Date(player.keep.today[,3])
    ##Sets correct location depending on vector of teams used
    ifelse(Type=='Home', player.keep.today[,7] <- 1, player.keep.today[,7] <- 0)
    ##Sets correct game number
    player.keep.today[,2] <- player.keep.today[,2] + 1
    ##Renames Team column for merging with matchup data
    colnames(player.keep.today)[5] <- Type
    player.keep.today2 <- join(player.keep.today, Matchups.Today)
    ##Assigns correct opponent
    player.keep.today2[,6] <- player.keep.today2[,19]
    
    ##Creates a subset of data to find moving averages
    ##If requested slice size is more than the number of games played, the average 
    ##returned is for all games played
    
    min.check.today <- nrow(player.data.today) - 10
    if (min.check.today <=0) min.today <- 1 else min.today <- (min.check.today + 1)
    player.ma.today <- player.data.today[min.today:nrow(player.data.today),]
    
    ##Find column averages of the sliced data
    
    sliced.avg.today <- colMeans(player.ma.today[,c(7:44)])
    
    ##Pulls defense data of most recent opponent averages, calculated similar to above
    
    ##Filters only data for a specific team, then orders by date
    
    team.data.today <- subset(Defenses.All.Today, Opp==as.character(player.keep.today2[,6]))
    team.data.today[,3] <- as.Date(team.data.today[,3])
    team.data.today <- team.data.today[order(team.data.today[,3], decreasing=FALSE),]
    
    ##Calculation of fantasy points allowed for each day
    
    team.data.today$fantasy.allowed <- team.data.today$Tm.PTS + .5*team.data.today$X3P + 
      1.25*team.data.today$TRB + 1.5*team.data.today$AST + 2*team.data.today$STL + 
      2*team.data.today$BLK - 0.5*team.data.today$TOV
    
    ##Cuts data so that only games prior to specified date remain
    team.temp.today <- subset(team.data.today, team.data.today$Date<player.keep.today2[,3])
    
    ##Cuts last slice.size1 rows of data for calculation of means, then finds them
    
    if(nrow(team.temp.today)-10+1 < 1) def.min.today <- 1 else def.min.today <- nrow(team.temp.today)-10+1
    def.slice.today <- team.temp.today[def.min.today:nrow(team.temp.today),]
    def.sliced.avg.today <- colMeans(def.slice.today[,7:44])
    names(def.sliced.avg.today) <- c('Pts.Allow', 'Pts.For', 'Opp.Margin',
                                     'Opp.FG', 'Opp.FGA', 'Opp.FG.', 'Opp.X3P', 'Opp.X3PA', 'Opp.X3P.',
                                     'Opp.FT', 'Opp.FTA', 'Opp.FT.', 'Opp.ORB', 'Opp.TRB', 'Opp.AST', 
                                     'Opp.STL', 'Opp.BLK', 'Opp.TOV', 'Opp.PF', 'Opp.ORtg', 'Opp.DRtg',
                                     'Opp.Pace', 'Opp.FTr', 'Opp.X3PAr', 'Opp.TS.', 'Opp.TRB.',
                                     'Opp.AST.', 'Opp.STL.', 'Opp.BLK.', 'Opp.Off.eFG.pct', 'Opp.Off.TOV.pct',
                                     'Opp.Off.ORB.pct', 'Opp.Off.FT.FGA', 'Opp.Def.eFG.pct', 'Opp.Def.TOV.pct',
                                     'Opp.Def.ORB.pct', 'Opp.Def.FT.FGA', 'Opp.fantasy.allowed')
    
    ##Combine averages with today's data
    
    player.final.today <- data.frame(player.keep.today2[,1:18], t(as.data.frame(sliced.avg.today)), t(as.data.frame(def.sliced.avg.today)))
    
    df.today[j.today,] <- t(player.final.today)
  }
  all.names.today <- c(colnames(player.keep.today2[,1:18]), names(sliced.avg.today), names(def.sliced.avg.today))
  colnames(df.today) <- all.names.today
  df.today[c(7:94)] <- sapply(df.today[c(7:94)],as.numeric)
  df.today[,3] <- as.Date(df.today[,3])
  names(df.today)[5] <- 'Tm'
  names(df.today)[19] <- 'Location.10'
  names(df.today)[20] <- 'GS.10'
  names(df.today)[21] <- 'MP.10'
  names(df.today)[25] <- 'X3P.10'
  names(df.today)[33] <- 'TRB.10'
  names(df.today)[34] <- 'AST.10'
  names(df.today)[35] <- 'STL.10'
  names(df.today)[36] <- 'BLK.10'
  names(df.today)[37] <- 'TOV.10'
  names(df.today)[39] <- 'PTS.10'
  names(df.today)[55] <- 'fantasy.10'
  names(df.today)[56] <- 'fantasy.min.10'
  
  return(df.today)
}

###################################################
###Creating list of ready-to-predict data frames###
###################################################

daily.pred.data <- vector('list', length(All.Dates))

for(i in 1:length(All.Dates))
{
  Game.Date <- All.Dates[i]
  salaries.today <- subset(Salaries.All, Date==Game.Date)
  All.Player.Previous.Today <- subset(All.Player.Previous, Date<Game.Date)
  Defenses.All.Today <- subset(Defenses.All, Date<Game.Date)
  Teams.All.Today <- subset(Teams.All, Date<Game.Date)
  Matchups.Today <- subset(Matchup.History, Matchup.History$Date==Game.Date)
  Home.Tm <- as.character(Matchups.Today$Home)
  Away.Tm <- as.character(Matchups.Today$Away)
  Today.Tm <- union(Home.Tm, Away.Tm)
  
  Home.Today <- Current.Day.Data(Team=Home.Tm, date.today=Game.Date, Type='Home')
  Away.Today <- Current.Day.Data(Team=Away.Tm, date.today=Game.Date, Type='Away')
  
  ##Creates the number of predictions to be made for use with WinBUGS results
  n.predictions <- nrow(Home.Today)+nrow(Away.Today)
  
  ##Combines all data for prediction phase
  model.data.temp <- rbind(All.Player.Previous.Today, Home.Today, Away.Today)
  
  unique.players <- unique(model.data.temp$Name)
  player.final <- vector('list', length(unique.players))
  for(k in 1:length(unique.players))
  {
    player.check <- subset(model.data.temp, Name==unique.players[k])
    player.prev <- subset(player.check, !is.na(fantasy))
    tm.current <- player.prev[nrow(player.prev),'Tm']
    if(length(which(is.na(player.check$fantasy)))>1)
    {
      player.today <- subset(subset(player.check, is.na(fantasy)), Tm==tm.current)
      player.final[[k]] <- rbind(player.prev, player.today)
    } else {player.final[[k]] <- player.check}
  }
  model.data.all <- rbind.fill(player.final)
  
  ##Finds median difference between actual and last 10 FP for each team
  data.temp <- subset(model.data.all, Date<max(Date))
  data.temp$fantasy.dif <- data.temp$fantasy-data.temp$fantasy.10
  opp.median.data <- aggregate(data.temp$fantasy.dif ~ data.temp$Opp, FUN=median)
  
  ##Assigns cluster membership based on median differences
  opp.median.data$subj.cluster <- kmeans(opp.median.data[,2], 3, nstart=20)$cluster
  clust.means <- aggregate(opp.median.data[,2]~opp.median.data$subj.cluster, FUN=mean)
  colnames(clust.means) <- c('subj.cluster', 'cluster.mean')
  clust.reorder <- data.frame(real.clust.order=1:3, cluster.mean=sort(clust.means[,2]))
  clust.final <- join(clust.means, clust.reorder)
  opp.median.data2 <- join(opp.median.data, clust.final)
  opp.median.data.join <- opp.median.data2[,c(1,5)]
  colnames(opp.median.data.join)[1] <- 'Opp'
  model.data.all2 <- join(model.data.all, opp.median.data.join)
  
  ##Creates indicator variables for cluster membership
  for(level in unique(model.data.all2$real.clust.order)){
    model.data.all2[paste("Subj.Cluster", level, sep = "_")] <- ifelse(model.data.all2$real.clust.order == level, 1, 0)}
  
  daily.pred.data[[i]] <- model.data.all2
}
