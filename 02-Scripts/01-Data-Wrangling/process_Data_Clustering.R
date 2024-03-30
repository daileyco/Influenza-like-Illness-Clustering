


library(dplyr)



clustering.results <- data.frame(file = list.files("./01-Data/01-Processed-Data", pattern = "^satscan_clusters_.+[.]rds$", full.names = T))
clustering.results[,2:3] <- sapply(gsub("^[.]/01-Data/01-Processed-Data/satscan_clusters_(.+)[.]rds$", "\\1", clustering.results[,1]), 
                                   strsplit, 
                                   split = "_")%>%
  as.data.frame()%>%
  t()%>%
  as.data.frame() %>% setNames(., nm = c("disease indicator", "proximity model"))



clustering.results <- lapply(1:nrow(clustering.results), 
                          function(index){
                            load(clustering.results$file[index])
                            
                            temp <- cbind(clustering.results[index,], all.clusters.df)
                            
                          }) %>% 
  bind_rows()




save(clustering.results, file = "./01-Data/02-Analytic-Data/clustering_results_aggregate.rds")


rm(list = ls())
gc()






