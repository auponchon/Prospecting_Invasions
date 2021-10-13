library(raster)
grid<-raster(ymn=0,ymx=10,xmn=0,xmx=10,res=1,vals=1,crs=NA)
grid[c(8:10),]<-20  #occupied patch
grid[8,5]<-100  #current occupied patch
grid[10,7]<-60
grid[8,4]<-60
grid[7,5]<-60
grid[6,3]<-60

dat<-as.data.frame(grid,xy=T)
dat$Fac<-"None"
dat$Fac[dat$layer>1 | dat$Layer <100]<-"I"

library(ggplot2)
library(viridis)


p = ggplot(dat, aes(x=x, y=y, fill=layer)) +
  geom_tile(colour="grey50",size=0.6,alpha=0.7) +
  scale_x_discrete( limits=0:10,expand=c(.01,0),labels=NULL)+
  scale_y_discrete( limits=0:20,expand=c(0.015,0),labels=NULL) +
  labs(x="",y="") + 
  scale_fill_gradientn(colours = rev(magma(4))) +
  geom_rect(mapping=aes(xmin=2, xmax=7, ymin=0, ymax=5),color="black", fill=alpha("grey",0),
            size = 2 ) + 
  geom_segment(aes(x=0, xend=10, y=3, yend=3),linetype=2,size=1,color="#ECB176FF") +
  annotate("segment", x = 5, xend = 7, y = -0.3, yend = -0.3, 
           colour = "black", size=0.8, arrow=arrow(length = unit(0.3, "cm"))) +
  annotate("text",x=6,y=-0.6,label="Perceptual range")+
  annotate("segment", x = -0.3, xend = -0.3, y = 0, yend = 3, 
           colour = "black", size=0.8, arrow=arrow(length = unit(0.3, "cm"))) +
    annotate("text",x=-0.6,y=1.5,label="Initial occupancy",angle=90) +
    annotate("segment", x = -0.3, xend = -0.3, y = 3.5, yend = 6, linetype=2,
             colour = "black", size=0.8, arrow=arrow(length = unit(0.3, "cm"))) +
  annotate("text",x=-0.6,y=4.5,label="Range shift",angle=90) +
  theme(legend.position = "none",
        panel.grid = element_blank(),
#        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank())
  
print(p)

 ggsave("Figure 1 - Modelling of prospecting.jpg", plot=p, height=6, width=6, dpi=300)
