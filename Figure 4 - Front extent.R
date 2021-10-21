source("Source.R")
# load("Data/front_size_soc_0.85.RData")
# load("Data/front_size_rand_0.5.RData")

load("Data/sum_x_soc_0.85.RData")
load("Data/sum_x_rand_0.5.RData")


xxx<-which(sum.x.soc$Rate==0 & sum.x.soc$ProspPatch!=0)
sum.soc<-sum.x.soc[-xxx,]
tobo<-subset(sum.soc,sum.soc$yAd<=100)
tobo<-droplevels(tobo)
  toba<-ddply(tobo,.(sim,gen,CellRange,ProspPatch,Rate,Scen),summarize,
              Max.y=max(y),Min.y=min(y),Front.sim=max(y)-min(y))
  toby<-ddply(toba,.(gen,CellRange,ProspPatch,Rate,Scen),summarize,
              Frontm=mean(Front.sim, na.rm=T),Frontse=std.error(Front.sim,na.rm=T))

  front.size.soc<-toby
  
  yyy<-which(sum.x.rand$Rate==0 & sum.x.rand$ProspPatch!=0)
  sum.rand<-sum.x.rand[-yyy,]
  toto<-subset(sum.rand,sum.rand$yAd<=100)
  tota<-droplevels(toto)
  tota<-ddply(tota,.(sim,gen,CellRange,ProspPatch,Rate,Scen),summarize,
              Max.y=max(y),Min.y=min(y),Front.sim=max(y)-min(y))
  toty<-ddply(tota,.(gen,CellRange,ProspPatch,Rate,Scen),summarize,
              Frontm=mean(Front.sim, na.rm=T),Frontse=std.error(Front.sim,na.rm=T))
  
  front.size.rand<-toty
  
  
front.rand<-subset(front.size.rand,front.size.rand$Rate==0|  front.size.rand$Rate==0.5|
                  front.size.rand$Rate==0.7 | front.size.rand$Rate==1)
front.rand<-subset(front.rand,front.rand$ProspPatch==0 |front.rand$ProspPatch==2|front.rand$ProspPatch==8|
                     front.rand$ProspPatch==16)
front.rand<-droplevels(front.rand)


front.soc2<-subset(front.size.soc, front.size.soc$Rate==0|  front.size.soc$Rate==0.5|
                   front.size.soc$Rate==0.7 | front.size.soc$Rate==1)

front.soc1<-subset(front.soc2,front.soc2$ProspPatch==0 |front.soc2$ProspPatch==2|front.soc2$ProspPatch==8|
                       front.soc2$ProspPatch==16)
front.soc<-droplevels(front.soc1)

front<-rbind(front.soc,front.rand)


##Selection of patches with less than X individuals

colnames(front)[c(2,4)]<-c("Perceptual_Range","Preference")              

tiff("Figures/Figure 4 - Front extent.tif",res=600,compression="lzw", width=5000,height=3000)
frontgg<-ggplot(front,aes(x=gen,y=Frontm,group=interaction(Scen,ProspPatch),fill=ProspPatch))+
    geom_line(aes(colour=ProspPatch,linetype=Scen),size=0.8) +
    scale_linetype_manual(values=c("solid","dotted")) +
    geom_ribbon(aes(ymin=Frontm-Frontse, ymax=Frontm+Frontse,colour=ProspPatch), 
              alpha=0.4, linetype=0, size=0.5)   +
    scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
    scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
    facet_grid(Preference~Perceptual_Range,scales="free",labeller = "label_both") +
    labs(x="Years",y="Front extent",
         fill="Prospected\npatches", colour="Prospected\npatches",linetype=NULL)+
    scale_x_continuous(expand=c(0.01,0.01)) + #breaks=seq(0,250,50),labels=seq(0,250,50), limits=c(0,250)
#    scale_y_continuous(breaks=seq(0,150,30),expand=c(0.01,0.01),limits=c(0,150)) +
    guides(linetype=FALSE) +
    theme(legend.position = "right",
          text = element_text(size=10),
          axis.text = element_text(size=8),
          legend.text = element_text(size=8),
          legend.title=element_text(size=8),
          panel.spacing = unit(0.75, "lines"))

print(frontgg)
dev.off()


################################################################
# TOTAL FIGURE
rm(list=ls())

source("Source.R")
load("Data/front_size_soc_0.85.RData")
load("Data/front_size_rand_0.5.RData")
front<-rbind(front.size.soc,front.size.rand)
front<-subset(front,front$Frontm>1)

# front<-subset(front,front$Rate==0.1| front$Rate==0.3| front$Rate==0.5|
#                 front$Rate==0.7 | front$Rate==1)

colnames(front)[c(2,4)]<-c("Perceptual_Range","Preference")              

tiff("Figures/Supplemental material - Front extent.tif",res=600,compression="lzw", width=5000,height=6500)
frontgg<-ggplot(front,aes(x=gen,y=Frontm,group=interaction(Scen,ProspPatch),fill=ProspPatch))+
  geom_line(aes(colour=ProspPatch,linetype=Scen),size=0.8) +
  scale_linetype_manual(values=c("solid","dotted")) +
  geom_ribbon(aes(ymin=Frontm-Frontse, ymax=Frontm+Frontse,colour=ProspPatch), 
              alpha=0.4, linetype=0, size=0.5)   +
  scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
  scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
  facet_grid(Preference~Perceptual_Range,scales="free",labeller = "label_both") +
  labs(x="Years",y="Front extent",
       fill="Prospected\npatches", colour="Prospected\npatches",linetype=NULL)+
  scale_x_continuous(expand=c(0.01,0.01)) + #breaks=seq(0,250,50),labels=seq(0,250,50), limits=c(0,250)
  #    scale_y_continuous(breaks=seq(0,150,30),expand=c(0.01,0.01),limits=c(0,150)) +
  guides(linetype=FALSE) +
  theme(legend.position = "right",
        text = element_text(size=10),
        axis.text = element_text(size=8),
        legend.text = element_text(size=8),
        legend.title=element_text(size=8),
        panel.spacing = unit(0.75, "lines"))

print(frontgg)
dev.off()

