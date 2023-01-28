library(plyr)
library(class)

data_dir <- '/home/yavor/projects/multi_projects/nba/nbaModel/src/data/'

lineups.all <- readRDS(paste0(data_dir,'lineup_block.rds'))
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
}

saveRDS(lineups.knn, paste0(data_dir,'lineups_knn.RDS'))
