library(XML)
library(httr)

TeamStats <- function(team, year){
  url <- paste('http://www.basketball-reference.com/teams/',team,'/',year,'/gamelog/')
  url <- gsub(" ","",url,fixed=TRUE)
  url2 <- paste('http://www.basketball-reference.com/teams/',team,'/',year,'/gamelog-advanced/')
  url2 <- gsub(" ","",url2,fixed=TRUE)
  
  print(url)
  
  url <- rawToChar(GET(url)$content)
  url2 <- rawToChar(GET(url2)$content)
  
  BasicStats <- readHTMLTable(url,which=1)
  BasicStats <- BasicStats[,c(1:24)]
  BasicStats <- BasicStats[-c(which(BasicStats[,1]==''),(which(BasicStats[,1]=='')+1)),]
  AdvancedStats <- readHTMLTable(url2,which=1)
  AdvancedStats <- AdvancedStats[,c(9:18,20:23,25:28)]
  AdvancedStats <- AdvancedStats[-c(which(is.na(AdvancedStats[,1])),(which(is.na(AdvancedStats[,1]))+1)),]
  AllStats <- data.frame(BasicStats,AdvancedStats)
  AllStats <- AllStats[,-c(1,6)]
  AllStats <- AllStats[AllStats[,1]!="Team",]
  AllStats <- AllStats[AllStats[,1]!="G",]

  AllStats[,3] <- as.character(AllStats[,3])
  AllStats[,3][AllStats[,3]==""]=1
  AllStats[,3][AllStats[,3]=="@"]=0
  AllStats[,3] <- as.numeric(AllStats[,3])

  AllStats[,1] <- as.numeric(as.character(AllStats[,1]))
  for(i in 5:ncol(AllStats)){
    AllStats[,i] <- as.numeric(as.character(AllStats[,i]))
  }

  AllStats[,2] <- as.character(AllStats[,2])
  AllStats[,4] <- as.character(AllStats[,4])
  AllStats[,2] <- as.Date(AllStats[,2])

  margin <- AllStats[,5]-AllStats[,6]
  AllStats <- data.frame(AllStats[,1:6],margin,AllStats[,7:ncol(AllStats)])

  daysoff <- rep(0,nrow(AllStats))
  for(i in 2:nrow(AllStats)){
    daysoff[i] <- as.numeric(AllStats[i,2]-AllStats[i-1,2])-1
  }

  colnames(AllStats)[3:6] <- c("Location","Opp","Tm.PTS","Opp.PTS")
  colnames(AllStats)[34:41] <- c("Off.eFG.pct","Off.TOV.pct","Off.ORB.pct","Off.FT/FGA","Def.eFG.pct","Def.TOV.pct","Def.ORB.pct","Def.FT/FGA")
  AllStats <- data.frame(Team=as.character(team), AllStats[,1:2],daysoff,AllStats[,3:ncol(AllStats)])
  return(AllStats)
}


PlayerStats <- function(player, name, year){
  initial <- substr(player,1,1)
  url <- paste('http://www.basketball-reference.com/players/',initial,'/',player,'/gamelog/',year,'/')
  url <- gsub(" ","",url,fixed=TRUE)
  url2 <- paste('http://www.basketball-reference.com/players/',initial,'/',player,'/gamelog-advanced/',year,'/')
  url2 <- gsub(" ","",url2,fixed=TRUE)
  
  print(url)
  
  url <- rawToChar(GET(url)$content)
  url2 <- rawToChar(GET(url2)$content)
  
  BasicStats <- readHTMLTable(url,which=8)
  BasicStats <- BasicStats[-c(which(BasicStats$G=='G')),]
  AdvancedStats <- readHTMLTable(url2,which=1)
  AdvancedStats <- AdvancedStats[-c(which(AdvancedStats$G=='G')),]
  AllStats <- data.frame(BasicStats,AdvancedStats[,10:ncol(AdvancedStats)])
  
  ##Drop repeated game score variable
  AllStats <- AllStats[,-45]
  colnames(AllStats)[6] <- "Location"
  colnames(AllStats)[8] <- "Margin"
  AllStats <- AllStats[AllStats[,1]!="Rk",]
  rownames(AllStats) <- AllStats[,1]
  
  ##Drop RK, Margin, +/-, and repeated minutes played
  AllStats <- AllStats[,-c(1,8,30,32)]
  
  AllStats1 <- AllStats
  #head(AllStats1)
  
  ##Re-format location variable
  AllStats1[,5] <- as.character(AllStats1[,5])
  AllStats1[,5][AllStats1[,5]==""]=1
  AllStats1[,5][AllStats1[,5]=="@"]=0
  AllStats1[,5] <- as.numeric(AllStats1[,5])
  
  AllStats1 <- data.frame(AllStats1[,1:4],AllStats1[,6],AllStats1[,5],AllStats1[,7:ncol(AllStats1)])
  colnames(AllStats1)[5] <- "Opp"
  colnames(AllStats1)[6] <- "Location"
  
  ##Re-format minutes played to be a decimal
  #AllStats1[,8] <- substr(AllStats1[,8],1,2)
  AllStats1[,8] <- as.character(AllStats1[,8])
  AllStats1[,8] <- sapply(strsplit(AllStats1[,8],":"),function(x) {x <- as.numeric(x) 
  x[1]+x[2]/60})
  
  ##Convert appropriate variables to numeric
  for(i in 7:ncol(AllStats1)){
    AllStats1[,i] <- as.numeric(as.character(AllStats1[,i]))
  }
  AllStats1[,1] <- as.numeric(as.character(AllStats1[,1]))
  AllStats1[is.na(AllStats1)]=0
  for(i in 2:5){
    AllStats1[,i] <- as.character(AllStats1[,i])
  }
  
  AllStats1[,2] <- as.Date(AllStats1[,2])
  
  ##Create days off variable, with an exception if player has only 1 game
  #daysoff <- rep(0,nrow(AllStats1))
  daysoff <- numeric(0)
  daysoff[1] <- NA
  if(nrow(AllStats1)==1) daysoff <- NA else
    for(i in 2:nrow(AllStats1)){
      daysoff[i] <- as.numeric(AllStats1[i,2]-AllStats1[i-1,2])-1
    }
  
  ##Create fantasy points variable
  fantasy <- rep(0,nrow(AllStats1))
  for(i in 1:nrow(AllStats1)){
    fantasy[i] <- 1*AllStats1[i,'PTS']+.5*AllStats1[i,'X3P']+1.25*AllStats1[i,'TRB']+1.5*AllStats1[i,'AST']+2*AllStats1[i,'STL']+2*AllStats1[i,'BLK']-.5*AllStats1[i,'TOV']
    doublecats <- AllStats1[,c(26,21,20,22,23)]
    dubs <- sum(doublecats[i,]>=10)
    if(dubs>=3){
      fantasy[i] <- fantasy[i]+3
    }
    if(dubs==2){
      fantasy[i] <- fantasy[i]+1.5
    }
  }
  fantasy.min <- fantasy/(AllStats1[,'MP']+1)
  fantasy.min[is.nan(fantasy.min)]=0
  
  AllStats1 <- data.frame(Name=rep(name, nrow(AllStats1)), AllStats1,daysoff,fantasy,fantasy.min)
  return(AllStats1)
}
