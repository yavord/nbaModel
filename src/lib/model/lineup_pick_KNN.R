library(plyr)
library(class)


lineups.all <- lineup_block  #TODO: import RDS or parquet that holds model outputs
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


# How the KNN lineups were compared to the permuted alone lineups
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

# knn.check2 <- knn.select(knn.sequence=seq(60, 200, 10), cutpoint=280, lineupcount=200)
# knn.check3 <- knn.select(knn.sequence=seq(60, 150, 10), cutpoint=270, lineupcount=200)
# knn.check3 <- knn.select(knn.sequence=seq(60, 150, 10), cutpoint=260, lineupcount=200)
# knn.check4 <- knn.select(knn.sequence=seq(60, 200, 10), cutpoint=280, lineupcount=100)
# knn.check5 <- knn.select(knn.sequence=seq(60, 150, 10), cutpoint=270, lineupcount=100)
# knn.check6 <- knn.select(knn.sequence=seq(10, 200, 10), cutpoint=260, lineupcount=100)
