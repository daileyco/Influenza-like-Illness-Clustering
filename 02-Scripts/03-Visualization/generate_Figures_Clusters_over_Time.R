# Script to create figure showing the number of clusters detected over time 

## Load data
load("./01-Data/02-Analytic-Data/satscan_clusters.rds")

## Packages
library(dplyr)
library(lubridate)
library(RColorBrewer)

## Helper Functions


## calculate epi week and distance indicator
clusters <- clusters %>% 
  mutate(epiweek = epiweek(week), 
         distance = ifelse(is.na(`Coordinates / radius`), "commuting", "spatial"), 
         season = ifelse(epiweek<40, 
                         paste0(year(week)-1, "-", year(week)), 
                         paste0(year(week), "-", year(week)+1)))



## clean
clusters <- clusters %>%
  # filter(`P-value`<0.05) %>% 
  group_by(epiweek, season, distance) %>%
  summarise(n=n(), 
            nsig=sum(`P-value`<0.05))%>%
  ungroup()%>%
  mutate(epiweek = factor(epiweek, levels = c(40:53,1:39), ordered = TRUE)) %>%
  arrange(distance, season, epiweek)





## plot for each season separately

for(i in 1:length(unique(clusters$season))){
  
  this.season <- unique(clusters$season)[i]
  
  this.seasons.clusters <- clusters %>%
    filter(season%in%this.season)
  
  png(filename = paste0("./03-Output/02-Figures/figure_numberclusters_by_epiweek", 
                        this.season, 
                        ".png"), 
      width = 8, 
      height = 9, 
      units = "in", 
      res = 300, 
      pointsize = 10)
  
  par(mfrow = c(2,1), mar = c(3.1,3.1,3.1,1.1))
  
  
  
  ### spatial clusters
  
  barplot(this.seasons.clusters$n[which(this.seasons.clusters$distance=="spatial")]~this.seasons.clusters$epiweek[which(this.seasons.clusters$distance=="spatial")], 
          width = 1, 
          space = c(0),
          col = viridis::viridis(n=9)[i], 
          # border = NA,
          ylim = c(0,4),
          xpd = FALSE, 
          axes = FALSE,
          ylab = "",
          xlab = "",
          axisnames = FALSE)%>%print()
  axis(1, 
       at = 1:length(levels(clusters$epiweek))-0.5, 
       labels = FALSE, 
       las = 1, 
       cex.axis = 0.8, 
       tcl = -0.2, 
       line = 0)
  axis(1, 
       at = 1:length(levels(clusters$epiweek))-0.5, 
       labels = as.character(levels(clusters$epiweek)), 
       las = 1, 
       cex.axis = 0.8, 
       tick = FALSE, 
       line = -0.75)
  title(xlab = "Epiweek", line = 1.5, cex.lab = 0.8)
  
  
  
  
  axis(2, at = 0:4, las = 2, cex.axis = 0.8)
  title(ylab = "Number of Detected Clusters", line = 1.5, cex.lab = 0.8)
  
  
  title(main = paste0("Spatial\n", this.season), cex.main = 0.8, line = 1, font.main = 1)
  
  barplot(this.seasons.clusters$nsig[which(this.seasons.clusters$distance=="spatial")]~this.seasons.clusters$epiweek[which(this.seasons.clusters$distance=="spatial")], 
          width = 1, 
          space = c(0),
          # col = viridis::viridis(n=18)[i*2], 
          add=TRUE,
          col = "white",
          density = 50,
          ylim = c(0,4),
          xpd = FALSE, 
          axes = FALSE,
          ylab = "",
          xlab = "",
          axisnames = FALSE)%>%print()
  
  legend("topleft", 
         legend = c("P < 0.05"), 
         col = "black",
         fill = "black",
         density = 50,
         # pch = 22,
         pt.cex = 2, 
         cex = 0.8)
  
  
  
  
  
  
  
  ### commuting network clusters
  
  barplot(this.seasons.clusters$n[which(this.seasons.clusters$distance=="commuting")]~this.seasons.clusters$epiweek[which(this.seasons.clusters$distance=="commuting")], 
          width = 1, 
          space = c(0),
          col = viridis::viridis(n=9)[i], 
          # border = NA,
          ylim = c(0,4),
          xpd = FALSE, 
          axes = FALSE,
          ylab = "",
          xlab = "",
          axisnames = FALSE)%>%print()
  axis(1, 
       at = 1:length(levels(clusters$epiweek))-0.5, 
       labels = FALSE, 
       las = 1, 
       cex.axis = 0.8, 
       tcl = -0.2, 
       line = 0)
  axis(1, 
       at = 1:length(levels(clusters$epiweek))-0.5, 
       labels = as.character(levels(clusters$epiweek)), 
       las = 1, 
       cex.axis = 0.8, 
       tick = FALSE, 
       line = -0.75)
  title(xlab = "Epiweek", line = 1.5, cex.lab = 0.8)
  
  
  
  
  axis(2, at = 0:4, las = 2, cex.axis = 0.8)
  title(ylab = "Number of Detected Clusters", line = 1.5, cex.lab = 0.8)
  
  
  title(main = paste0("Commuting Network\n", this.season), cex.main = 0.8, line = 1, font.main = 1)
  
  barplot(this.seasons.clusters$nsig[which(this.seasons.clusters$distance=="commuting")]~this.seasons.clusters$epiweek[which(this.seasons.clusters$distance=="commuting")], 
          width = 1, 
          space = c(0),
          # col = viridis::viridis(n=18)[i*2], 
          add=TRUE,
          col = "white",
          density = 50,
          ylim = c(0,4),
          xpd = FALSE, 
          axes = FALSE,
          ylab = "",
          xlab = "",
          axisnames = FALSE)%>%print()
  
  legend("topleft", 
         legend = c("P < 0.05"), 
         col = "black",
         fill = "black",
         density = 50,
         # pch = 22,
         pt.cex = 2, 
         cex = 0.8)
  
  
  dev.off()
  
  
}








