source("source.R")

library(gganimate)


load("Data/onerep_soc_0.85.RData")
load("Data/onerep_rand_0.5.RData")

anima<-rbind(onerep.soc,onerep.rand)
anima$gen<-anima$gen-199
names(anima)[c(13,15)]<-c("Perceptual_Range","Preference")



gganim<-ggplot(anima,aes(x=y,y=x))+
    geom_tile(aes(fill=log(Nadult))) +
    facet_grid(Preference + Scen ~ Perceptual_Range , labeller = "label_both") + 
    scale_fill_gradientn(limits=c(0,5),labels=seq(0,160,32),
                         colours=plasma(100),
                         aesthetics = "fill") +
    scale_y_continuous(breaks=seq(0,20,5),expand = c(0.01,0.01)) +
    scale_x_continuous(breaks=seq(0,220,50),labels=seq(0,220,50),expand = c(0.01, 0.01)) +
   labs(x="y",y="x", fill = "Nb of adults") +
    theme_bw() +
    theme(legend.position = "right",
          legend.title = element_text(size=8),
          axis.text = element_text(size=7),
          legend.text = element_text(size=7),
          panel.spacing = unit(0.5, "lines"),
          strip.text.x = element_text(size = 7),
          strip.text.y = element_text(size = 6))
#  guides(fill = guide_colorbar(barwidth = 1, barheight = 15)) +

#print(gganim)


my.animation <- gganim +
    transition_time(gen) +
    labs(subtitle = "Year: {round(frame_time,digits=0)}")

animate(my.animation, height = 2000, width =4000,res=400,fps=5)
anim_save("range_expansion.gif")
