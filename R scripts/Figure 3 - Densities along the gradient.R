source("R scripts/Source.R")
load("Data/maxy_time_rand_0.5.RData")
load("Data/maxy_time_soc_0.85.RData")

xx.rand<-subset(maxy.time.rand,maxy.time.rand$gen==max(maxy.time.rand$gen))
xx.rand<-subset(xx.rand,xx.rand$Rate==0.1|  xx.rand$Rate==0.5|
                    xx.rand$Rate==0.7 | xx.rand$Rate==1)
xx.rand<-subset(xx.rand,xx.rand$ProspPatch==0 |xx.rand$ProspPatch==2|xx.rand$ProspPatch==8|
                   xx.rand$ProspPatch==16)
xx.rand<-droplevels(xx.rand)

xx.soc<-subset(maxy.time.soc,maxy.time.soc$gen==max(maxy.time.soc$gen))
xx.soc<-subset(xx.soc,xx.soc$Rate==0.1 |  xx.soc$Rate==0.5|
                   xx.soc$Rate==0.7 | xx.soc$Rate==1)
xx.soc<-subset(xx.soc,xx.soc$ProspPatch==0 |xx.soc$ProspPatch==2|xx.soc$ProspPatch==8|
                   xx.soc$ProspPatch==16)
xx.soc<-droplevels(xx.soc)

yyy<-rbind(xx.soc,xx.rand)

# yyy<- xx %>% 
#     group_by(gen,y,CellRange,ProspPatch,Rate,Scen) %>% 
#     summarise(yAdm=mean(yAd,na.rm=T),yAdse=std.error(yAd,na.rm=T))

yyy$CellRange <-as.factor(paste0("Perceptual range: ",yyy$CellRange))
yyy$Preference <-as.factor(paste0("Preference: ", yyy$Rate))
yyy$Settlement<- revalue(yyy$Scen, c("Pers + public" = "Informed",
                                     "Non-informed" = "Non-informed"))



tiff("Figures/Figure 3 - Mean Densities towards front.tif",res=600,compression="lzw", width=5000,height=3000)
ggx<-ggplot(yyy,aes(y,yAdm,group=interaction(Settlement,ProspPatch),fill=ProspPatch))+
    geom_line(aes(colour=ProspPatch,linetype=Settlement),lwd=0.5) +
    scale_linetype_manual(values=c("solid", "dotted")) +
    geom_ribbon(aes(ymin=yAdm-yAdse, ymax=yAdm+yAdse,colour=ProspPatch), 
                alpha=0.4, linetype=0)   +   
    scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
    scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
    facet_grid(Preference~CellRange,scales="free_x") +
   labs(x="Distance from first row",y="Mean number or adults",
        fill="Prospected\npatches", colour="Prospected\npatches",linetype=NULL)+
    scale_x_continuous(expand=c(0.01,0.01)) + #breaks=seq(0,250,50),labels=seq(0,250,50), limits=c(0,250)
   
    scale_y_continuous(breaks=seq(0,600,200),expand=c(0.01,0.01),limits=c(0,650)) +
    guides(linetype=FALSE) +
    theme(legend.position = "right",
          text = element_text(size=10),
          axis.text = element_text(size=8),
          legend.text = element_text(size=8),
          legend.title=element_text(size=8),
          panel.spacing = unit(0.75, "lines"))

print(ggx)
dev.off()
rm(list=ls())
##Figure for the supplemental material

load("Data/maxy_time_rand_0.5.RData")
load("Data/maxy_time_soc_0.85.RData")


zzz<-rbind(maxy.time.soc,maxy.time.rand)

# zzz<- ww %>% 
#     group_by(gen,y,CellRange,ProspPatch,Rate,Scen) %>% 
#     summarise(yAdm=mean(yAd,na.rm=T),yAdse=std.error(yAd,na.rm=T))

colnames(zzz)[3]<-"Perceptual_Range"
colnames(zzz)[5]<-"Preference"

tiff("Figures/Supplemental material - All Mean Densities towards front.tif",res=600,compression="lzw", width=5000,height=6500)
ggx<-ggplot(zzz,aes(y,yAdm,group=interaction(Scen,ProspPatch),fill=ProspPatch))+
    geom_line(aes(colour=ProspPatch,linetype=Scen),size=0.8) +
    scale_linetype_manual(values=c("solid", "dotted")) +
    geom_ribbon(aes(ymin=yAdm-yAdse, ymax=yAdm+yAdse,colour=ProspPatch), 
                alpha=0.4, linetype=0, size=0.5)   +   
    scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
    scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
    facet_grid(Preference~Perceptual_Range,scales="free_x",labeller = "label_both") +
    labs(x="Distance from first row",y="Mean number of adults",
         fill="Prospected\npatches", colour="Prospected\npatches",linetype=NULL)+
    scale_x_continuous(expand=c(0.01,0.01)) + #breaks=seq(0,250,50),labels=seq(0,250,50), limits=c(0,250)
    
    scale_y_continuous(breaks=seq(0,600,200),expand=c(0.01,0.01),limits=c(0,650)) +
    guides(linetype=FALSE) +
    theme(legend.position = "right",
          text = element_text(size=10),
          axis.text = element_text(size=8),
          legend.text = element_text(size=8),
          legend.title=element_text(size=8),
          panel.spacing = unit(0.75, "lines"))

print(ggx)
dev.off()

