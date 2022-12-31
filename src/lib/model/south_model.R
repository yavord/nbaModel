library(plyr)
library(arm)
library(R2OpenBUGS)
# library(rbugs)

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


### get daily predictions from daily.pred.data lists
pred.1day <- function(day.index=1)
{
  Game.Date <- All.Dates[day.index]
  salaries.today <- subset(Salaries.All, Date==Game.Date)
  model.data.all2 <- daily.pred.data[[day.index]]

  ##Create a vector of all names in this data
  name.list.current <- unique(model.data.all2$Name)

  ##Find the number of games played prior to desired prediction day
  game.count.current <- numeric(0)
  team.current <- numeric(0)
  for(j in 1:length(name.list.current))
  {
    player.temp <- subset(model.data.all2, Name==name.list.current[j])
    game.count.current[j] <- nrow(player.temp)
    team.current[j] <- as.character(player.temp$Tm[nrow(player.temp)])
  }

  ##Create a data frame of names and game counts
  game.count.current <- data.frame(name.list.current, game.count.current, team.current)
  game.count.current <- subset(game.count.current, game.count.current>2)

  fp <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
  fp.10 <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
  gs <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
  tov.10 <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
  drb.10 <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
  fta.10 <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
  fga.10 <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
  opp.clus1 <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
  opp.clus2 <- matrix(nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))

  for(m in 1:nrow(game.count.current))
  {

    ##Subsets the data by player
    player.temp <- subset(model.data.all2, Name==game.count.current[m,1])

    ##Fill in the matrices using data
    fp[m,] <- c(player.temp[,17], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
    fp.10[m,] <- c(player.temp[,55], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
    gs[m,] <- c(player.temp[,8], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
    tov.10[m,] <- c(player.temp[,37], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
    drb.10[m,] <- c(player.temp[,32], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
    fta.10[m,] <- c(player.temp[,29], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
    fga.10[m,] <- c(player.temp[,23], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
    opp.clus1[m,] <- c(player.temp[,98], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
    opp.clus2[m,] <- c(player.temp[,97], rep(NA, max(game.count.current[,2]-nrow(player.temp))))
  }

  n <- nrow(fp)
  game.count <- game.count.current[,2]
  y <- fp
  x1 <- fp.10
  x3 <- gs
  x4 <- tov.10
  x5 <- drb.10
  x6 <- fta.10
  x7 <- fga.10
  x8 <- opp.clus1
  x9 <- opp.clus2
  data <- list("n", "game.count", "y", "x1", "x3", "x4", "x5", "x6", "x7", "x8", "x9")
  inits<-function(){list(u0=-12, u1=.9, u3=1, u4=1, u5=1, u6=1, u7=1, u8=1, u9=1, tau0=1, tau1=1,
                         tau3=1, tau4=1, tau5=1, tau6=1, tau7=1, tau8=1, tau9=1, tausq=rep(1, n))}
  parameters <- c("y", "u0", "u1", "u3", "u4", "u5", "u6", "u7", "u8", "u9", "tau0", "tau1",
                  "tau3", "tau4", "tau5", "tau6", "tau7", "tau8", "tau9", "tausq")
  model <- bugs(data, inits, parameters, paste0(data_dir,'lasso_ind_all_indicator.txt'),
                n.chains=1, debug=FALSE, n.iter=11000, n.burnin=1000,
                working.directory = getwd(),
  )

  daily.predictions <- model$summary[1:nrow(model$mean$y),1:2]
  game.count.current$player.var <- 1/model$mean$tausq
  colnames(game.count.current)[1] <- 'Name.Final'

  ##Traces prediction indices back to player names
  row.search <- rownames(daily.predictions)
  row.search1 <- gsub("y","",row.search)
  row.search2 <- gsub("\\[|\\]", "", row.search1)
  row.search3 <- unlist(strsplit(row.search2, ","))[seq(1,length(row.search2)*2,2)]
  row.index <- as.numeric(row.search3)

  ##Final matrix of predictions
  prediction.today <- data.frame(Date=rep(Game.Date, nrow(model$mean$y)), daily.predictions, Name.Final=game.count.current[row.index,1])

  salaries.today.keep <- salaries.today[,c(2, 1, 3)]
  prediction.salary.today <- join(prediction.today, salaries.today.keep)
  prediction.salary.today <- subset(prediction.salary.today, Salary>0)
  colnames(prediction.salary.today)[2:3] <- c('daily.predictions', 'pred.sd')
  colnames(model.data.all2)[1] <- 'Name.Final'
  prediction.salary.today2 <- join(prediction.salary.today, game.count.current[,c(1,3)])
  colnames(prediction.salary.today2)[7] <- 'Tm'

  return((list(prediction.salary.today2, model, game.count.current)))
}


### Get predictions ready for permutation
lineup.1day <- function(input.data=pred.today, cut1=50000, cut2=50000)
{
  prediction.salary.today <- input.data[[1]]
  Game.Date <- unique(prediction.salary.today[,1])
  game.count.current <- input.data[[3]]
  
  prediction.salary.today$Name.Final <- as.character(prediction.salary.today$Name.Final)
  prediction.salary.today$Position <- as.character(prediction.salary.today$Position)
  
  teams.all.temp <- subset(Teams.All, Date==Game.Date)  #TODO: remove Teams.All
  teams.all.temp2 <- teams.all.temp[,c(1,3,43)]  #TODO: Teams.All
  colnames(teams.all.temp2)[1] <- 'Name.Final'
  teams.all.temp0 <- subset(teams.all.temp, G==0)[,1]
  prediction.salary.today <- prediction.salary.today[-which(prediction.salary.today$Name.Final %in% teams.all.temp0),]
  
  ifelse(nrow(prediction.salary.today)<110, prediction.salary.today.final <- prediction.salary.today,
         prediction.salary.today.final <- subset(prediction.salary.today, daily.predictions>quantile(prediction.salary.today[,2], 1-110/nrow(prediction.salary.today))))
  
  prediction.salary.today.final2 <- join(prediction.salary.today.final, game.count.current[,c(1,4)])
  prediction.salary.today.final2$total.var <- prediction.salary.today.final2$pred.sd^2 + prediction.salary.today.final2$player.var
  
  permute.test <- prediction.salary.today.final2
  permute.test <- join(permute.test, teams.all.temp2)
  
  ###########
  ##First 5##
  ###########
  
  PG <- permute.test[permute.test[,5]=="PG",]
  SG <- permute.test[permute.test[,5]=="SG",]
  SF <- permute.test[permute.test[,5]=="SF",]
  PF <- permute.test[permute.test[,5]=="PF",]
  C <- permute.test[permute.test[,5]=="C",]
  G <- rbind(PG,SG)
  F <- rbind(SF,PF)
  UTIL <- rbind(PG,SG,SF,PF,C)
  
  Names <- expand.grid(PG[,4],SG[,4],SF[,4],PF[,4],C[,4])
  Salaries <- expand.grid(PG[,6],SG[,6],SF[,6],PF[,6],C[,6])
  Projections <- expand.grid(PG[,2],SG[,2],SF[,2],PF[,2],C[,2])
  Actual <- expand.grid(PG[,10],SG[,10],SF[,10],PF[,10],C[,10])
  Total.SD <- expand.grid(PG[,9],SG[,9],SF[,9],PF[,9],C[,9])
  Output <- cbind(Names,rowSums(Salaries),rowSums(Projections), rowSums(Actual), rowSums(Total.SD))
  colnames(Output) <- c('PG','SG','SF','PF','C','Salary','Projection','Actual','Total.SD')
  
  rm(list=c("Names","Salaries","Projections","Actual","Total.SD"))
  gc()
  
  salary.up <- 41000
  salary.lo <- 17500
  Output <- Output[Output[,6]<=salary.up,]
  Output <- Output[Output[,6]>salary.lo,]
  
  non.duplicates <- which(!duplicated(round(Output[,7],5))==T)
  Output <- Output[non.duplicates,]
  
  Output$Prob <- 1-pnorm(q=162.5, mean=Output[,7], sd=sqrt(Output[,9]))
  
  projection.base <- quantile(Output[,10],(1-cut1/nrow(Output)))
  
  Output <- Output[Output[,10]>=projection.base,]
  
  gc()
  
  #########
  ##Add G##
  #########
  
  NamesPGN <- expand.grid(Output[,1],G[,4])
  NamesPG.N <- NamesPGN[,1]
  NamesG.N <- NamesPGN[,2]
  NamesSG.N <- expand.grid(Output[,2],G[,4])[,1]
  NamesSF.N <- expand.grid(Output[,3],G[,4])[,1]
  NamesPF.N <- expand.grid(Output[,4],G[,4])[,1]
  NamesC.N <- expand.grid(Output[,5],G[,4])[,1]
  Salaries.N <- expand.grid(Output[,6],G[,1])[,1]
  Projections.N <- expand.grid(Output[,7],G[,1])[,1]
  Actual.N <- expand.grid(Output[,8],G[,1])[,1]
  Total.SD.N <- expand.grid(Output[,9],G[,1])[,1]
  NewSalaries.N <- expand.grid(Output[,1],G[,6])[,2]
  NewProjections.N <- expand.grid(Output[,1],G[,2])[,2]
  NewActual.N <- expand.grid(Output[,1],G[,10])[,2]
  NewTotal.SD.N <- expand.grid(Output[,1],G[,9])[,2]
  
  Output <- data.frame(NamesPG.N,NamesSG.N,NamesSF.N,NamesPF.N,NamesC.N,NamesG.N,
                       (Salaries.N+NewSalaries.N),(Projections.N+NewProjections.N),(Actual.N+NewActual.N),(Total.SD.N+NewTotal.SD.N))
  
  rm(list=c("NamesSG.N","NamesSF.N","NamesPF.N","NamesC.N","Salaries.N",
            "Projections.N","Actual.N","NewSalaries.N","NewProjections.N","NewActual.N","Total.SD.N","NewTotal.SD.N"))
  gc()
  
  salary.lim.N <- 44000
  salary.low <- 25000
  Output <- Output[Output[,7]>=salary.low,]
  Output <- Output[Output[,7]<=salary.lim.N,]
  Output <- Output[as.character(Output[,1])!=as.character(Output[,6]),]
  Output <- Output[as.character(Output[,2])!=as.character(Output[,6]),]
  
  non.duplicates <- which(!duplicated(round(Output[,8],5))==T)
  Output <- Output[non.duplicates,]
  
  Output$Prob <- 1-pnorm(q=195, mean=Output[,8], sd=sqrt(Output[,10]))
  
  projection.base.N <- quantile(Output[,11],(1-cut1/nrow(Output)))
  
  Output <- Output[Output[,11]>=projection.base.N,]
  colnames(Output) <- c('PG','SG','SF','PF','C','G','Salary','Projection','Actual', "Total SD", "Prob")
  
  gc()
  
  #########
  ##Add F##
  #########
  
  NamesPG.N <- expand.grid(Output[,1],F[,4])[,1]
  NamesSG.N <- expand.grid(Output[,2],F[,4])[,1]
  NamesSF.N <- expand.grid(Output[,3],F[,4])[,1]
  NamesPF.N <- expand.grid(Output[,4],F[,4])[,1]
  NamesC.N <- expand.grid(Output[,5],F[,4])[,1]
  NamesG.N <- expand.grid(Output[,6],F[,4])[,1]
  NamesF.N <- expand.grid(Output[,1],F[,4])[,2]
  Salaries.N <- expand.grid(Output[,7],F[,2])[,1]
  Projections.N <- expand.grid(Output[,8],F[,2])[,1]
  Actual.N <- expand.grid(Output[,9],F[,2])[,1]
  Total.SD.N <- expand.grid(Output[,10],F[,2])[,1]
  NewSalaries.N <- expand.grid(Output[,1],F[,6])[,2]
  NewProjections.N <- expand.grid(Output[,1],F[,2])[,2]
  NewActual.N <- expand.grid(Output[,1],F[,10])[,2]
  NewTotal.SD.N <- expand.grid(Output[,1],F[,9])[,2]
  
  Output <- data.frame(NamesPG.N,NamesSG.N,NamesSF.N,NamesPF.N,NamesC.N,NamesG.N,NamesF.N,
                       (Salaries.N+NewSalaries.N),(Projections.N+NewProjections.N),(Actual.N+NewActual.N),(Total.SD.N+NewTotal.SD.N))
  
  rm(list=c("NamesPG.N","NamesSG.N","NamesSF.N","NamesPF.N","NamesC.N",
            "NamesG.N","NamesF.N","Salaries.N","Projections.N","Actual.N",
            "NewSalaries.N","NewProjections.N","NewActual.N","Total.SD.N","NewTotal.SD.N"))
  gc()
  
  salary.lim.N <- 47000
  salary.low <- 35000
  Output <- Output[Output[,8]>=salary.low,]
  Output <- Output[Output[,8]<=salary.lim.N,]
  Output <- Output[as.character(Output[,3])!=as.character(Output[,7]),]
  Output <- Output[as.character(Output[,4])!=as.character(Output[,7]),]
  
  non.duplicates <- which(!duplicated(round(Output[,9],5))==T)
  Output <- Output[non.duplicates,]
  
  Output$Prob <- 1-pnorm(q=227.5, mean=Output[,9], sd=sqrt(Output[,11]))
  
  projection.base.N <- quantile(Output[,12],(1-cut2/nrow(Output)))
  
  Output <- Output[Output[,12]>=projection.base.N,]
  colnames(Output) <- c('PG','SG','SF','PF','C','G','F','Salary','Projection','Actual','Total SD','Prob')
  
  gc()
  
  ############
  ##Add UTIL##
  ############
  
  NamesPG.N <- expand.grid(Output[,1],UTIL[,4])[,1]
  NamesSG.N <- expand.grid(Output[,2],UTIL[,4])[,1]
  NamesSF.N <- expand.grid(Output[,3],UTIL[,4])[,1]
  NamesPF.N <- expand.grid(Output[,4],UTIL[,4])[,1]
  NamesC.N <- expand.grid(Output[,5],UTIL[,4])[,1]
  NamesG.N <- expand.grid(Output[,6],UTIL[,4])[,1]
  NamesF.N <- expand.grid(Output[,7],UTIL[,4])[,1]
  NamesUTIL.N <- expand.grid(Output[,1],UTIL[,4])[,2]
  Salaries.N <- expand.grid(Output[,8],UTIL[,2])[,1]
  Projections.N <- expand.grid(Output[,9],UTIL[,2])[,1]
  Actual.N <- expand.grid(Output[,10],UTIL[,2])[,1]
  Total.SD.N <- expand.grid(Output[,11],UTIL[,2])[,1]
  NewSalaries.N <- expand.grid(Output[,1],UTIL[,6])[,2]
  NewProjections.N <- expand.grid(Output[,1],UTIL[,2])[,2]
  NewActual.N <- expand.grid(Output[,1],UTIL[,10])[,2]
  NewTotal.SD.N <- expand.grid(Output[,1],UTIL[,9])[,2]
  
  Output <- data.frame(NamesPG.N,NamesSG.N,NamesSF.N,NamesPF.N,NamesC.N,NamesG.N,NamesF.N,
                       NamesUTIL.N,(Salaries.N+NewSalaries.N),(Projections.N+NewProjections.N),(Actual.N+NewActual.N),(Total.SD.N+NewTotal.SD.N))
  
  rm(list=c("NamesPG.N","NamesSG.N","NamesSF.N","NamesPF.N","NamesC.N",
            "NamesG.N","NamesF.N","NamesUTIL.N","Salaries.N","Projections.N","Actual.N",
            "NewSalaries.N","NewProjections.N","NewActual.N","Total.SD.N","NewTotal.SD.N"))
  gc()
  
  salary.lim.N <- 50000
  Output <- Output[Output[,9]<=salary.lim.N,]
  Output <- Output[as.character(Output[,1])!=as.character(Output[,8]),]
  Output <- Output[as.character(Output[,2])!=as.character(Output[,8]),]
  Output <- Output[as.character(Output[,3])!=as.character(Output[,8]),]
  Output <- Output[as.character(Output[,4])!=as.character(Output[,8]),]
  Output <- Output[as.character(Output[,5])!=as.character(Output[,8]),]
  Output <- Output[as.character(Output[,6])!=as.character(Output[,8]),]
  Output <- Output[as.character(Output[,7])!=as.character(Output[,8]),]
  
  Output$Prob <- 1-pnorm(q=260, mean=Output[,10], sd=sqrt(Output[,12]))
  
  colnames(Output) <- c('PG','SG','SF','PF','C','G','F','UTIL','Salary','Projection','Actual','Total SD','Prob')
  
  non.duplicates <- which(!duplicated(round(Output[,10],5))==T)
  Output <- Output[non.duplicates,]
  
  Output.Sorted <- Output[order(Output[,13],decreasing=T),]
  Output.Sorted.Final <- Output.Sorted[1:1000,]
  Output.Sorted.Final$Date <- Game.Date
  
  rm(list=c("Output","Output.Sorted"))
  gc()
  
  return(Output.Sorted.Final)
}


### get opponent median difference
opp.median.over.time <- function(day.index=1)
{
  dates <- as.Date(daily.pred.data[[day.index]]$Date)
  dates <- unique(dates[order(dates)])
  n <- length(dates)-1
  daily.opp.median <- vector('list', n)
  
  for(i in 1:n)
  {
    data.temp <- subset(daily.pred.data[[day.index]], Date<dates[i+1])
    data.temp$fantasy.dif <- data.temp$fantasy-data.temp$fantasy.10
    opp.median.data <- aggregate(data.temp$fantasy.dif ~ data.temp$Opp, FUN=median)
    daily.opp.median[[i]] <- data.frame(Date=dates[i+1], Opp=opp.median.data[,1],
                                        Median.Fantasy.Dif=opp.median.data[,2])
  }
  return(daily.opp.median)
}


### get stats
var.addition <- function(all.variable.list, lineups.1day, third.join1=third.join)
{
  test.permute <- lineups.1day
  
  #variable.list <- c(56, 95, 104, 105, 106)
  variable.list <- all.variable.list
  
  lineups.temp <- vector('list', (length(variable.list)+1))
  lineups.temp[[1]] <- lineups.1day
  
  for(j in 1:length(variable.list))
  {
    
    rename.data <- function(position)
    {
      temp.data <- third.join1[,c(1, 4, variable.list[j])]
      old.name <- colnames(temp.data)[3]
      names(temp.data)[names(temp.data)=="Name.Final"] <- position
      names(temp.data)[3] <- paste(position,old.name, sep="_")
      return(temp.data)
    }
    PG.rename <- rename.data("PG")
    SG.rename <- rename.data("SG")
    SF.rename <- rename.data("SF")
    PF.rename <- rename.data("PF")
    C.rename <- rename.data("C")
    G.rename <- rename.data("G")
    F.rename <- rename.data("F")
    UTIL.rename <- rename.data("UTIL")
    
    test.merge1 <- join(test.permute, PG.rename)
    test.merge2 <- join(test.merge1, SG.rename)
    test.merge3 <- join(test.merge2, SF.rename)
    test.merge4 <- join(test.merge3, PF.rename)
    test.merge5 <- join(test.merge4, C.rename)
    test.merge6 <- join(test.merge5, G.rename)
    test.merge7 <- join(test.merge6, F.rename)
    test.merge <- join(test.merge7, UTIL.rename)
    
    test.merge$unweight.new <- rowMeans(test.merge[,c(15:22)])
    test.merge.short <- test.merge[,c(1:14, 23)]
    names(test.merge.short)[names(test.merge.short)=="unweight.new"] <- paste("unweight", colnames(third.join)[variable.list[j]], sep=".")
    lineups.temp[[j+1]] <- join(lineups.temp[[j]], test.merge.short)
  }
  
  lineup.1516.all.var <- lineups.temp[[length(lineups.temp)]]
  
  return(lineup.1516.all.var)
}


### Calls everything needed for 1 day
### 2 Outputs:
### daily predictions and OpenBUGS results
### lineups with lineup level stats

full.1day.stuff <- function(day=1, cut1.value=50000, cut2.value=50000)
{
  
  pred.today <- pred.1day(day.index=day)
  lineup.today <- lineup.1day(input.data=pred.today, cut1=cut1.value, cut2=cut2.value)
  
  matchup.hm <- Matchup.History[,c(1, 2, 4, 5)]  #TODO: remove Matchup.History
  colnames(matchup.hm)[2] <- 'Tm'
  matchup.away <- Matchup.History[,c(1, 3, 4, 5)]
  colnames(matchup.away)[2] <- 'Tm'
  matchup.all <- rbind(matchup.hm, matchup.away)
  matchup.all[,1] <- as.Date(matchup.all[,1], "%m/%d/%Y")
  colnames(matchup.all)[1] <- 'Date'
  
  pred.salary.vegas <- join(pred.today[[1]], matchup.all)
  
  
  opp.median.over.time <- function(day.index=1)
  {
    dates <- as.Date(daily.pred.data[[day.index]]$Date)
    dates <- unique(dates[order(dates)])
    n <- length(dates)-1
    daily.opp.median <- vector('list', n)
    
    for(i in 1:n)
    {
      data.temp <- subset(daily.pred.data[[day.index]], Date<dates[i+1])
      data.temp$fantasy.dif <- data.temp$fantasy-data.temp$fantasy.10
      opp.median.data <- aggregate(data.temp$fantasy.dif ~ data.temp$Opp, FUN=median)
      daily.opp.median[[i]] <- data.frame(Date=dates[i+1], Opp=opp.median.data[,1],
                                          Median.Fantasy.Dif=opp.median.data[,2])
    }
    return(daily.opp.median)
  }
  opp.results.2015 <- opp.median.over.time(day.index=day)
  opp.clust.2015.new <- rbind.fill(opp.results.2015)
  opp.clust.2015.new <- subset(opp.clust.2015.new, Date>'2015-11-10')
  second.join <- join(opp.clust.2015.new, daily.pred.data[[day]])
  colnames(second.join)[4] <- 'Name.Final'
  third.join <- join(second.join, pred.salary.vegas)
  third.join$value <- third.join$daily.predictions/third.join$Salary*1000
  
  test.permute <- lineup.today
  
  variable.list <- c(56, 95, 104, 105, 106)
  
  lineups.temp <- vector('list', (length(variable.list)+1))
  lineups.temp[[1]] <- lineup.today
  
  for(j in 1:length(variable.list))
  {
    
    rename.data <- function(position)
    {
      temp.data <- third.join[,c(1, 4, variable.list[j])]
      old.name <- colnames(temp.data)[3]
      names(temp.data)[names(temp.data)=="Name.Final"] <- position
      names(temp.data)[3] <- paste(position,old.name, sep="_")
      return(temp.data)
    }
    PG.rename <- rename.data("PG")
    SG.rename <- rename.data("SG")
    SF.rename <- rename.data("SF")
    PF.rename <- rename.data("PF")
    C.rename <- rename.data("C")
    G.rename <- rename.data("G")
    F.rename <- rename.data("F")
    UTIL.rename <- rename.data("UTIL")
    
    test.merge1 <- join(test.permute, PG.rename)
    test.merge2 <- join(test.merge1, SG.rename)
    test.merge3 <- join(test.merge2, SF.rename)
    test.merge4 <- join(test.merge3, PF.rename)
    test.merge5 <- join(test.merge4, C.rename)
    test.merge6 <- join(test.merge5, G.rename)
    test.merge7 <- join(test.merge6, F.rename)
    test.merge <- join(test.merge7, UTIL.rename)
    
    test.merge$unweight.new <- rowMeans(test.merge[,c(15:22)])
    test.merge.short <- test.merge[,c(1:14, 23)]
    names(test.merge.short)[names(test.merge.short)=="unweight.new"] <- paste("unweight", colnames(third.join)[variable.list[j]], sep=".")
    lineups.temp[[j+1]] <- join(lineups.temp[[j]], test.merge.short)
  }
  
  lineups.today.final <- lineups.temp[[length(lineups.temp)]]
  
  
  return(list(pred.today, lineups.today.final))
}


#TODO: run through all game days with parquet file, worth it to include GCP free?
please.work1 <- full.1day.stuff(day=101)
please.work2 <- full.1day.stuff(day=102)
lineup_block <- list(please.work1[[2]], please.work2[[2]])
