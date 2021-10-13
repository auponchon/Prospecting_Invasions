library(plyr)
library(stringr)
library(ggplot2)
library(fields)
library(plotrix)
library(tidyr)

setwd("C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/Outputs/Informed0.4")

nam<-list.files(pattern="_pop.txt")
#nam<-nam[grep("_Em_3_Evolprosp_0_Evolemigr_0_pop",nam)]

range.shift.soc<-NULL
maxy.time.soc<-NULL

 for (i in 1:length(nam)){
  print(c(i,nam[i]))
  tab<-read.table(nam[i],header=T)
  matches <- regmatches(nam[i], gregexpr("[[:digit:]]+\\.*[[:digit:]]*", nam[i]))
  num<-as.numeric(unlist(matches))

  tab$CellRange<-num[1]
  tab$ProspPatch<-num[2]
  tab$Rate<-num[3]
  tab$Scen<-ifelse(num[4]==3,tab$Scen<-"Pers + public", tab$Scen<-"Random")

  print(c(tab$CellRange[1],tab$ProspPatch[1],tab$Rate[1]))

  tabou<-subset(tab,tab$sim==5)
 

##Range shifting rate
tabo<-subset(tab, tab$gen==max(tab$gen) & tab$Nadult>0)
tabou<-ddply(tabo,.(sim,CellRange,ProspPatch,Rate,Scen),summarize,RangeShift=(max(y)-2)/100,
               Nad=sum(Nadult),NDisp=sum(NDisp),Nim=sum(Nimmigr))
range.mean<-ddply(tabou,.(CellRange,ProspPatch,Rate,Scen),summarize,
                  RangeShift.mean=mean(RangeShift), Nad.mean=mean(Nad),
                  NDisp.mean=mean(NDisp),Nimmigr.mean=mean(Nim),
             RangeShift.se=std.error(RangeShift),Nad.se=std.error(Nad),
             NDisp.se=std.error(NDisp),Nimmigr.se=std.error(Nim))

range.shift.soc<-rbind(range.shift.soc,range.mean)



##Dynamics of range expansion over time
taba<-ddply(tab,.(sim,gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
taba<-ddply(taba,.(gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAdm=mean(yAd),yAdse=std.error(yAd), yDispm=mean(yDisp),
            yDispse=std.error(yDisp),yImmigrm=mean(yImmigr),yImmigrse=std.error(yImmigr))
#taba<-subset(taba,taba$gen==max(taba$gen))

maxy.time.soc<-rbind(maxy.time.soc,taba)

 }

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


save(range.shift.soc,file="RangeShift_soc_0.4.RData")
 save(maxy.time.soc,file="maxy_time_soc_0.4.RData")

 setwd("C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/Outputs/Random0.2")
 
 nam<-list.files(pattern="_pop.txt")
 #nam<-nam[grep("_Em_3_Evolprosp_0_Evolemigr_0_pop",nam)]
 
 range.shift.rand<-NULL
 maxy.time.rand<-NULL
 
 for (i in 1:length(nam)){
   print(c(i,nam[i]))
   tab<-read.table(nam[i],header=T)
   matches <- regmatches(nam[i], gregexpr("[[:digit:]]+\\.*[[:digit:]]*", nam[i]))
   num<-as.numeric(unlist(matches))
   
   tab$CellRange<-num[1]
   tab$ProspPatch<-num[2]
   tab$Rate<-num[3]
   tab$Scen<-ifelse(num[4]==3,tab$Scen<-"Pers + public", tab$Scen<-"Random")
   
   print(c(tab$CellRange[1],tab$ProspPatch[1],tab$Rate[1]))
   
   tabou<-subset(tab,tab$sim==5)
   
   
   ##Range shifting rate
   tabo<-subset(tab, tab$gen==max(tab$gen) & tab$Nadult>0)
   tabou<-ddply(tabo,.(sim,CellRange,ProspPatch,Rate,Scen),summarize,RangeShift=(max(y)-2)/100,
                Nad=sum(Nadult),NDisp=sum(NDisp),Nim=sum(Nimmigr))
   range.mean<-ddply(tabou,.(CellRange,ProspPatch,Rate,Scen),summarize,
                     RangeShift.mean=mean(RangeShift), Nad.mean=mean(Nad),
                     NDisp.mean=mean(NDisp),Nimmigr.mean=mean(Nim),
                     RangeShift.se=std.error(RangeShift),Nad.se=std.error(Nad),
                     NDisp.se=std.error(NDisp),Nimmigr.se=std.error(Nim))
   
   range.shift.rand<-rbind(range.shift.rand,range.mean)
   
   
   
   ##Dynamics of range expansion over time
   taba<-ddply(tab,.(sim,gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
   taba<-ddply(taba,.(gen,y,CellRange,ProspPatch,Rate,Scen),summarize,yAdm=mean(yAd),yAdse=std.error(yAd), yDispm=mean(yDisp),
               yDispse=std.error(yDisp),yImmigrm=mean(yImmigr),yImmigrse=std.error(yImmigr))
   #taba<-subset(taba,taba$gen==max(taba$gen))
   
   maxy.time.rand<-rbind(maxy.time.rand,taba)
   
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
 
 
 
 save(range.shift.rand,file="RangeShift_rand_0.2.RData")
 save(maxy.time.rand,file="maxy_time_rand_0.2.RData")
 
 