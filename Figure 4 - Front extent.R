source("Source.R")
load("Data/front_size_soc_0.85.RData")
load("Data/front_size_rand_0.5.RData")


xx.rand<-subset(front.,xx.rand$Rate==0|  xx.rand$Rate==0.5|
                    xx.rand$Rate==0.7 | xx.rand$Rate==1)
xx.rand<-subset(xx.rand,xx.rand$ProspPatch==0 |xx.rand$ProspPatch==2|xx.rand$ProspPatch==8|
                    xx.rand$ProspPatch==16)
xx.rand<-droplevels(xx.rand)


front.soc2<-subset(front.size.soc,front.size.soc$Rate==0.1 |  front.size.soc$Rate==0.5|
                   front.size.soc$Rate==0.7 | front.size.soc$Rate==1)

# front.soc1<-subset(front.soc2,front.soc2$ProspPatch==0 |front.soc2$ProspPatch==2|front.soc2$ProspPatch==8|
#                        front.soc2$ProspPatch==16)
front.soc<-droplevels(front.soc1)

front<-rbind(front.soc,xx.rand)
front<-subset(front,front$Frontm>1)


##Selection of patches with less than X individuals

colnames(front)[c(2,4)]<-c("Perceptual_Range","Preference")              

frontgg<-ggplot(front,aes(x=gen,y=Frontm,group=ProspPatch,fill=ProspPatch))+
    geom_line(aes(colour=ProspPatch),size=0.8) +
  #  scale_linetype_manual(values=c("solid","dotted")) +
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
