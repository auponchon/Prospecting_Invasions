load("Data/RangeShift_soc_0.85.RData")
load("Data/RangeShift_rand_0.5.RData")
##Range shift for random

source("source.R")

labi<-paste("Speed of range expansion (row.year\u207b\u00b9)",sep="")
rs<-rbind(range.shift.soc,range.shift.rand)


# g1<-ggplot(range.shift.soc,aes(x=Rate,y=RangeShift.mean,group=ProspPatch,fill=ProspPatch)) +
#     geom_point(aes(colour=ProspPatch)) +
#     geom_line(aes(colour=ProspPatch)) +
#     labs(tag = "b)",y=labi,  x="Probability of selecting an empty patch")+
#     scale_x_discrete(breaks=seq(0,1,0.2),labels=seq(0,1,0.2),expand=c(0.01,0.01)) +
#     scale_y_continuous(breaks=seq(0,2.5,0.5),expand=c(0.001,0.001),limits=c(0,2.5)) +
#     scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
#     scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
#     geom_ribbon(aes(ymin=RangeShift.mean-RangeShift.se,
#                     ymax=RangeShift.mean+RangeShift.se,group=ProspPatch), 
#                 alpha=0.3,       #transparency
#                 linetype=0,
#                 size=0.5) +
#     facet_grid(.~CellRange)+
#     theme(legend.position = "none",
#           text = element_text(size=10),
#           axis.text = element_text(size=8),
#           legend.text = element_text(size=8),
#           panel.spacing = unit(0.75, "lines"))
# print(g1)
# 
# g2<-ggplot(range.shift.rand,aes(x=Rate,y=RangeShift.mean,group=ProspPatch,fill=ProspPatch)) +
#     geom_point(aes(colour=ProspPatch)) +
#     geom_line(aes(colour=ProspPatch)) +
#     labs(tag = "a)")+
#     scale_x_discrete(breaks=seq(0,1,0.2),labels=NULL,expand=c(0.01,0.01)) +
#     scale_y_continuous(breaks=seq(0,2.5,0.5),expand=c(0.005,0.005),limits=c(0,2.5)) +
#     scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno") +
#     scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno") +
#     geom_ribbon(aes(ymin=RangeShift.mean-RangeShift.se,
#                     ymax=RangeShift.mean+RangeShift.se,group=ProspPatch), 
#                 alpha=0.3,       #transparency
#                 linetype=0,
#                 size=0.5) +
#     labs(y=labi,x="") +
#     facet_grid(.~CellRange) +
#     theme(legend.position = "none",
#           text = element_text(size=10),
#           axis.text = element_text(size=8),
#           legend.text = element_text(size=8),
#           panel.spacing = unit(0.75, "lines"))
# 
# print(g2)
# 
# 
# leg<-ggplot(range.shift.soc,aes(x=Rate,y=RangeShift.mean,group=ProspPatch,fill=ProspPatch)) +
#     geom_point(aes(colour=ProspPatch)) +
#     geom_line(aes(colour=ProspPatch)) +
#     geom_ribbon(aes(ymin=RangeShift.mean-RangeShift.se,
#                     ymax=RangeShift.mean+RangeShift.se,group=ProspPatch), 
#                 alpha=0.3,  linetype=0,      size=0.5) +
#     scale_fill_viridis(discrete = TRUE,end=0.8,option="inferno", "Prospected\npatches") +
#     scale_colour_viridis(discrete = TRUE,end=0.8,option="inferno", "Prospected\npatches") +
#     facet_grid(.~CellRange)
# mylegend<-g_legend(leg)
# 
# tiff("Figures/Fig 2 - Range_shift_2frames.tif",res=400,compression="lzw", width=5000,height=3500)
# grid.arrange(arrangeGrob(g2,g1,nrow=2,heights=c(1,1.1)), mylegend, 
#              ncol=2,widths=c(1,0.1))
# 
# dev.off()

tiff("Figures/Figure 2 - Range_shift_rate.tif",res=600,compression="lzw", width=5000,height=2500)
colnames(rs)[1]<-"Perceptual_Range"

grs<-ggplot(rs,aes(x=Rate,y=RangeShift.mean,group=interaction(Scen,ProspPatch),fill=ProspPatch)) +
    geom_point(aes(colour=ProspPatch,shape=Scen),size=2) +
    geom_line(aes(colour=ProspPatch,linetype=Scen)) +
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
    geom_point(data=subset(rs,rs$ProspPatch==0),aes(shape=Scen),size=2,color=inferno(100)[1],show.legend=F) +
   geom_line(data=subset(rs,rs$ProspPatch==0),aes(linetype=Scen),color=inferno(100)[1],show.legend=F) +
    facet_grid(.~Perceptual_Range,labeller=label_both) +
  #  scale_x_discrete(sec.axis=sec.axis(~.,name="Perceptual range",breaks = NULL, labels = NULL)))+
    guides(linetype=FALSE,shape=FALSE,line=FALSE) +
    theme(#legend.position = "none",
          text = element_text(size=10),
          axis.text = element_text(size=10),
          legend.text = element_text(size=8),
          panel.spacing = unit(0.75, "lines"))
print(grs)
dev.off()
