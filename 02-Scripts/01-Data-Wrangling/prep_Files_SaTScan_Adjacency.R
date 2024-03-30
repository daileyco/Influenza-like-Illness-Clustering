# script to write the adjacency files used by satscan


## load data
load("./01-Data/01-Processed-Data/acs.rdata")
load("./01-Data/01-Processed-Data/spatial.rdata")


## packages
library(dplyr)
library(tidyr)
library(sf)



# #coordinates for spatial relation
# pop.centers.state.coords <- cbind(pop.centers.state, st_coordinates(pop.centers.state)) %>% 
#   as.data.frame() %>% 
#   select(State = STNAME, x=X, y=Y, pop = POPULATION) 
# ### alternatively, spatial polygon centroid
# # library(geosphere)
# # centroids <- st_as_sf(as.data.frame(centroid(as_Spatial(us.shape.state.contig))), coords = c(1,2)) %>%
# #   cbind(., State = us.shape.state.contig$NAME, st_coordinates(.))




# # Coodinates File
write.table(pop.centers.state2010 %>% st_drop_geometry(),
            file = "./01-Data/02-Analytic-Data/SaTScan/coordinates2010.txt",
            quote = F,
            row.names = F,
            sep = ";")

write.table(pop.centers.state2020 %>% st_drop_geometry(),
            file = "./01-Data/02-Analytic-Data/SaTScan/coordinates2020.txt",
            quote = F,
            row.names = F,
            sep = ";")




# # Commuting File


write.table(acs1115,
            file = "./01-Data/02-Analytic-Data/SaTScan/acs1115.txt",
            quote = F,
            row.names = F,
            sep = ";")

write.table(acs1620,
            file = "./01-Data/02-Analytic-Data/SaTScan/acs1620.txt",
            quote = F,
            row.names = F,
            sep = ";")






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


