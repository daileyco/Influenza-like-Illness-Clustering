
load("./01-Data/01-Processed-Data/spatial.rdata")
load("./01-Data/02-Analytic-Data/ili2.rds")


library(dplyr)
library(tidyr)
library(sf)


#coordinates for spatial relation
pop.centers.state.coords <- cbind(pop.centers.state, st_coordinates(pop.centers.state)) %>% 
  as.data.frame() %>% 
  select(State = STNAME, x=X, y=Y, pop = POPULATION) 
### alternatively, spatial polygon centroid
# library(geosphere)
# centroids <- st_as_sf(as.data.frame(centroid(as_Spatial(us.shape.state.contig))), coords = c(1,2)) %>%
#   cbind(., State = us.shape.state.contig$NAME, st_coordinates(.))

if(!dir.exists("./01-Data/02-Analytic-Data/SaTScan")){
  dir.create("./01-Data/02-Analytic-Data/SaTScan")
  dir.create("./01-Data/02-Analytic-Data/SaTScan/input")
  dir.create("./01-Data/02-Analytic-Data/SaTScan/output")
}



# # Coodinates File
write.table(pop.centers.state.coords,
            file = "./01-Data/02-Analytic-Data/SaTScan/input/coordinates.txt",
            quote = F,
            row.names = F,
            sep = ";")




# # Aggregate Case/Proportion File
write.table(ili2[, c("region", "week_start", "sqrt.p.cili", "p.cpatients")],
            file = "./01-Data/02-Analytic-Data/SaTScan/input/sqrtprop_ili_2011-2020.txt",
            quote = F,
            row.names = F,
            sep = ";")


# # Seasons Case/Proportion Files
# 
# i = 1

for(i in 1:length(unique(ili2$season))){
  write.table(ili2[which(ili2$season==unique(ili2$season)[i]), c("region", "season", "week_start", "sqrt.p.cili", "p.cpatients", "ilitotal", "total_patients")], 
              file = paste0("./01-Data/02-Analytic-Data/SaTScan/input/sqrtprop_ili_", unique(ili2$season)[i], ".txt"), 
              quote = F, 
              row.names = F, 
              sep = ";")
}


# # Weekly Case/Proportion Files
# 
# i = 1

for(i in 1:length(unique(ili2$week_start))){
  write.table(ili2[which(ili2$week_start==unique(ili2$week_start)[i]), c("region", "week_start", "sqrt.p.cili", "p.cpatients", "ilitotal", "total_patients")], 
              file = paste0("./01-Data/02-Analytic-Data/SaTScan/input/sqrtprop_ili_", unique(ili2$week_start)[i], ".txt"), 
              quote = F, 
              row.names = F, 
              sep = ";")
}


rm(list = ls())
gc()


# library(readr)
# # set up parameters file manually first run, now edit within loop
# param <- read_file("./01-Data/02-Analytic-Data/SaTScan/input/parameters.prm")
# #save original in case errors
# # write_file(param, file = "./01-Data/02-Analytic-Data/SaTScan/input/parameters_original.prm")
# 
# # # restore original settings
# # param <- read_file("./data-regionalization/satscan/input/parameters_original.prm")
# # #save
# # write_file(param, file = "./data-regionalization/satscan/input/parameters.prm")


