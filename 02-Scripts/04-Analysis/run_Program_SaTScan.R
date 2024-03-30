# satscan run


## load data
load("./01-Data/02-Analytic-Data/ili.rds")



## packages
library(readr)



## remove missings
ili <- ili[which(!is.na(ili$ili.roc)),]



## set up parameters file manually first run, now edit within loop
param.spatial <- read_file("./01-Data/02-Analytic-Data/SaTScan/parameters_original_spatial.prm")
param.acs <- read_file("./01-Data/02-Analytic-Data/SaTScan/parameters_original_acs.prm")
# save separate from original in case errors
# restore original settings
write_file(param.spatial, file = "./01-Data/02-Analytic-Data/SaTScan/parameters_spatial.prm")
write_file(param.acs, file = "./01-Data/02-Analytic-Data/SaTScan/parameters_acs.prm")



## loop through each week in data

### progress bar
pb <- txtProgressBar(min = 0, max = length(unique(ili$week_start)), style = 3)
### time log
start = Sys.time()


### loop
for(i in 1:length(unique(ili$week_start))){

  # read previous param file
  param.spatial <- read_file("./01-Data/02-Analytic-Data/SaTScan/parameters_spatial.prm")
  param.acs <- read_file("./01-Data/02-Analytic-Data/SaTScan/parameters_acs.prm")


  if(i != 1){

    # substitute date for next iteration
    ## this changes input and output files
    param.spatial <- gsub(unique(ili$week_start)[i-1], unique(ili$week_start)[i], param.spatial)
    param.acs <- gsub(unique(ili$week_start)[i-1], unique(ili$week_start)[i], param.acs)
    ## this changes the time interval which is set to a single day, throws error if data don't fall within interval
    param.spatial <- gsub(format(unique(ili$week_start)[i-1], "%Y/%m/%d"), format(unique(ili$week_start)[i], "%Y/%m/%d"), param.spatial)
    param.acs <- gsub(format(unique(ili$week_start)[i-1], "%Y/%m/%d"), format(unique(ili$week_start)[i], "%Y/%m/%d"), param.acs)
    
    
    if(unique(ili$week_start)[i]>=as.Date("2016-01-01")){
      
      param.spatial <- gsub("coordinates2010.txt", "coordinates2020.txt", param.spatial)
      param.acs <- gsub("acs1115.txt", "acs1620.txt", param.acs)
      
      
    }
    
    
  }

  # rewrite the param file to be called by satscan
  readr::write_file(param.spatial, file = "./01-Data/02-Analytic-Data/SaTScan/parameters_spatial.prm")
  readr::write_file(param.acs, file = "./01-Data/02-Analytic-Data/SaTScan/parameters_acs.prm")
  
  Sys.sleep(1)
  # run satscan program via CMD
  # # shell doesnt work but system does
  # # shell('"C:/Program Files/SaTScan/SaTScanBatch.exe" "C:/Users/daile/OneDrive - University of Georgia/US-H3N2-Diffusion/data-regionalization/satscan/input2/parameters.prm"', shell = NULL)
  system('"C:/Program Files/SaTScan/SaTScanBatch64.exe" "G:/Research/Influenza-like-Illness-Clustering/01-Data/02-Analytic-Data/SaTScan/parameters_spatial.prm"')
  Sys.sleep(1)
  system('"C:/Program Files/SaTScan/SaTScanBatch64.exe" "G:/Research/Influenza-like-Illness-Clustering/01-Data/02-Analytic-Data/SaTScan/parameters_acs.prm"')
  
  setTxtProgressBar(pb, i)
  Sys.sleep(1)

}

### time log
end = Sys.time()

end-start






## clean environment
rm(list=ls())
gc()