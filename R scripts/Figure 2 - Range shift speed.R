load("Data/RangeShift_soc_0.85.RData")
load("Data/RangeShift_rand_0.5.RData")
##Range shift for random

source("R scripts/source.R")

labi<-paste("Speed of range expansion (row.year\u207b\u00b9)",sep="")
rs<-rbind(range.shift.soc,range.shift.rand)
rs$CellRange<-paste0("Perceptual range: ",rs$CellRange)
rs$Settlement<- revalue(rs$Scen, c("Pers + public" = "Informed",
                                    "Non-informed" = "Non-informed"))


tiff("Figures/Figure 2 - Range_shift_rate.tif",res=600,compression="lzw", width=5000,height=2300)


grs<-ggplot(rs,aes(x=Rate,y=RangeShift.mean,group=interaction(Settlement,ProspPatch),fill=ProspPatch)) +
    geom_point(aes(colour=ProspPatch,shape=Settlement),size=1.8) +
    geom_line(aes(colour=ProspPatch,linetype=Settlement),lwd=0.3) +
    scale_linetype_manual(values=c("solid", "dotted"))+
    labs(x="Probability of selecting an empty patch",y=labi,
         fill="Prospected\npatches",colour="Prospected\npatches")+
    scale_x_discrete(breaks=seq(0,1,0.2),expand=c(0.01,0.01)) +
    scale_y_continuous(breaks=seq(0,2.5,0.5),expand=c(0.005,0.005),limits=c(0,2.5)) +
    scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
    scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
    geom_ribbon(aes(ymin=RangeShift.mean-RangeShift.se,
                    ymax=RangeShift.mean+RangeShift.se), 
                alpha=0.3, linetype=0,  size=0.5) +
    geom_point(data=subset(rs,rs$ProspPatch==0),aes(shape=Settlement),size=2,color=inferno(100)[1],show.legend=F) +
   geom_line(data=subset(rs,rs$ProspPatch==0),aes(linetype=Settlement),color=inferno(100)[1],show.legend=F) +
    facet_grid(.~CellRange) +
#    guides(linetype=T,shape=T,line=FALSE) +
    theme(#legend.position = "none",
          text = element_text(size=10),
          axis.text = element_text(size=8),
          legend.text = element_text(size=8),
          legend.title=element_text(size=8),
          panel.spacing = unit(0.75, "lines"))
print(grs)
dev.off()
