source("source.R")

#######################################
#Format data for informed emigration
pathy<-"C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/Outputs/Informed0.85/"
nam<-list.files(path=pathy, pattern="_pop.txt")

onerep.soc<-NULL

for (i in 1:length(nam)){
    print(c(i,nam[i]))
    
    matches <- regmatches(nam[i], gregexpr("[[:digit:]]+\\.*[[:digit:]]*", nam[i]))
    num<-as.numeric(unlist(matches))
    
    if(num[2]==0 | num[2]==2 | num[2]==8 | num[2]==16){
        if(num[3]==0 | num[3]==0.5 |  num[3]==0.9){   
            
     #Identify scenario
    tab<-read.table(paste0(pathy,nam[i]),header=T)
    tab$CellRange<-num[1]
    tab$ProspPatch<-num[2]
    tab$Rate<-num[3]
    tab$Scen<-ifelse(num[4]==3,tab$Scen<-"Pers + public", tab$Scen<-"Non-informed")
    
    print(c(tab$CellRange[1],tab$ProspPatch[1],tab$Rate[1]))
    
    tabo<-subset(tab, tab$sim==1 & tab$Nadult>0)
    
    onerep.soc<-rbind(onerep.soc,tabo)
        }
    }}

onerep.soc$CellRange<-as.factor(onerep.soc$CellRange)
onerep.soc$ProspPatch<-as.factor(onerep.soc$ProspPatch)
onerep.soc$Rate<-1-onerep.soc$Rate
onerep.soc$Rate<-as.factor(onerep.soc$Rate)
onerep.soc$Scen<-as.factor(onerep.soc$Scen)

save(onerep.soc,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/onerep_soc_0.85.RData")

#######################################
#Format data for non-informed emigration
rm(list=ls())

patho<-"C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/Outputs/Random0.5/"
nam<-list.files(path=patho, pattern="_pop.txt")

onerep.rand<-NULL

for (i in 1:length(nam)){
    print(c(i,nam[i]))
    
   
    matches <- regmatches(nam[i], gregexpr("[[:digit:]]+\\.*[[:digit:]]*", nam[i]))
    num<-as.numeric(unlist(matches))
    
    if(num[2]==0 | num[2]==2 | num[2]==8 | num[2]==16){
    if(num[3]==0 | num[3]==0.5 |  num[3]==0.9){   
    
    tab<-read.table(paste0(patho,nam[i]),header=T)
    tab$CellRange<-num[1]
    tab$ProspPatch<-num[2]
    tab$Rate<-num[3]
    tab$Scen<-ifelse(num[4]==3,tab$Scen<-"Pers + public", tab$Scen<-"Non-informed")
    
    print(c(tab$CellRange[1],tab$ProspPatch[1],tab$Rate[1]))

        taba<-subset(tab, tab$sim==1 & tab$Nadult>0)
    
        onerep.rand<-rbind(onerep.rand,taba)
    }
    }
}

onerep.rand$CellRange<-as.factor(onerep.rand$CellRange)
onerep.rand$ProspPatch<-as.factor(onerep.rand$ProspPatch)
onerep.rand$Rate<-1-onerep.rand$Rate
onerep.rand$Rate<-as.factor(onerep.rand$Rate)
onerep.rand$Scen<-as.factor(onerep.rand$Scen)

save(onerep.rand,file="C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2021-06-07 - Prospecting invasion/ProspectingInvasion/ProspectingInvasion/R codes/Prospecting_Invasions/Data/onerep_rand_0.5.RData")

