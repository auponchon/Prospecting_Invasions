source("Source.R")


zzz.rand<-subset(maxy.time.rand,maxy.time.rand$Rate==0 | maxy.time.rand$Rate==0.3| maxy.time.rand$Rate==0.5|
                maxy.time.rand$Rate==0.7 | maxy.time.rand$Rate==1)
zzz.rand<-subset(zzz.rand,zzz.rand$ProspPatch=="0" | zzz.rand$ProspPatch=="4"| 
                     zzz.rand$ProspPatch=="8"|  zzz.rand$ProspPatch=="16")

zzz.rand<-subset(zzz.rand,zzz.rand$yAdm>0)

gdensran<-ggplot(zzz.rand,aes(x=gen,y=y)) + 
    geom_tile(aes(fill=yAdm))+
    facet_grid(Rate~CellRange+ProspPatch) + 
    scale_fill_gradientn(limits=c(0,700), 
                         colours=plasma(100),
                         aesthetics = "fill") +
    scale_y_continuous(breaks=seq(0,250,50),expand = c(0.01,0.01)) +
    scale_x_continuous(breaks=seq(0,100,50),labels=NULL,expand = c(0.01, 0.01)) +
    labs(tag="a)",x="",y="Distance from first row", fill = "Nb of adults") +
    theme_bw() +
    theme(legend.position = "none",
        text = element_text(size=10),
        axis.text = element_text(size=8),
        panel.spacing = unit(0.75, "lines"))
  #  guides(fill = guide_colorbar(barwidth = 1, barheight = 15)) +
    
print(gdensran)


zzz.soc<-subset(maxy.time.soc,maxy.time.soc$Rate==0 | maxy.time.soc$Rate==0.3| maxy.time.soc$Rate==0.5|
                     maxy.time.soc$Rate==0.7 | maxy.time.soc$Rate==1)
zzz.soc<-subset(zzz.soc,zzz.soc$ProspPatch=="0" | zzz.soc$ProspPatch=="4"| 
                    zzz.soc$ProspPatch=="8"|  zzz.soc$ProspPatch=="16")


zzz.soc<-subset(zzz.soc,zzz.soc$yAdm>0)

gdenssoc<-ggplot(zzz.soc,aes(x=gen,y=y)) + 
    geom_tile(aes(fill=yAdm))+
    facet_grid(Rate~CellRange+ProspPatch) + 
    scale_fill_gradientn(limits=c(0,700), 
                         colours=plasma(100),
                         aesthetics = "fill") +
    scale_y_continuous(breaks=seq(0,150,25),limits=c(0,150),expand = c(0.01,0.01)) +
    scale_x_continuous(breaks=seq(0,100,50),expand = c(0.01, 0.01)) +
    labs(tag="b)",x="Years",y="Distance from first row", fill = "Nb of adults") +
    theme_bw() +
    theme(legend.position = "none",
          text = element_text(size=10),
          axis.text = element_text(size=8),
          panel.spacing = unit(0.75, "lines"))
print(gdenssoc)


leg<-ggplot(zzz.soc,aes(x=gen,y=y)) + 
    geom_tile(aes(fill=yAdm))+
    facet_grid(Rate~CellRange+ProspPatch) + 
    scale_fill_gradientn(limits=c(0,700), 
                         colours=plasma(100),
                         aesthetics = "fill") +
    labs(x="Years",y="Distance from first row", fill = "Nb of adults") +
  guides(fill = guide_colorbar(barwidth = 1, barheight = 10)) 

mylegend<-g_legend(leg)
    
tiff("Figures/Fig 4 - Densities over time.tif",res=400,compression="lzw", 
     width=4000,height=3000)
 
grid.arrange(arrangeGrob(gdensran,gdenssoc,nrow=2), mylegend, 
                  ncol=2,widths=c(1,0.1))
dev.off()