## plot all seasons together


png(filename = "./03-Output/02-Figures/figure_numberclusters_by_epiweek_allseasons.png", 
    width = 8, 
    height = 9, 
    units = "in", 
    res = 300, 
    pointsize = 10)

par(mfrow = c(2,1), mar = c(3.1,3.1,3.1,1.1))


### spatial clusters
barplot(clusters$n[which(clusters$distance=="spatial")]~clusters$season[which(clusters$distance=="spatial")]+clusters$epiweek[which(clusters$distance=="spatial")], 
        width = 1, 
        space = c(0),
        col = viridis::viridis(n=9),
        # col = "black",
        # border = NA,
        ylim = c(0,20),
        xpd = FALSE, 
        axes = FALSE,
        ylab = "",
        xlab = "",
        axisnames = FALSE)%>%print()
axis(1, 
     at = 1:length(levels(clusters$epiweek))-0.5, 
     labels = FALSE, 
     las = 1, 
     cex.axis = 0.8, 
     tcl = -0.2, 
     line = 0)
axis(1, 
     at = 1:length(levels(clusters$epiweek))-0.5, 
     labels = as.character(levels(clusters$epiweek)), 
     las = 1, 
     cex.axis = 0.8, 
     tick = FALSE, 
     line = -0.75)
title(xlab = "Epiweek", line = 1.5, cex.lab = 0.8)




axis(2, at = 0:max(clusters%>%group_by(epiweek,distance)%>%summarise(n=sum(n))%>%ungroup()%>%select(n)%>%unlist()), las = 2, cex.axis = 0.8)
title(ylab = "Number of Detected Clusters", line = 1.5, cex.lab = 0.8)


title(main = paste0("Spatial\nAll Seasons"), cex.main = 0.8, line = 1, font.main = 1)

barplot(clusters$nsig[which(clusters$distance=="spatial")]~clusters$season[which(clusters$distance=="spatial")]+clusters$epiweek[which(clusters$distance=="spatial")], 
        width = 1, 
        space = c(0),
        # col = viridis::viridis(n=18)[i*2], 
        add=TRUE,
        col = "white",
        density = 25,
        ylim = c(0,20),
        xpd = FALSE, 
        axes = FALSE,
        ylab = "",
        xlab = "",
        axisnames = FALSE)%>%print()

legend("topleft", 
       legend = c("P < 0.05"), 
       col = "black",
       fill = "black",
       density = 50,
       # pch = 22,
       pt.cex = 2, 
       cex = 0.8)






### commuting network clusters
barplot(clusters$n[which(clusters$distance=="commuting")]~clusters$season[which(clusters$distance=="commuting")]+clusters$epiweek[which(clusters$distance=="commuting")], 
        width = 1, 
        space = c(0),
        col = viridis::viridis(n=9),
        # col = "black",
        # border = NA,
        ylim = c(0,20),
        xpd = FALSE, 
        axes = FALSE,
        ylab = "",
        xlab = "",
        axisnames = FALSE)%>%print()
axis(1, 
     at = 1:length(levels(clusters$epiweek))-0.5, 
     labels = FALSE, 
     las = 1, 
     cex.axis = 0.8, 
     tcl = -0.2, 
     line = 0)
axis(1, 
     at = 1:length(levels(clusters$epiweek))-0.5, 
     labels = as.character(levels(clusters$epiweek)), 
     las = 1, 
     cex.axis = 0.8, 
     tick = FALSE, 
     line = -0.75)
title(xlab = "Epiweek", line = 1.5, cex.lab = 0.8)




axis(2, at = 0:max(clusters%>%group_by(epiweek,distance)%>%summarise(n=sum(n))%>%ungroup()%>%select(n)%>%unlist()), las = 2, cex.axis = 0.8)
title(ylab = "Number of Detected Clusters", line = 1.5, cex.lab = 0.8)


title(main = paste0("Commuting Network\nAll Seasons"), cex.main = 0.8, line = 1, font.main = 1)

barplot(clusters$nsig[which(clusters$distance=="commuting")]~clusters$season[which(clusters$distance=="commuting")]+clusters$epiweek[which(clusters$distance=="commuting")], 
        width = 1, 
        space = c(0),
        # col = viridis::viridis(n=18)[i*2], 
        add=TRUE,
        col = "white",
        density = 25,
        ylim = c(0,20),
        xpd = FALSE, 
        axes = FALSE,
        ylab = "",
        xlab = "",
        axisnames = FALSE)%>%print()

legend("topleft", 
       legend = c("P < 0.05"), 
       col = "black",
       fill = "black",
       density = 50,
       # pch = 22,
       pt.cex = 2, 
       cex = 0.8)



dev.off()



## Save


## Clean Environment
rm(list = ls())
gc()




