#########################################################################
#########################################################################
###Disclaimer: please forgive any ineffencies... I do not by any means###
###consider myself an expert programmer - much of this process was    ###
###trial and error, which resulted in code that may be hard to follow ###
###Respectfully, Charles South                                        ###
#########################################################################
#########################################################################

#########################################################################
#########################################################################
###Feel free to contact the first author with any comments on the code###
###I can be reached at csouth@smu.edu                                 ###
#########################################################################
#########################################################################


library(plyr)
library(arm)
library(rbugs)
library(R2OpenBUGS)

##To duplicate, you will need to specify your working directory and the path
##of all the files below

##Information on the files:

##Teams.All: a file that contains daily player data scraped from basketball-reference.com

##Defenses.All: a file that contains team data scraped from basketball-reference.com

##All.Player.Previous: a file that contains observed statistics for the date listed, 
##as well as 10-game moving averages for most statistics for each player prior to the date
##Note that in cases where players did not have 10 games, all observed were used

##Salaries.All: salary data for DraftKings, scraped from http://rotoguru1.com/cgi-bin/hyday.pl?game=dk

##Matchup.History: line and over/under data for every game

##daily.pred.data: list of ready-to-predict data frames (the code to create it is given below)

# setwd(##Fill in here##)

Teams.All <- read.csv('##Fill in here##/final 1516 player2.csv')
Defenses.All <- read.csv('##Fill in here##/final 1516 defense.csv')
All.Player.Previous <- read.csv('##Fill in here##/All_Player_Previous2.csv')
Salaries.All <- read.csv('##Fill in here##/salary_final.csv')
Matchup.History <- read.csv('##Fill in here##/lines_ou.csv')
daily.pred.data <- readRDS('##Fill in here##/daily_pred_data_final.rds')

###The general set-up of the code below is as follows:

###Step 1: pre-process all the data, put it in one list (daily.pred.data), as well as
###create several intermediate functions that do things like make predictions, create lineups, etc

###Step 2: create a function (full.1day.stuff) that combines everything for a single day:
###generate predictions, lineups, and lineup-level statistics

###Step 3: Due to the computing intensity required, run each day 1 at a time

########################################
########################################
###Pre-Processing Steps and Functions###
########################################
########################################


Team.Names <- unique(Teams.All$Tm)
Teams.All$Date <- as.Date(Teams.All$Date, "%m/%d/%Y")
Defenses.All$Date <- as.Date(Defenses.All$Date, "%m/%d/%Y")
All.Player.Previous$Date <- as.Date(All.Player.Previous$Date, "%m/%d/%Y")
Salaries.All$Date <- as.Date(Salaries.All$Date, "%m/%d/%Y")
Matchup.History$Date <- as.Date(Matchup.History$Date,"%m/%d/%Y")

First.Date <- as.Date("11/16/2015","%m/%d/%Y")
All.Dates <- unique(Teams.All$Date)
All.Dates <- sort(All.Dates[All.Dates>=First.Date])

#########

