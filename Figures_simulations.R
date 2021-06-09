library(plyr)
library(stringr)
library(ggplot2)
library(fields)
library(plotrix)
library(tidyr)

#setwd("C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019//IBM/2020-09-14 - Prospecting invasion occ emigr/ProspInvMod/ProspInvMod/Figures")

# nam<-list.files(pattern="_pop.txt")
# #nam<-nam[grep("_Em_3_Evolprosp_0_Evolemigr_0_pop",nam)]
# 
# range.shift<-NULL
# maxy.time<-NULL
# ALL<-NULL
# 
#  for (i in 1:length(nam)){
#   #print(c(i,nam[i]))
#   tab<-read.table(nam[i],header=T)
#   matches <- regmatches(nam[i], gregexpr("[[:digit:]]+\\.*[[:digit:]]*", nam[i]))
#   num<-as.numeric(unlist(matches))
# 
#   tab$CellRange<-num[1]
#   tab$ProspPatch<-num[2]
#   tab$Rate<-num[3]
#  
#   print(c(tab$CellRange[1],tab$ProspPatch[1],tab$Rate[1]))
#   
#   tabou<-subset(tab,tab$sim==5)
#   ALL<-rbind(tabou,ALL)
#   
# 
# ##Range shifting rate
# tabo<-subset(tab, tab$gen==max(tab$gen) & tab$Nadult>0)
# tabou<-ddply(tabo,.(sim,CellRange,ProspPatch,Rate),summarize,RangeShift=(max(y)-2)/100,
#                Nad=sum(Nadult),NDisp=sum(NDisp),Nim=sum(Nimmigr))
# range.mean<-ddply(tabou,.(CellRange,ProspPatch,Rate),summarize,
#                   RangeShift.mean=mean(RangeShift), Nad.mean=mean(Nad),
#                   NDisp.mean=mean(NDisp),Nimmigr.mean=mean(Nim),
#              RangeShift.se=std.error(RangeShift),Nad.se=std.error(Nad),
#              NDisp.se=std.error(NDisp),Nimmigr.se=std.error(Nim))
# 
# range.shift<-rbind(range.shift,range.mean)
# 
# 
# 
# ##Dynamics of range expansion over time
# taba<-ddply(tab,.(sim,gen,y,CellRange,ProspPatch,Rate),summarize,yAd=sum(Nadult),yDisp=sum(NDisp),yImmigr=sum(Nimmigr))
# taba<-ddply(taba,.(gen,y,CellRange,ProspPatch,Rate),summarize,yAdm=mean(yAd),yAdse=std.error(yAd), yDispm=mean(yDisp),
#             yDispse=std.error(yDisp),yImmigrm=mean(yImmigr),yImmigrse=std.error(yImmigr))
# #taba<-subset(taba,taba$gen==max(taba$gen))
# 
# maxy.time<-rbind(maxy.time,taba)
# 
#  }
# 
# 
# save(range.shift,file="RangeShift.RData")
#  save(maxy.time,file="maxy_time.RData")
#  save(ALL,file="ALL.RData")

load("RangeShift_soc.RData")
range.shift.soc<-range.shift
range.shift.soc$Scen<-"Pers + public"
load("maxy_time_soc.RData")
maxy.time.soc<-maxy.time
maxy.time.soc$Scen<-"Pers + public"


range.shift$CellRange<-as.factor(range.shift$CellRange)
range.shift$ProspPatch<-as.factor(range.shift$ProspPatch)
range.shift$Rate<-as.factor(range.shift$Rate)
range.shift.rate<-subset(range.shift,range.shift$ProspPatch!="0")
maxy.time$CellRange<-as.factor(maxy.time$CellRange)
maxy.time$ProspPatch<-as.factor(maxy.time$ProspPatch)
maxy.time$Rate<-as.factor(maxy.time$Rate)
maxy.time.rate<-subset(maxy.time,maxy.time$ProspPatch!="0")
maxy.time$gen<-maxy.time$gen-200

##Range shifting rate

random.range<-subset(range.shift,range.shift$ProspPatch=="0")
maxy.time.rand<-subset(maxy.time,maxy.time$ProspPatch=="0")

xx<-subset(range.shift,range.shift$Rate %in% seq(0,1,0.2))

