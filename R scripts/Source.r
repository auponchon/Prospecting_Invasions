library(ggplot2)
library(plotrix)
library(viridis)
library(gridExtra)
library(dplyr)
library(plyr)
library(stringr)
library(ggplot2)
library(fields)
library(plotrix)
library(tidyr)
library(tidyverse)
library(MetBrewer)



g_legend<-function(a.gplot){
    tmp <- ggplot_gtable(ggplot_build(a.gplot))
    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
    legend <- tmp$grobs[[leg]]
    return(legend)}
