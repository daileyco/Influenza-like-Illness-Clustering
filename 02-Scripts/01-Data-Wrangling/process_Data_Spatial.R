# Spatial Data Processing

library(sf)
library(dplyr)





if(!dir.exists("./01-Data/00-Raw-Data/Spatial")){
  dir.create("./01-Data/00-Raw-Data/Spatial")
}





# ## shapefiles from census
# # https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
# 
us.shape.state <- st_read("./01-Data/00-Raw-Data/Spatial/cb_2018_us_state_5m.shp")
# # us.shape.county <- st_read("./01-Data/00-Raw-Data/Spatial/cb_2018_us_county_20m.shp")
# 



# population centers coordinates
# download.file("https://www2.census.gov/geo/docs/reference/cenpop2010/CenPop2010_Mean_ST.txt", destfile = "./01-Data/00-Raw-Data/Spatial/CenPop2010_Mean_ST.txt")
# download.file("https://www2.census.gov/geo/docs/reference/cenpop2020/CenPop2020_Mean_ST.txt", destfile = "./01-Data/00-Raw-Data/Spatial/CenPop2020_Mean_ST.txt")

pop.centers.state2010 <- read.csv("./01-Data/00-Raw-Data/Spatial/CenPop2010_Mean_ST.txt")
pop.centers.state2020 <- read.csv("./01-Data/00-Raw-Data/Spatial/CenPop2020_Mean_ST.txt")


coords2010 <- pop.centers.state2010 %>% select(LONGITUDE, LATITUDE)
coords2020 <- pop.centers.state2020 %>% select(LONGITUDE, LATITUDE)

pop.centers.state2010 <- st_as_sf(pop.centers.state2010, coords = c("LONGITUDE", "LATITUDE")) %>%
  bind_cols(., 
            coords2010)
pop.centers.state2020 <- st_as_sf(pop.centers.state2020, coords = c("LONGITUDE", "LATITUDE")) %>%
  bind_cols(., 
            coords2020)

# # ### by county available here https://www2.census.gov/geo/docs/reference/cenpop2010/county/CenPop2010_Mean_CO.txt
# # download.file("https://www2.census.gov/geo/docs/reference/cenpop2010/county/CenPop2010_Mean_CO.txt", destfile = "./01-Data/00-Raw-Data/Spatial/CenPop2010_Mean_CO.txt")
# # download.file("https://www2.census.gov/geo/docs/reference/cenpop2020/county/CenPop2020_Mean_CO.txt", destfile = "./01-Data/00-Raw-Data/Spatial/CenPop2020_Mean_CO.txt")
# # pop.centers.county <- read.csv("./01-Data/00-Raw-Data/Spatial/CenPop2010_Mean_CO.txt")
# pop.centers.county <- read.csv("./01-Data/00-Raw-Data/Spatial/CenPop2020_Mean_CO.txt", colClasses = c(rep("character", 4), rep("numeric", 3)))
# pop.centers.county <- st_as_sf(pop.centers.county, coords = c("LONGITUDE", "LATITUDE"))




save(us.shape.state, 
     pop.centers.state2010, 
     pop.centers.state2020,  
     
     file = "./01-Data/01-Processed-Data/spatial.rdata")




rm(list = ls())
gc()