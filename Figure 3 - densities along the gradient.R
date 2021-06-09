source("Source.R")

xx.rand<-subset(maxy.time.rand,maxy.time.rand$gen==max(maxy.time.rand$gen))
xx.rand<-subset(xx.rand,xx.rand$Rate==0 | xx.rand$Rate==0.2|  xx.rand$Rate==0.5|
                    xx.rand$Rate==0.8 | xx.rand$Rate==1)

xx.soc<-subset(maxy.time.soc,maxy.time.soc$gen==max(maxy.time.soc$gen))
xx.soc<-subset(xx.soc,xx.soc$Rate==0 | xx.soc$Rate==0.2|  xx.soc$Rate==0.5|
                   xx.soc$Rate==0.8 | xx.soc$Rate==1)

xx<-rbind(xx.soc,xx.rand)

# g4<-ggplot(xx.rand,aes(y,yAdm,group=ProspPatch,colour=ProspPatch,fill=ProspPatch))+
#     geom_line(size=1.2, ) +
#     geom_ribbon(aes(ymin=yAdm-yAdse, ymax=yAdm+yAdse), 
#                 alpha=0.5, linetype=0, size=0.5)   +   
#     scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
#     scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
#     facet_grid(Rate~CellRange)+
#     labs(tag = "a)",x="",y="Number of adults")+
#     scale_x_continuous(breaks=seq(0,200,50),labels=seq(0,200,50),expand=c(0.01,0.01),
#                        limits=c(0,251)) +
#     scale_y_continuous(breaks=seq(0,700,200),expand=c(0.01,0.01),limits=c(0,700)) +
#     theme(legend.position = "none",
#           text = element_text(size=10),
#           axis.text = element_text(size=8),
#           legend.text = element_text(size=8),
#           panel.spacing = unit(0.75, "lines"))
# 
# print(g4)
# 
# g5<-ggplot(xx.soc,aes(y,yAdm,group=ProspPatch,colour=ProspPatch,fill=ProspPatch))+
#     geom_line(size=1.2) +
#     geom_ribbon(aes(ymin=yAdm-yAdse, ymax=yAdm+yAdse), 
#                 alpha=0.5, linetype=0, size=0.5)   +   
#     scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
#     scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
#     facet_grid(Rate~CellRange)+
#     labs(tag = "b)",x="",y="Number of adults")+
#     scale_x_continuous(breaks=seq(0,200,50),labels=seq(0,200,50),expand=c(0.01,0.01),
#                        limits=c(0,251)) +
#     scale_y_continuous(breaks=seq(0,600,200),expand=c(0.01,0.01),limits=c(0,650)) +
#     theme(legend.position = "none",
#           text = element_text(size=10),
#           axis.text = element_text(size=8),
#           legend.text = element_text(size=8),
#           panel.spacing = unit(0.75, "lines"))
# 
# print(g5)
# 
# 
# leg<-ggplot(xx.soc,aes(y,yAdm,group=ProspPatch,colour=ProspPatch,fill=ProspPatch))+
#     geom_line() +
#     geom_ribbon(aes(ymin=yAdm-yAdse, ymax=yAdm+yAdse), 
#                 alpha=0.5, linetype=0, size=0.5)   +   
#     scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno", "Prospected\npatches") +
#     scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno", "Prospected\npatches") +
#     facet_grid(Rate~CellRange)
# mylegend<-g_legend(leg)
# 
# grid.arrange(arrangeGrob(g4,g5,nrow=2), mylegend, 
#              ncol=2,widths=c(1,0.1))


tiff("Figures/Fig 3 - Densities towards front2.tif",res=400,compression="lzw", width=3500,height=2000)
ggx<-ggplot(xx,aes(y,yAdm,group=interaction(Scen,ProspPatch),fill=ProspPatch))+
    geom_line(aes(colour=ProspPatch,linetype=Scen),size=0.8) +
    scale_linetype_manual(values=c("solid", "dotted"))+
    geom_ribbon(aes(ymin=yAdm-yAdse, ymax=yAdm+yAdse,colour=ProspPatch), 
                alpha=0.4, linetype=0, size=0.5)   +   
    scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
    scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
    facet_grid(Rate~CellRange,scales="free_x")+
   labs(x="Distance from first row",y="Number of adults",
        fill="Prospected\npatches", colour="Prospected\npatches",linetype=NULL)+
    scale_x_continuous(expand=c(0.01,0.01)) + #breaks=seq(0,250,50),labels=seq(0,250,50), limits=c(0,250)
   
    scale_y_continuous(breaks=seq(0,600,200),expand=c(0.01,0.01),limits=c(0,650)) +
    guides(linetype=FALSE) +
    theme(legend.position = "right",
          text = element_text(size=10),
          axis.text = element_text(size=10),
          legend.text = element_text(size=8),
          panel.spacing = unit(0.75, "lines"))

print(ggx)
dev.off()

