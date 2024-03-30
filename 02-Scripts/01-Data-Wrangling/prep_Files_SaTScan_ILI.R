# script to write the ili data to text files for satscan


## load data
load("./01-Data/02-Analytic-Data/ili.rds")



## packages



## remove missings
ili <- ili[which(!is.na(ili$ili.roc)),]



## set up directory to house files

if(!dir.exists("./01-Data/02-Analytic-Data/SaTScan")){
  dir.create("./01-Data/02-Analytic-Data/SaTScan")
  dir.create("./01-Data/02-Analytic-Data/SaTScan/input")
  dir.create("./01-Data/02-Analytic-Data/SaTScan/output")
  dir.create("./01-Data/02-Analytic-Data/SaTScan/output/Spatial")
  dir.create("./01-Data/02-Analytic-Data/SaTScan/output/ACS")
  
}



## write weekly files

for(i in 1:length(unique(ili$week_start))){
  write.table(ili[which(ili$week_start==unique(ili$week_start)[i]), c("region", "week_start", "ili.roc", "total_patients")], 
              file = paste0("./01-Data/02-Analytic-Data/SaTScan/input/ili_roc_", unique(ili$week_start)[i], ".txt"), 
              quote = F, 
              row.names = F, 
              sep = ";")
}






## clean environment
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


# # # Aggregate Case/Proportion File
# write.table(ili2[, c("region", "week_start", "sqrt.p.cili", "p.cpatients")],
#             file = "./01-Data/02-Analytic-Data/SaTScan/input/sqrtprop_ili_2011-2020.txt",
#             quote = F,
#             row.names = F,
#             sep = ";")
# 
# 
# # # Seasons Case/Proportion Files
# # 
# # i = 1
# 
# for(i in 1:length(unique(ili2$season))){
#   write.table(ili2[which(ili2$season==unique(ili2$season)[i]), c("region", "season", "week_start", "sqrt.p.cili", "p.cpatients", "ilitotal", "total_patients")], 
#               file = paste0("./01-Data/02-Analytic-Data/SaTScan/input/sqrtprop_ili_", unique(ili2$season)[i], ".txt"), 
#               quote = F, 
#               row.names = F, 
#               sep = ";")
# }
