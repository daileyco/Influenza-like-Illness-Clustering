# processing satscan results


## load data
load("./01-Data/02-Analytic-Data/ili.rds")



## packages
library(dplyr)
library(purrr)





## remove missings
ili <- ili[which(!is.na(ili$ili.roc)),]



## list files
satscan.files <- list.files("./01-Data/02-Analytic-Data/SaTScan/output", full=T, pattern = "ili_roc", recursive = TRUE)

satscan.output <- list()
for(i in 1:length(satscan.files)){satscan.output[[i]] <- readLines(satscan.files[i])}

clusters.detected <- list()
for(i in 1:length(satscan.output)){
  
  if(sum(satscan.output[[i]]=="No clusters were found.")>0){
    clusters.detected[[i]] <- NULL
  }else{
    clusters.detected[[i]] <- satscan.output[[i]][which(satscan.output[[i]]%in%c("CLUSTERS DETECTED")):which(satscan.output[[i]]%in%c("PARAMETER SETTINGS"))-1]
  }
  
  }



individual.clusters <- list()
for(i in 1:length(clusters.detected)){
  if(is.null(clusters.detected[[i]])){
    individual.clusters[[i]] <- NULL
  }else{
    loc.indices <- which(grepl("Location IDs included", clusters.detected[[i]]))
    pval.indices <- which(grepl("P-value", clusters.detected[[i]]))
    each.cluster <- list()
    for(ii in 1:length(loc.indices)){
      each.cluster[[ii]] <- clusters.detected[[i]][loc.indices[ii]:pval.indices[ii]]
      # while(substr(each.cluster[[ii]][1], nchar(each.cluster[[ii]][1]), nchar(each.cluster[[ii]][1]))==","){
      #   each.cluster[[ii]] <- c(paste(each.cluster[[ii]][1], gsub("^[[:space:]]{2,}", "", each.cluster[[ii]][2])), each.cluster[[ii]][3:length(each.cluster[[ii]])])
      # }
      while(!grepl("Overlap|Coordinates|Number", each.cluster[[ii]][2])){
        # each.cluster[[ii]] <- c(paste(each.cluster[[ii]][1], gsub("^[[:space:]]{2,}", "", each.cluster[[ii]][min(grep("Overlap|Coordinates|Number", each.cluster[[ii]]))-1])), 
        #                       each.cluster[[ii]][min(grep("Overlap|Coordinates|Number", each.cluster[[ii]])):length(each.cluster[[ii]])])
        # each.cluster[[ii]] <- c(paste(each.cluster[[ii]][1], gsub("^[[:space:]]{2,}", "", each.cluster[[ii]][min(grep("Overlap|Coordinates", each.cluster[[ii]]))-1])), 
        #                       each.cluster[[ii]][min(grep("Overlap|Coordinates", each.cluster[[ii]])):length(each.cluster[[ii]])])
        
        each.cluster[[ii]] <- c(paste(each.cluster[[ii]][1], gsub("^[[:space:]]{2,}", "", each.cluster[[ii]][2])), 
                                each.cluster[[ii]][3:length(each.cluster[[ii]])])
      }
    }
    individual.clusters[[i]] <- each.cluster
  }
  
  
}


weeks <- unique(ili$week_start)

individual.clusters.dfs <- list()
for(i in 1:length(individual.clusters)){
  
  if(is.null(individual.clusters[[i]])){
    individual.clusters.dfs[[i]] <- NULL
  }else{
    weekly.clusters.dfs <- list()
  
    for(ii in 1:length(individual.clusters[[i]])){
      temp <- unlist(lapply(strsplit(individual.clusters[[i]][[ii]], split="[.]{0,}:[[:space:]]"), function(x){purrr::pluck(x, 2)})) %>% t() %>% data.frame("Cluster Number"=gsub("([0-9]+).*$", "\\1", individual.clusters[[i]][[ii]][1]), .)
      temp2 <- c("Cluster Number", unlist(lapply(strsplit(individual.clusters[[i]][[ii]], split="[.]{0,}:[[:space:]]"), function(x){x%>%purrr::pluck(1)%>%gsub("(^[0-9]+[.])|(^\\s{2,})", "", .)})))
      temp3 <- setNames(temp, temp2)
      
      weekly.clusters.dfs[[ii]] <- temp3
    }
    
    individual.clusters.dfs[[i]] <- bind_rows(weekly.clusters.dfs) %>% mutate(week = rep(weeks,2)[i])
  }
  
}


all.clusters.df <- bind_rows(individual.clusters.dfs) %>% mutate("Cluster Size" = NA) %>% select(week, "Cluster Number", "Cluster Size", everything())
all.clusters.df$`Cluster Size` <- sapply(all.clusters.df$`Location IDs included`, function(x){length(unlist(strsplit(x, split=", ")))})


# all.clusters.df <- all.clusters.df %>% filter(`P-value` < 0.05/length(weeks))


clusters <- all.clusters.df


## save
save(clusters, file = "./01-Data/02-Analytic-Data/satscan_clusters.rds")




## clean environment
rm(list = ls())
gc()


