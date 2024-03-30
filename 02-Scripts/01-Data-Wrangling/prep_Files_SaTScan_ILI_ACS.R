
load("./01-Data/01-Processed-Data/spatial.rdata")
load("./01-Data/02-Analytic-Data/acs_state_network.rdata")
load("./01-Data/02-Analytic-Data/ili2.rds")


library(dplyr)
library(tidyr)
library(sf)
library(igraph)


# #coordinates for spatial relation
# pop.centers.state.coords <- cbind(pop.centers.state, st_coordinates(pop.centers.state)) %>% 
#   as.data.frame() %>% 
#   select(State = STNAME, x=X, y=Y, pop = POPULATION) 
# ### alternatively, spatial polygon centroid
# # library(geosphere)
# # centroids <- st_as_sf(as.data.frame(centroid(as_Spatial(us.shape.state.contig))), coords = c(1,2)) %>%
# #   cbind(., State = us.shape.state.contig$NAME, st_coordinates(.))

if(!dir.exists("./01-Data/02-Analytic-Data/SaTScan/input3")){
  dir.create("./01-Data/02-Analytic-Data/SaTScan/input3")
  dir.create("./01-Data/02-Analytic-Data/SaTScan/output3")
}



# # # Coodinates File
# write.table(pop.centers.state.coords,
#             file = "./01-Data/02-Analytic-Data/SaTScan/input3/coordinates.txt",
#             quote = F,
#             row.names = F,
#             sep = ";")



# # Network File

state_network <- as.undirected(acs.state.network, mode = "collapse")%>%
  simplify()%>%
  as_data_frame(what = "edges")%>%
  mutate(distance = 1 / weight)

write.table(state_network,
            file = "./01-Data/02-Analytic-Data/SaTScan/input3/network.txt",
            quote = F,
            row.names = F,
            sep = ";")




# # # Aggregate Case/Proportion File
# write.table(ili2[, c("region", "week_start", "sqrt.ei.unit1", "p.cpatients")],
#             file = "./01-Data/02-Analytic-Data/SaTScan/input3/eiunit_ili_2011-2020.txt",
#             quote = F,
#             row.names = F,
#             sep = ";")


# # Seasons Case/Proportion Files
# 
# i = 1

for(i in 1:length(unique(ili2$season))){
  write.table(ili2[which(ili2$season==unique(ili2$season)[i]), c("region", "season", "week_start", "sqrt.ei.unit1", "p.cpatients", "ilitotal", "total_patients")], 
              file = paste0("./01-Data/02-Analytic-Data/SaTScan/input3/eiunit_ili_", unique(ili2$season)[i], ".txt"), 
              quote = F, 
              row.names = F, 
              sep = ";")
}


# # Weekly Case/Proportion Files
# 
# i = 1

for(i in 1:length(unique(ili2$week_start))){
  write.table(ili2[which(ili2$week_start==unique(ili2$week_start)[i]), c("region", "week_start", "sqrt.ei.unit1", "p.cpatients", "ilitotal", "total_patients")], 
              file = paste0("./01-Data/02-Analytic-Data/SaTScan/input3/eiunit_ili_", unique(ili2$week_start)[i], ".txt"), 
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


