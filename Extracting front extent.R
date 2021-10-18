library(plyr)
library(stringr)
library(ggplot2)
library(fields)
library(plotrix)
library(tidyr)
library(tidyverse)

#######################################
#Format data for informed emigration
pathy<-"C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/Outputs/Informed0.85/"
nam<-list.files(path=pathy, pattern="_pop.txt")

front.size.soc<-NULL

#loop trhough individual files
for (i in 1:length(nam)){
    print(c(i,nam[i]))
    
    
    tab<-read.table(paste0(pathy,nam[i]),header=T)
    matches <- regmatches(nam[i], gregexpr("[[:digit:]]+\\.*[[:digit:]]*", nam[i]))
    num<-as.numeric(unlist(matches))
    
    #Identify scenario
    tab$CellRange<-num[1]
    tab$ProspPatch<-num[2]
    tab$Rate<-num[3]
    tab$Scen<-ifelse(num[4]==3,tab$Scen<-"Pers + public", tab$Scen<-"Non-informed")
    
    print(c(tab$CellRange[1],tab$ProspPatch[1],tab$Rate[1]))
    
    #Dynamics of y extent over time to quantify front size
    tobo<-ddply(tab,.(sim,gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
    tobo<-subset(tobo,tobo$yAd<=100)
    toba<-ddply(tobo,.(sim,gen,CellRange,ProspPatch,Rate,Scen),summarize,
                Front.sim=max(y)-min(y))
    toby<-ddply(toba,.(gen,CellRange,ProspPatch,Rate,Scen),summarize,
                Frontm=mean(Front.sim, na.rm=T),Frontse=std.error(Front.sim,na.rm=T))
    
    front.size.soc<-rbind(front.size.soc,toby)
    
}

front.size.soc$CellRange<-as.factor(front.size.soc$CellRange)
front.size.soc$ProspPatch<-as.factor(front.size.soc$ProspPatch)
front.size.soc$Rate<-1-front.size.soc$Rate
front.size.soc$Rate<-as.factor(front.size.soc$Rate)
front.size.soc$Scen<-as.factor(front.size.soc$Scen)
front.size.soc$gen<-front.size.soc$gen-200

save(front.size.soc,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/front_size_soc_0.85.RData")

##########################################
#Format data for non-informed emigration

patho<-"C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/Outputs/Random0.5/"
nam<-list.files(path=patho, pattern="_pop.txt")

range.shift.rand<-NULL
maxy.time.rand<-NULL
front.size.rand<-NULL

for (i in 1:length(nam)){
    print(c(i,nam[i]))
    tab<-read.table(paste0(patho,nam[i]),header=T)
    matches <- regmatches(nam[i], gregexpr("[[:digit:]]+\\.*[[:digit:]]*", nam[i]))
    num<-as.numeric(unlist(matches))
    
    tab$CellRange<-num[1]
    tab$ProspPatch<-num[2]
    tab$Rate<-num[3]
    tab$Scen<-ifelse(num[4]==3,tab$Scen<-"Pers + public", tab$Scen<-"Non-informed")
    
    print(c(tab$CellRange[1],tab$ProspPatch[1],tab$Rate[1],max(tab$y)))
    
    #Dynamics of y extent over time to quantify front size
    tobo<-ddply(tab,.(sim,gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
    tobo<-subset(tobo,tobo$yAd<=100)
    toba<-ddply(tobo,.(sim,gen,CellRange,ProspPatch,Rate,Scen),summarize,
                Front.sim=max(y)-min(y))
    toby<-ddply(toba,.(gen,CellRange,ProspPatch,Rate,Scen),summarize,
                Frontm=mean(Front.sim,na.rm=T),Frontse=std.error(Front.sim,na.rm=T))
    
    front.size.rand<-rbind(front.size.rand,toby)
    
}


front.size.rand$CellRange<-as.factor(front.size.rand$CellRange)
front.size.rand$ProspPatch<-as.factor(front.size.rand$ProspPatch)
front.size.rand$Rate<-1-front.size.rand$Rate
front.size.rand$Rate<-as.factor(front.size.rand$Rate)
front.size.rand$Scen<-as.factor(front.size.rand$Scen)
front.size.rand$gen<-front.size.rand$gen-200

save(front.size.rand,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/front_size_rand_0.5.RData")