Current.Day.Data <- function(Team=Home.Tm, date.today=Game.Date, Type='Home')
{
Today.Data <- subset(Teams.All.Today, Tm %in% Team)
Today.player.list <- as.vector(unique(Today.Data$Name))
k.today <- length(Today.player.list)

df.today <- data.frame(matrix(ncol = 94, nrow = 0))

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

########################################################
###Use daily.pred.data list to make daily predictions###
########################################################

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

fp <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
fp.10 <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
gs <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
tov.10 <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
drb.10 <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
fta.10 <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
fga.10 <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
opp.clus1 <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))
opp.clus2 <- matrix(, nrow=length(game.count.current[,1]), ncol=max(game.count.current[,2]))

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
model <- bugs(data, inits, parameters, "lasso_ind_all_indicator.bug", 
               n.chains=1, debug=FALSE, n.iter=11000, n.burnin=1000,    
               working.directory = getwd(), 
			bugs.directory =  'C:/Users/Charles/Desktop/WinBUGS14'                       
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

##########################################
###Clean up predictions for permutation###
##########################################

lineup.1day <- function(input.data=pred.today, cut1=50000, cut2=50000)
{
prediction.salary.today <- input.data[[1]]
Game.Date <- unique(prediction.salary.today[,1])
game.count.current <- input.data[[3]]

prediction.salary.today$Name.Final <- as.character(prediction.salary.today$Name.Final)
prediction.salary.today$Position <- as.character(prediction.salary.today$Position)

teams.all.temp <- subset(Teams.All, Date==Game.Date)
teams.all.temp2 <- teams.all.temp[,c(1,3,43)]
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
#test2 <- lineup.1day(input.data=pred.today, cut1=50000, cut2=50000)

###############################
####Lineup Level Statistics####
###############################

#############
###Line/OU###
#############

#matchup.hm <- Matchup.History[,c(1, 2, 4, 5)]
#colnames(matchup.hm)[2] <- 'Tm'
#matchup.away <- Matchup.History[,c(1, 3, 4, 5)]
#colnames(matchup.away)[2] <- 'Tm'

#matchup.all <- rbind(matchup.hm, matchup.away)
#matchup.all[,1] <- as.Date(matchup.all[,1], "%m/%d/%Y")
#colnames(matchup.all)[1] <- 'Date'
#pred.salary.vegas <- join(pred.day1[[1]], matchup.all)

#########################
###Opponent Median Dif###
#########################

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
opp.results.2015 <- opp.median.over.time(day.index=1)
opp.clust.2015.new <- rbind.fill(opp.results.2015)
opp.clust.2015.new <- subset(opp.clust.2015.new, Date>'2015-11-10')
second.join <- join(opp.clust.2015.new, daily.pred.data[[1]])
colnames(second.join)[4] <- 'Name.Final'
third.join <- join(second.join, pred.salary.vegas)

#######################
###Creation of Stats###
#######################

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
#lineups.day1 <- var.addition(all.variable.list=c(3, 56, 95, 104, 105, 106),lineups.1day=test1)

##################################################################################
##################################################################################
###Function that calls everything for 1 day and outputs a list with 2 things:#####
###First, the daily predictions and WinBUGS results                          #####
###Second, the lineups with lineup level stats                               #####
##################################################################################
##################################################################################


full.1day.stuff <- function(day=1, cut1.value=50000, cut2.value=50000)
{

pred.today <- pred.1day(day.index=day)
lineup.today <- lineup.1day(input.data=pred.today, cut1=cut1.value, cut2=cut2.value)

matchup.hm <- Matchup.History[,c(1, 2, 4, 5)]
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


###Call the above function for each day of interest.
###Note that depending on the number of games, sometimes
###the cutpoints used for the number of lineups needed to be adjusted
###Due to file size restraints, I also had to save the daily results to blocks of code
###Forgive my cheesy plea to R 

please.work1 <- full.1day.stuff(day=1)
please.work2 <- full.1day.stuff(day=2)
please.work3 <- full.1day.stuff(day=3)
please.work4 <- full.1day.stuff(day=4)
please.work5 <- full.1day.stuff(day=5)
please.work6 <- full.1day.stuff(day=6)
please.work7 <- full.1day.stuff(day=7)
please.work8 <- full.1day.stuff(day=8)
please.work9 <- full.1day.stuff(day=9)
please.work10 <- full.1day.stuff(day=10)
please.work11 <- full.1day.stuff(day=11)
please.work12 <- full.1day.stuff(day=12)
please.work13 <- full.1day.stuff(day=13)
please.work14 <- full.1day.stuff(day=14)
please.work15 <- full.1day.stuff(day=15)
please.work16 <- full.1day.stuff(day=16)
please.work17 <- full.1day.stuff(day=17)
please.work18 <- full.1day.stuff(day=18)
please.work19 <- full.1day.stuff(day=19)
please.work20 <- full.1day.stuff(day=20)
please.work21 <- full.1day.stuff(day=21)
please.work22 <- full.1day.stuff(day=22)
please.work23 <- full.1day.stuff(day=23)
please.work24 <- full.1day.stuff(day=24)
please.work25 <- full.1day.stuff(day=25)
please.work26 <- full.1day.stuff(day=26)
please.work27 <- full.1day.stuff(day=27)
please.work28 <- full.1day.stuff(day=28)
please.work29 <- full.1day.stuff(day=29)
please.work30 <- full.1day.stuff(day=30, cut1=50000, cut2=20000)
please.work31 <- full.1day.stuff(day=31)
please.work32 <- full.1day.stuff(day=32)
please.work33 <- full.1day.stuff(day=33)
please.work34 <- full.1day.stuff(day=34)
please.work35 <- full.1day.stuff(day=35)
please.work36 <- full.1day.stuff(day=36)
please.work37 <- full.1day.stuff(day=37)
please.work38 <- full.1day.stuff(day=38)
please.work39 <- full.1day.stuff(day=39, cut1=50000, cut2=20000)


saveRDS(lineups.block1, '##Modify Here##/lineups_block1.rds')

####

please.work40 <- full.1day.stuff(day=40)
please.work41 <- full.1day.stuff(day=41)
please.work42 <- full.1day.stuff(day=42)
please.work43 <- full.1day.stuff(day=43)
please.work44 <- full.1day.stuff(day=44)
please.work45 <- full.1day.stuff(day=45)
please.work46 <- full.1day.stuff(day=46)
please.work47 <- full.1day.stuff(day=47)
please.work48 <- full.1day.stuff(day=48)
please.work49 <- full.1day.stuff(day=49)
please.work50 <- full.1day.stuff(day=50)
please.work51 <- full.1day.stuff(day=51)
please.work52 <- full.1day.stuff(day=52)
please.work53 <- full.1day.stuff(day=53)
please.work54 <- full.1day.stuff(day=54)
please.work55 <- full.1day.stuff(day=55)
please.work56 <- full.1day.stuff(day=56)
please.work57 <- full.1day.stuff(day=57)
please.work58 <- full.1day.stuff(day=58)
please.work59 <- full.1day.stuff(day=59)
please.work60 <- full.1day.stuff(day=60)
please.work61 <- full.1day.stuff(day=61)
please.work62 <- full.1day.stuff(day=62)
please.work63 <- full.1day.stuff(day=63)
please.work64 <- full.1day.stuff(day=64, cut1=150000, cut2=30000)
please.work65 <- full.1day.stuff(day=65)
please.work66 <- full.1day.stuff(day=66)
please.work67 <- full.1day.stuff(day=67)
please.work68 <- full.1day.stuff(day=68)
please.work69 <- full.1day.stuff(day=69)
please.work70 <- full.1day.stuff(day=70)
please.work71 <- full.1day.stuff(day=71)

lineups.block2 <- list(please.work40, please.work41, please.work42, please.work43,
please.work44, please.work45, please.work46, please.work47, please.work48, 
please.work49, please.work50, please.work51, please.work52, please.work53,
please.work54, please.work55, please.work56, please.work57, please.work58, 
please.work59, please.work60, please.work61, please.work62, please.work63, 
please.work64, please.work65, please.work66, please.work67, please.work68, 
please.work69, please.work70, please.work71)

saveRDS(lineups.block2, '##Modify Here##/lineups_block2.rds')

#####

please.work72 <- full.1day.stuff(day=72)
please.work73 <- full.1day.stuff(day=73)
please.work74 <- full.1day.stuff(day=74)
please.work75 <- full.1day.stuff(day=75)
please.work76 <- full.1day.stuff(day=76)
please.work77 <- full.1day.stuff(day=77)
please.work78 <- full.1day.stuff(day=78, cut1=50000, cut2=20000)
please.work79 <- full.1day.stuff(day=79)
please.work80 <- full.1day.stuff(day=80, cut1=50000, cut2=20000)
please.work81 <- full.1day.stuff(day=81, cut1=50000, cut2=20000)
please.work82 <- full.1day.stuff(day=82)
please.work83 <- full.1day.stuff(day=83, cut1=50000, cut2=20000)
please.work84 <- full.1day.stuff(day=84)
please.work85 <- full.1day.stuff(day=85, cut1=150000, cut2=30000)
##Must use no cut1 for first round in please.work86
#please.work86 <- full.1day.stuff(day=86, cut1=150000, cut2=30000)
please.work87 <- full.1day.stuff(day=87)
please.work88 <- full.1day.stuff(day=88, cut1=150000, cut2=30000)
please.work89 <- full.1day.stuff(day=89)


lineups.block3 <- list(please.work72, please.work73, please.work74, please.work75,
please.work76, please.work77, please.work78, please.work79, please.work80, 
please.work81, please.work82, please.work83, please.work84, please.work85,
please.work86, please.work87, please.work88, please.work89)

saveRDS(lineups.block3, '##Modify Here##/lineups_block3.rds')

###

please.work90 <- full.1day.stuff(day=90)
please.work91 <- full.1day.stuff(day=91)
please.work92 <- full.1day.stuff(day=92)
please.work93 <- full.1day.stuff(day=93, cut1=50000, cut2=20000)
please.work94 <- full.1day.stuff(day=94)
please.work95 <- full.1day.stuff(day=95)
please.work96 <- full.1day.stuff(day=96)
please.work97 <- full.1day.stuff(day=97)
please.work98 <- full.1day.stuff(day=98)
please.work99 <- full.1day.stuff(day=99)
please.work100 <- full.1day.stuff(day=100, cut1=50000, cut2=20000)
please.work101 <- full.1day.stuff(day=101)
please.work102 <- full.1day.stuff(day=102)
please.work103 <- full.1day.stuff(day=103)
please.work104 <- full.1day.stuff(day=104)
please.work105 <- full.1day.stuff(day=105)
please.work106 <- full.1day.stuff(day=106)
please.work107 <- full.1day.stuff(day=107)

lineups.block4 <- list(please.work90, please.work91, please.work92, please.work93,
please.work94, please.work95, please.work96, please.work97, please.work98, 
please.work99, NA, please.work101, please.work102, please.work103,
please.work104, please.work105, please.work106, please.work107)

saveRDS(lineups.block4, '##Modify Here##/lineups_block4.rds')

###

please.work108 <- full.1day.stuff(day=108)
please.work109 <- full.1day.stuff(day=109)
please.work110 <- full.1day.stuff(day=110)
please.work111 <- full.1day.stuff(day=111)
please.work112 <- full.1day.stuff(day=112)
please.work113 <- full.1day.stuff(day=113)
please.work114 <- full.1day.stuff(day=114)
please.work115 <- full.1day.stuff(day=115)
please.work116 <- full.1day.stuff(day=116)
please.work117 <- full.1day.stuff(day=117)
please.work118 <- full.1day.stuff(day=118)
please.work119 <- full.1day.stuff(day=119)
please.work120 <- full.1day.stuff(day=120)
please.work121 <- full.1day.stuff(day=121, cut1=50000, cut2=20000)
please.work122 <- full.1day.stuff(day=122)
please.work123 <- full.1day.stuff(day=123)


lineups.block5 <- list(please.work108, please.work109, please.work110, please.work111,
please.work112, please.work113, please.work114, please.work115, please.work116, 
please.work117, please.work118, please.work119, please.work120, NA,
please.work122, please.work123)

saveRDS(lineups.block5, '##Modify Here##/lineups_block5.rds')

###

please.work124 <- full.1day.stuff(day=124)
please.work125 <- full.1day.stuff(day=125)
please.work126 <- full.1day.stuff(day=126)
please.work127 <- full.1day.stuff(day=127)
please.work128 <- full.1day.stuff(day=128)
please.work129 <- full.1day.stuff(day=129)
please.work130 <- full.1day.stuff(day=130)
please.work131 <- full.1day.stuff(day=131)
please.work132 <- full.1day.stuff(day=132)
please.work133 <- full.1day.stuff(day=133)
please.work134 <- full.1day.stuff(day=134)
please.work135 <- full.1day.stuff(day=135)


lineups.block6 <- list(please.work124, please.work125, please.work126, please.work127,
please.work128, please.work129, please.work130, please.work131, please.work132, 
please.work133, please.work134, please.work135)

saveRDS(lineups.block6, '##Modify Here##/lineups_block6.rds')

#####

please.work136 <- full.1day.stuff(day=136)
please.work137 <- full.1day.stuff(day=137)
please.work138 <- full.1day.stuff(day=138)
please.work139 <- full.1day.stuff(day=138)
please.work140 <- full.1day.stuff(day=140)
please.work141 <- full.1day.stuff(day=141)

lineups.block7 <- list(please.work136, please.work137, please.work138, please.work139, 
please.work140, please.work141)

saveRDS(lineups.block7, '##Modify Here##/lineups_block7.rds')

##############################################
##############################################
###Use KNN to re-order the permuted lineups###
##############################################
##############################################

##For this last block, I had to use a more powerful computer to combine all the lineups
##'lineups.all' is a list that contains all the lineups for each day from each of the above blocks
##Note that the lineups are the second element of the list in each of the "please.work" objects

library(plyr)
library(class)

lineups.all <- readRDS('##Modify Here##/lineups_all.rds')

lineups.final <- rbind.fill(lineups.all)
lineups.final$AboveCut <- ifelse(lineups.final$Actual>=260, 1, 0)

lineups.dates <- unique(lineups.final$Date)

lineups.knn <- vector('list', length(lineups.dates)-1)

for(i in 2:length(lineups.dates))
{
date.of.interest <- lineups.dates[i]
data.train <- subset(lineups.final, Date<date.of.interest)
data.test <- subset(lineups.final, Date==date.of.interest)

knn.response <- data.train$AboveCut
data.train.knn <- scale(data.train[,c(12,15:19)])
data.test.knn <- scale(data.test[,c(12,15:19)])
 
full.model <- knn(data.train.knn, data.test.knn, knn.response, k=80, prob=T)

pred.prob.unorder <- data.frame(Lineup.Number=1:length(full.model), data.test[,1:9], Pred.Prob=attributes(full.model)$prob, 
Projected=data.test$Projection, Actual=data.test$Actual, Actual.AboveCut=data.test$AboveCut, Date=data.test$Date)
lineups.knn[[i-1]] <- pred.prob.unorder[order(-pred.prob.unorder[,11], -pred.prob.unorder[,12]),]
#lineups.knn[[i-1]] <- pred.prob.unorder[order(-pred.prob.unorder[,11]),]
}


##Here is how we compared the KNN lineups to the permuted alone lineups

top.knn.mean <- unlist(lapply(lineups.knn, function(x){mean(x[1:100,13])}))
top.knn.max <- unlist(lapply(lineups.knn, function(x){max(x[1:100,13])}))

top.permute.mean <- unlist(lapply(lineups.all, function(x){mean(x[1:100,11])}))
top.permute.max <- unlist(lapply(lineups.all, function(x){max(x[1:100,11])}))

#####################################################
###Function for validating the number of neighbors###
#####################################################

knn.select <- function(knn.sequence=seq(60, 200, 10), cutpoint=270, lineupcount=10)
{
knn.atleast1 <- numeric(0)
knn.success <- numeric(0)
knn.mean <- numeric(0)
knn.max <- numeric(0)

lineups.final$AboveCut <- ifelse(lineups.final$Actual>=cutpoint, 1, 0)

for(i in 1:length(knn.sequence))
{
lineups.knn <- vector('list', length(lineups.dates)-1)

	for(j in 2:length(lineups.dates))
	{
	date.of.interest <- lineups.dates[j]
	data.train <- subset(lineups.final, Date<date.of.interest)
	data.test <- subset(lineups.final, Date==date.of.interest)

	knn.response <- data.train$AboveCut
	data.train.knn <- scale(data.train[,c(12,15:19)])
	data.test.knn <- scale(data.test[,c(12,15:19)])
	#data.train.knn <- data.train[,c(12,15:19)]
	#data.train.knn[,1] <- data.train.knn[,1]/8
	#data.test.knn <- data.test[,c(12,15:19)]
	#data.test.knn[,1] <- data.test.knn[,1]/8
 
	full.model <- knn(data.train.knn, data.test.knn, knn.response, k=knn.sequence[i], prob=T)

	pred.prob.unorder <- data.frame(Lineup.Number=1:length(full.model), Pred.Prob=attributes(full.model)$prob, 
	Projected=data.test$Projection, Actual=data.test$Actual, Actual.AboveCut=data.test$AboveCut, Date=data.test$Date)
	#lineups.knn[[j-1]] <- pred.prob.unorder[order(-pred.prob.unorder[,2], -pred.prob.unorder[,3]),]
	lineups.knn[[j-1]] <- pred.prob.unorder[order(-pred.prob.unorder[,2]),]
	}

top.knn.mean <- unlist(lapply(lineups.knn, function(x){mean(x[1:lineupcount,4])}))
top.knn.max <- unlist(lapply(lineups.knn, function(x){max(x[1:lineupcount,4])}))

knn.mean[i] <- mean(top.knn.mean)
knn.max[i] <- mean(top.knn.max)
}

knn.results <- data.frame(knn.sequence, knn.mean, knn.max)
return(knn.results)
}
#knn.check <- knn.select(knn.sequence=seq(100, 110, 5))
knn.check2 <- knn.select(knn.sequence=seq(60, 200, 10), cutpoint=280, lineupcount=200)
knn.check2
knn.check3 <- knn.select(knn.sequence=seq(60, 150, 10), cutpoint=270, lineupcount=200)
knn.check3
knn.check3 <- knn.select(knn.sequence=seq(60, 150, 10), cutpoint=260, lineupcount=200)
knn.check3
knn.check4 <- knn.select(knn.sequence=seq(60, 200, 10), cutpoint=280, lineupcount=100)
knn.check4
knn.check5 <- knn.select(knn.sequence=seq(60, 150, 10), cutpoint=270, lineupcount=100)
knn.check5
knn.check6 <- knn.select(knn.sequence=seq(10, 200, 10), cutpoint=260, lineupcount=100)
knn.check6