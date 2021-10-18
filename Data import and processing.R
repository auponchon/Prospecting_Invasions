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

range.shift.soc<-NULL
maxy.time.soc<-NULL
# front.size.soc<-NULL

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

  print(c(tab$CellRange[1],tab$ProspPatch[1],tab$Rate[1],max(tab$y)))


##Range shifting rate
tabo<-subset(tab, tab$gen==max(tab$gen) & tab$Nadult>0)
tabou<-ddply(tabo,.(sim,CellRange,ProspPatch,Rate,Scen),summarize,RangeShift=(max(y)-2)/100,
               Nad=sum(Nadult),NDisp=sum(NDisp),Nim=sum(Nimmigr))
range.mean<-ddply(tabou,.(CellRange,ProspPatch,Rate,Scen),summarize,
                  RangeShift.mean=mean(RangeShift,na.rm=T), Nad.mean=mean(Nad,na.rm=T),
                  NDisp.mean=mean(NDisp,na.rm=T),Nimmigr.mean=mean(Nim,na.rm=T),
             RangeShift.se=std.error(RangeShift,na.rm=T),Nad.se=std.error(Nad,na.rm=T),
             NDisp.se=std.error(NDisp,na.rm=T),Nimmigr.se=std.error(Nim,na.rm=T))

range.shift.soc<-rbind(range.shift.soc,range.mean)


