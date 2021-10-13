source("Source.R")
load("Data/maxy_time_rand_0.5.RData")
load("Data/maxy_time_soc_0.85.RData")

xx.rand<-subset(maxy.time.rand,maxy.time.rand$Rate==0.1 |  maxy.time.rand$Rate==0.5|
                    maxy.time.rand$Rate==0.7 | maxy.time.rand$Rate==1)
xx.rand<-subset(xx.rand,xx.rand$ProspPatch==0 |xx.rand$ProspPatch==4|
                    xx.rand$ProspPatch==12)
xx.rand<-droplevels(xx.rand)

xx.soc<-subset(maxy.time.soc,maxy.time.soc$Rate==0.1 |  maxy.time.soc$Rate==0.5|
                   maxy.time.soc$Rate==0.7 | maxy.time.soc$Rate==1)
xx.soc<-subset(xx.soc,xx.soc$ProspPatch==0 |xx.soc$ProspPatch==4|
                   xx.soc$ProspPatch==12)
xx.soc<-droplevels(xx.soc)


xx<-rbind(xx.soc,xx.rand)
yy<-subset(xx,xx$yAdm>0 )



##Selection of patches with less than X individuals
yy<-subset(xx,xx$yAdm>0 )
front.all<-subset(yy,yy$yAdm<200)
front<-front.all %>% 
    group_by(gen,CellRange,ProspPatch,Rate,Scen) %>% 
    summarize(Front=max(y)-min(y))

colnames(front)[c(2,4)]<-c("Perceptual_Range","Preference")              

frontgg<-ggplot(front,aes(gen,Front,group=interaction(Scen,ProspPatch),fill=ProspPatch))+
    geom_line(aes(colour=ProspPatch,linetype=Scen),size=0.8) +
    scale_linetype_manual(values=c("solid", "dotted")) +
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
          axis.text = element_text(size=10),
          legend.text = element_text(size=8),
          panel.spacing = unit(0.75, "lines"))

print(frontgg)
