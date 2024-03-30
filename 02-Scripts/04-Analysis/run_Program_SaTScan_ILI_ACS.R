# satscan run

load("./01-Data/02-Analytic-Data/ili2.rds")


library(readr)
# # set up parameters file manually first run, now edit within loop
param <- read_file("./01-Data/02-Analytic-Data/SaTScan/input3/parameters_original.prm")
# save separate from original in case errors
# restore original settings
write_file(param, file = "./01-Data/02-Analytic-Data/SaTScan/input3/parameters.prm")




pb <- txtProgressBar(min = 0, max = length(unique(ili2$week_start)), style = 3)

start = Sys.time()
for(i in 1:length(unique(ili2$week_start))){

  # read previous param file
  param <- read_file("./01-Data/02-Analytic-Data/SaTScan/input3/parameters.prm")


  if(i != 1){

    # substitute date for next iteration
    ## this changes input and output files
    param <- gsub(unique(ili2$week_start)[i-1], unique(ili2$week_start)[i], param)
    ## this changes the time interval which is set to a single day, throws error if data don't fall within interval
    param <- gsub(format(unique(ili2$week_start)[i-1], "%Y/%m/%d"), format(unique(ili2$week_start)[i], "%Y/%m/%d"), param)

  }

  # rewrite the param file to be called by satscan
  readr::write_file(param, file = "./01-Data/02-Analytic-Data/SaTScan/input3/parameters.prm")

  Sys.sleep(2)
  # run satscan program via CMD
  # # shell doesnt work but system does
  # # shell('"C:/Program Files/SaTScan/SaTScanBatch.exe" "C:/Users/daile/OneDrive - University of Georgia/US-H3N2-Diffusion/data-regionalization/satscan/input3/parameters.prm"', shell = NULL)
  system('"C:/Program Files/SaTScan/SaTScanBatch64.exe" "G:/Research/ILI-Clustering/01-Data/02-Analytic-Data/SaTScan/input3/parameters.prm"')

  setTxtProgressBar(pb, i)
  Sys.sleep(3)

}

end = Sys.time()


end-start
# ~50 minutes
# Time difference of 43.50614 mins
# Time difference of 42.85251 mins
# Time difference of 43.95327 mins