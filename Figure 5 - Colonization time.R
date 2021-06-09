source("Source.R")

#Load data
load("Data/ALL_soc.RData")
ALL.soc<-ALL
ALL.soc$Scen<-"Pers + public"
ALL.soc$Scen<-as.factor(ALL.soc$Scen)
load("Data/ALL_random.RData")
ALL.rand<-ALL
ALL.rand$Scen<-"Random"
ALL.rand$Scen<-as.factor(ALL.rand$Scen)

rm(ALL)


##Range shift
#Assign scenarios to data
ALL.soc$CellRange<-as.factor(ALL.soc$CellRange)
ALL.soc$ProspPatch<-as.factor(ALL.soc$ProspPatch)
ALL.soc$Rate<-as.factor(ALL.soc$Rate)
ALL.soc<-subset(ALL.soc,ALL.soc$ProspPatch!="1")
ALL.soc$gen<-ALL.soc$gen-200


#Assign scenarios to data
ALL.rand$CellRange<-as.factor(ALL.rand$CellRange)
ALL.rand$ProspPatch<-as.factor(ALL.rand$ProspPatch)
ALL.rand$Rate<-as.factor(ALL.rand$Rate)
ALL.rand<-subset(ALL.rand,ALL.rand$ProspPatch!="1")
ALL.rand$gen<-ALL.rand$gen-200

#get data from random emigration
suby.rand<-subset(ALL.rand,ALL.rand$gen<50 & ALL.rand$y>3)
xx.rand<-sample(suby.rand$PatchID,1,replace=F)
suby.rand<-subset(suby.rand,suby.rand$PatchID %in% xx.rand & suby.rand$Nadult>0)

suby.rand<-suby.rand[order(suby.rand$CellRange, suby.rand$ProspPatch,
                           suby.rand$Rate,suby.rand$PatchID,suby.rand$gen,suby.rand$x,suby.rand$y),]

year.rand<-ddply(suby.rand,.(CellRange,ProspPatch,Rate,PatchID,x,y),summarize,Min=min(gen))
s.rand<-merge(suby.rand,year.rand,by=c("CellRange","ProspPatch","Rate","PatchID","x","y"))
s.rand$Year<-s.rand$gen-s.rand$Min



#get data from public emigration
suby.soc<-subset(ALL.soc,ALL.soc$gen<50 & ALL.soc$y>3)
xx.soc<-sample(suby.soc$PatchID,10,replace=F)
suby.soc<-subset(suby.soc,suby.soc$PatchID %in% xx.soc & suby.soc$Nadult>0)

suby.soc<-suby.soc[order(suby.soc$CellRange, suby.soc$ProspPatch,
                           suby.soc$Rate,suby.soc$PatchID,suby.soc$gen,suby.soc$x,suby.soc$y),]

year.soc<-ddply(suby.soc,.(CellRange,ProspPatch,Rate,PatchID,x,y),summarize,Min=min(gen))
s.soc<-merge(suby.soc,year.soc,by=c("CellRange","ProspPatch","Rate","PatchID","x","y"))
s.soc$Year<-s.soc$gen-s.soc$Min


all<-rbind(s.rand,s.soc)

all<-subset(all,all)

ggx<-ggplot(all,aes(x=Year,y=Nadult,group=interaction(Scen,ProspPatch),fill=ProspPatch))+
    geom_line(aes(colour=ProspPatch,linetype=Scen),size=0.9) +
    scale_linetype_manual(values=c("solid", "dotted"))+
    scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
    facet_grid(Rate~CellRange)+
    labs(x="Years",y="Number of adults",
        colour="Prospected\npatches",linetype=NULL)+
    scale_x_continuous(breaks=seq(0,50,10),expand=c(0.01,0.01),
                       limits=c(0,50)) +
    scale_y_continuous(breaks=seq(0,60,20),expand=c(0.01,0.01),limits=c(0,60)) +
    guides(linetype=FALSE) +
    theme(legend.position = "right",
          text = element_text(size=10),
          axis.text = element_text(size=8),
          legend.text = element_text(size=8))
#        panel.spacing = unit(0.75, "lines"))

print(ggx)


