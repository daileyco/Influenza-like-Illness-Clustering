# script to create a map figure showing overlayed clusters aggregated by season quarter



## load data

load("./01-Data/01-Processed-Data/spatial.rdata")
load("./01-Data/02-Analytic-Data/ili.rds")
load("./01-Data/02-Analytic-Data/satscan_clusters.rds")


## packages
library(dplyr)
library(tidyr)
library(sf)
library(igraph)
library(viridis)
library(lubridate)


## clean
### spatial
us.shape.state.contig <- us.shape.state %>%
  filter(!NAME%in%c("Alaska", "American Samoa", "Commonwealth of the Northern Mariana Islands", "Guam", "Hawaii", "Puerto Rico", "United States Virgin Islands"))



### clusters
#### calculate epi week and distance indicator
clusters <- clusters %>% 
  mutate(epiweek = epiweek(week), 
         distance = ifelse(is.na(`Coordinates / radius`), "commuting", "spatial")
         # , 
         # season = ifelse(epiweek<40, 
         #                 paste0(year(week)-1, "-", year(week)), 
         #                 paste0(year(week), "-", year(week)+1))
         ) %>%
  filter(`P-value`<0.05)



# #### clean
# clusters <- clusters %>%
#   # filter(`P-value`<0.05) %>% 
#   group_by(epiweek, season, distance) %>%
#   summarise(n=n(), 
#             nsig=sum(`P-value`<0.05))%>%
#   ungroup()%>%
#   mutate(epiweek = factor(epiweek, levels = c(40:53,1:39), ordered = TRUE)) %>%
#   arrange(distance, season, epiweek)






## set up
seasons <- ili %>% 
  select(season, week_start, epiweek = week) %>% 
  filter(!duplicated(.)) %>% 
  mutate(month = month(week_start), 
         # time.period = case_when(month %in% 1:3 ~ 1, 
         #                         month %in% 4:6 ~ 2, 
         #                         month %in% 7:9 ~ 3, 
         #                         month %in% 10:12 ~ 4), 
         time.period = case_when(epiweek %in% 40:53 ~ 1, 
                                 epiweek %in% 1:13 ~ 2, 
                                 epiweek %in% 14:26 ~ 3, 
                                 epiweek %in% 27:39 ~ 4))







plot_Clusters_Grid <- function(clustering.results){

  these.clusters <- clustering.results %>%
    left_join(., seasons, by = c("week"="week_start")) %>%
    split(., f = .$season)
  # these.clusters <- clustering.results %>% 
  #   filter(`disease indicator`==dz.indicator & `proximity model`==proximity.model) %>%
  #   split(., .$type) %>%
  #   lapply(., function(x){left_join(x, seasons, by = c("week"="week_start")) %>% split(., .$season)}) 
  # 
  # 
  
  par(mfrow = c(9, 4), mar = c(0,0,2,0))
  
  lapply(these.clusters, function(this.seasons.clusters){

    lapply(1:4,
           function(this.time.period){

             this.time.periods.clusters <- this.seasons.clusters %>% filter(time.period==this.time.period)

             plot(us.shape.state.contig$geometry)
             title(main = paste0(unique(this.time.periods.clusters$season), " Season, Quarter ", this.time.period))

             for(i in 1:nrow(this.time.periods.clusters)){
               temp.map <- us.shape.state.contig %>% filter(NAME %in% unlist(strsplit(this.time.periods.clusters$`Location IDs included`[i], split = ", ")))

               plot(temp.map$geometry, col = adjustcolor("red", alpha.f = 0.25), add = T)
               
             }
           })

  })


}








this.filename <- paste0("./03-Output/02-Figures/figure_map_clustering_", "spatial", "_byseasonquarter.png")

png(filename = this.filename, units = "in", res = 300, height = 18, width = 16, pointsize = 10)

# svg(filename = this.filename, width = 12, height = 18, pointsize = 14)
plot_Clusters_Grid(clusters %>% filter(distance%in%c("spatial")))
dev.off()






this.filename <- paste0("./03-Output/02-Figures/figure_map_clustering_", "commutingnetwork", "_byseasonquarter.png")

png(filename = this.filename, units = "in", res = 300, height = 18, width = 16, pointsize = 10)

# svg(filename = this.filename, width = 12, height = 18, pointsize = 14)
plot_Clusters_Grid(clusters %>% filter(distance%in%c("commuting")))
dev.off()





## clean environment
rm(list=ls())
gc()