##Range shift with rate of 1
#setwd("C:/Users/s03ap7/Desktop/Marie-Curie fellowship 2017-2019/IBM/2018-08-30 - Invasion rate and prospecting 2/InvasionRateProspecting/Figures")
#tiff("Fig 2 - Range_shift_rate1.tif",res=400,compression="lzw",
#     width=4000,height=2000)
g<-ggplot(range.shift,aes(x=Rate,y=RangeShift.mean,group=ProspPatch,fill=ProspPatch)) +
  geom_point(aes(colour=ProspPatch)) +
  geom_line(aes(colour=ProspPatch)) +
  geom_ribbon(aes(ymin=RangeShift.mean-RangeShift.se,
                 ymax=RangeShift.mean+RangeShift.se,group=ProspPatch), 
             alpha=0.3,       #transparency
             linetype=0,
             size=0.5) +
  ylab("Range shift (cell/year)") +
  xlab("Proportion of occupied patches chosen") +
  facet_grid(.~CellRange)
  #  scale_color_manual(values=rainbow(3)) +
print(g)
#dev.off()


##Nb of adults with rate
g<-ggplot(range.shift,aes(x=Rate,y=Nad.mean,group=ProspPatch,fill=ProspPatch)) +
  geom_line(aes(colour=ProspPatch)) +
  geom_point(aes(colour=ProspPatch)) +
  geom_ribbon(aes(ymin=Nad.mean-Nad.se,
                  ymax=Nad.mean+Nad.se,group=ProspPatch), 
              alpha=0.3,       #transparency
              linetype=0,
              size=0.5) +
  ylab("Nb adults") +
  xlab("Proba of choosing occupied patches") +
#  geom_hline(aes(yintercept=Nad.mean),size=1.2,random.range) +
#  scale_color_manual(values=rainbow(3)) +
  facet_grid(.~CellRange)
print(g)




xx<-subset(maxy.time,maxy.time$gen==max(maxy.time$gen))
xx<-subset(xx,xx$Rate==0 | xx$Rate==0.1| xx$Rate==0.3| xx$Rate==0.5|
             xx$Rate==0.7 | xx$Rate==0.9 | xx$Rate==1)
  
g4<-ggplot(xx,aes(y,yAdm,group=ProspPatch,colour=ProspPatch,fill=ProspPatch))+
  
  geom_line() +
  geom_ribbon(aes(ymin=yAdm-yAdse, ymax=yAdm+yAdse), 
              alpha=0.5,       #transparency
              linetype=0,
              size=0.5)   +   #solid, dashed or other line types
  #            colour=ProspPatch, #border line color
#              fill=ProspPatch) +
  facet_grid(Rate~CellRange)
print(g4)


log_mod_trans = function() trans_new("log_mod", 
                                     function(x) sign(x) * log10(abs(x) + 1), 
                                     function(x) sign(x) * (10**(abs(x)) - 1))


library(viridis)

zzz<-subset(maxy.time,maxy.time$Rate==0 | maxy.time$Rate==0.1|maxy.time$Rate==0.3| maxy.time$Rate==0.5|
              maxy.time$Rate==0.7 | maxy.time$Rate==0.9 | maxy.time$Rate==1)

g5<-ggplot(subset(zzz,zzz$yAdm>0),aes(x=gen,y=y))+ 
  geom_tile(aes(fill=yAdm))+
  facet_grid(Rate~CellRange+ProspPatch) + 
  scale_fill_gradientn(limits=c(0,600), 
                       colours=viridis(10),
                       aesthetics = "fill") +
  scale_y_discrete(expand = c(0, 0)) +
  labs(x="Years",y="y", fill = "Nb of adults") +
  guides(fill = guide_colorbar(barwidth = 1, barheight = 15)) +
  theme_bw() 
print(g5)


xx<-subset(maxy.time,maxy.time$gen==max(maxy.time$gen))
xx<-subset(xx,xx$Rate==0 | xx$Rate==0.2| xx$Rate==0.3|xx$Rate==0.5|
             xx$Rate==0.7 | xx$Rate==0.9 | xx$Rate==1)

rr<-subset(maxy.time,maxy.time$y==20 )
g6<-ggplot(rr,aes(gen,yAdm,group=ProspPatch,colour=ProspPatch,fill=ProspPatch))+
  
  geom_line() +
  geom_ribbon(aes(ymin=yAdm-yAdse, ymax=yAdm+yAdse), 
              alpha=0.5,       #transparency
              linetype=0,
              size=0.5)   +   #solid, dashed or other line types
  #            colour=ProspPatch, #border line color
  #              fill=ProspPatch) +
  facet_grid(Rate~CellRange)
print(g6)


jj<-ddply(maxy.time,.(gen,CellRange,ProspPatch,Rate),summarise,Ymax=max(y))

g6<-ggplot(jj,aes(gen,Ymax,group=ProspPatch,colour=ProspPatch))+
  geom_line() +
  facet_grid(Rate~CellRange)
print(g6)
