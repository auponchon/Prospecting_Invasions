source("Source.R")

rs<-rbind(range.shift.soc,range.shift.rand)

tiff("Figures/Supplemental Mat - number of adults.tif",res=400,compression="lzw", 
     width=3500,height=1500)

gnad<-ggplot(rs,aes(x=Rate,y=Nad.mean,group=interaction(Scen,ProspPatch),fill=ProspPatch)) +
    geom_point(aes(colour=ProspPatch,shape=Scen),size=2) +
    geom_line(aes(colour=ProspPatch,linetype=Scen)) +
    scale_linetype_manual(values=c("solid", "dotted"))+
    labs(x="Probability of selecting an empty patch",y="Total number of adults",
         fill="Prospected\npatches",colour="Prospected\npatches")+
    scale_x_discrete(breaks=seq(0,1,0.2),expand=c(0.01,0.01)) +
    scale_y_continuous(breaks=seq(0,65000,15000),expand=c(0.005,0.005),limits=c(0,65000)) +
    scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
    scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
    geom_ribbon(aes(ymin=Nad.mean-Nad.se,
                    ymax=Nad.mean+Nad.se), 
                alpha=0.3, linetype=0,  size=0.5) +
    facet_grid(.~CellRange) +
    guides(linetype=FALSE,shape=FALSE,line=FALSE) +
    theme(#legend.position = "none",
        text = element_text(size=10),
        axis.text = element_text(size=10),
        legend.text = element_text(size=8),
        panel.spacing = unit(0.75, "lines"))
print(gnad)
dev.off()