##Dynamics of range expansion over time
taba<-subset(tab,tab$gen==max(tab$gen))
tabi<-ddply(taba,.(sim,gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
tabi<-ddply(tabi,.(gen,y,CellRange,ProspPatch,Rate,Scen),summarize,
            yAdm=mean(yAd),yAdse=std.error(yAd,na.rm=T), yDispm=mean(yDisp,na.rm=T),
             yDispse=std.error(yDisp,na.rm=T),yImmigrm=mean(yImmigr,na.rm=T),yImmigrse=std.error(yImmigr,na.rm=T))
 
maxy.time.soc<-rbind(maxy.time.soc,tabi)

# #Dynamics of y extent over time to quantify front size
# tobo<-ddply(tab,.(sim,gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
# tobo<-subset(tobo,tobo$yAd<=100)
# toba<-ddply(tobo,.(sim,gen,CellRange,ProspPatch,Rate,Scen),summarize,
#             Front.sim=max(y)-min(y))
# toby<-ddply(toba,.(gen,CellRange,ProspPatch,Rate,Scen),summarize,
#             Frontm=mean(Front.sim, na.rm=T),Frontse=std.error(Front.sim,na.rm=T))
# 
# front.size.soc<-rbind(front.size.soc,toby)
 
}

#Format final dataset for informed emigration data
range.shift.soc$CellRange<-as.factor(range.shift.soc$CellRange)
range.shift.soc$ProspPatch<-as.factor(range.shift.soc$ProspPatch)
range.shift.soc$Rate<-1-range.shift.soc$Rate
range.shift.soc$Rate<-as.factor(range.shift.soc$Rate)
range.shift.soc$Scen<-as.factor(range.shift.soc$Scen)

maxy.time.soc$CellRange<-as.factor(maxy.time.soc$CellRange)
maxy.time.soc$ProspPatch<-as.factor(maxy.time.soc$ProspPatch)
maxy.time.soc$Rate<-1-maxy.time.soc$Rate
maxy.time.soc$Rate<-as.factor(maxy.time.soc$Rate)
maxy.time.soc$Scen<-as.factor(maxy.time.soc$Scen)
maxy.time.soc$gen<-maxy.time.soc$gen-200

# front.size.soc$CellRange<-as.factor(front.size.soc$CellRange)
# front.size.soc$ProspPatch<-as.factor(front.size.soc$ProspPatch)
# front.size.soc$Rate<-1-front.size.soc$Rate
# front.size.soc$Rate<-as.factor(front.size.soc$Rate)
# front.size.soc$Scen<-as.factor(front.size.soc$Scen)
# front.size.soc$gen<-front.size.soc$gen-200


#save the two datasets
save(range.shift.soc,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/RangeShift_soc_0.85.RData")
save(maxy.time.soc,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/maxy_time_soc_0.85.RData")
# save(front.size.soc,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/front_size_soc_0.85.RData")


rm(list=ls())

##########################################
#Format data for non-informed emigration

patho<-"C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/Outputs/Random0.5/"
 nam<-list.files(path=patho, pattern="_pop.txt")
 
 range.shift.rand<-NULL
 maxy.time.rand<-NULL
 # front.size.rand<-NULL
 
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

   
   ##Range shifting rate
   tabo<-subset(tab, tab$gen==max(tab$gen) & tab$Nadult>0)
   tabou<-ddply(tabo,.(sim,CellRange,ProspPatch,Rate,Scen),summarize,RangeShift=(max(y)-2)/100,
                Nad=sum(Nadult),NDisp=sum(NDisp),Nim=sum(Nimmigr))
   range.mean<-ddply(tabou,.(CellRange,ProspPatch,Rate,Scen),summarize,
                     RangeShift.mean=mean(RangeShift,na.rm=T), Nad.mean=mean(Nad,na.rm=T),
                     NDisp.mean=mean(NDisp,na.rm=T),Nimmigr.mean=mean(Nim,na.rm=T),
                     RangeShift.se=std.error(RangeShift,na.rm=T),Nad.se=std.error(Nad,na.rm=T),
                     NDisp.se=std.error(NDisp,na.rm=T),Nimmigr.se=std.error(Nim,na.rm=T))
   
   range.shift.rand<-rbind(range.shift.rand,range.mean)
   
   
   
   ##Dynamics of range expansion over time
   taba<-subset(tab,tab$gen==max(tab$gen))
   tabi<-ddply(taba,.(sim,gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
   tabi<-ddply(tabi,.(gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAdm=mean(yAd,na.rm=T),yAdse=std.error(yAd,na.rm=T), yDispm=mean(yDisp),
               yDispse=std.error(yDisp,na.rm=T),yImmigrm=mean(yImmigr,na.rm=T),yImmigrse=std.error(yImmigr,na.rm=T))
   
   maxy.time.rand<-rbind(maxy.time.rand,tabi)
   
   #Dynamics of y extent over time to quantify front size
   # tobo<-ddply(tab,.(sim,gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
   # tobo<-subset(tobo,tobo$yAd<=100)
   # toba<-ddply(tobo,.(sim,gen,CellRange,ProspPatch,Rate,Scen),summarize,
   #             Front.sim=max(y)-min(y))
   # toby<-ddply(toba,.(gen,CellRange,ProspPatch,Rate,Scen),summarize,
   #             Frontm=mean(Front.sim,na.rm=T),Frontse=std.error(Front.sim,na.rm=T))
   # 
   # front.size.rand<-rbind(front.size.rand,toby)
   # 
 }
 
 range.shift.rand$CellRange<-as.factor(range.shift.rand$CellRange)
 range.shift.rand$ProspPatch<-as.factor(range.shift.rand$ProspPatch)
 range.shift.rand$Rate<-1-range.shift.rand$Rate
 range.shift.rand$Rate<-as.factor(range.shift.rand$Rate)
 range.shift.rand$Scen<-as.factor(range.shift.rand$Scen)
 
 maxy.time.rand$CellRange<-as.factor(maxy.time.rand$CellRange)
 maxy.time.rand$ProspPatch<-as.factor(maxy.time.rand$ProspPatch)
 maxy.time.rand$Rate<-1-maxy.time.rand$Rate
 maxy.time.rand$Rate<-as.factor(maxy.time.rand$Rate)
 maxy.time.rand$Scen<-as.factor(maxy.time.rand$Scen)
 maxy.time.rand$gen<-maxy.time.rand$gen-200
 
 # front.size.rand$CellRange<-as.factor(front.size.rand$CellRange)
 # front.size.rand$ProspPatch<-as.factor(front.size.rand$ProspPatch)
 # front.size.rand$Rate<-1-front.size.rand$Rate
 # front.size.rand$Rate<-as.factor(front.size.rand$Rate)
 # front.size.rand$Scen<-as.factor(front.size.rand$Scen)
 # front.size.rand$gen<-front.size.rand$gen-200
 
 save(range.shift.rand,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/RangeShift_rand_0.5.RData")
 save(maxy.time.rand,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/maxy_time_rand_0.5.RData")
 # save(front.size.rand,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/front_size_rand_0.5.RData")
 
 
 