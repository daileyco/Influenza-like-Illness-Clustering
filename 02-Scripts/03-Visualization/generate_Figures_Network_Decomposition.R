
library(dplyr)
library(igraph)
library(tidyr)

source("./02-Scripts/02-Helper-Functions/add_edge_Characteristics.R")

source("./02-Scripts/02-Helper-Functions/plot_Network.R")



network.files <- list.files("./01-Data/02-Analytic-Data", pattern = "network", full.names = TRUE)


# 
# for(i in 1:length(network.files)){
#   
#   rm(list=ls(pattern="[.]network"))
#   load(network.files[i])
#   
#   the_network <- get(ls(pattern="[.]network"))
#   
#   the_network <- as.undirected(the_network, mode = "collapse")
#   
#   the_network <- add_edge_Characteristics(the_network)
#   
#   
#   
#   e.weight.flow.scaled <- log(E(the_network)$weight)
#   e.weight.min <- min(e.weight.flow.scaled)
#   e.weight.range <- diff(range(e.weight.flow.scaled))
#   
#   e.weight.flow.scaled <- (e.weight.flow.scaled-e.weight.min)/e.weight.range
#   
#   e.weight.quantiles <- quantile(e.weight.flow.scaled, probs = seq(0, 1, by = 0.05))
#   
#   
#   
#   # par("mar", "oma") <- list(mar = c(5.1, 4.1, 4.1, 2.1), oma = c(0, 0, 0, 0))
#   par(mar = c(0,0,0,0), oma = c(0,0,0,0))
#   
#   png(filename = paste0("./03-Output/02-Figures/", sub(".*/(.+[_]network[0-9]*)[.]rd.+$", "\\1", network.files[i]), "%03d.png"), 
#       height = 9, width = 16, units = "in", res = 300, pointsize = 12)
#   for(ii in 1:10){
#     
#     
#     the_network_subset <- the_network %>% 
#       delete_vertices(., 
#                       v = which(V(.)$name%in%c("Alaska", "Hawaii", "Puerto Rico")))%>%
#       delete_edges(., 
#                    edges = which(!E(.)$decile_weight%in%c(ii)))
#     
#     
#     
#     plot_Network(the_network_subset, 
#                  e.weight.min = e.weight.min, 
#                  e.weight.range = e.weight.range, 
#                  e.weight.quantiles = e.weight.quantiles, 
#                  the_option = 1, 
#                  the_edge_factor_name = "decile_weight_no_loops", 
#                  the_edge_factor = c(5:10))
#     
#   }
#   dev.off()
#   
#   
# }







for(i in 1:length(network.files)){
  
  rm(list=ls(pattern="[.]network"))
  load(network.files[i])
  
  the_network <- get(ls(pattern="[.]network"))
  
  the_network <- as.undirected(the_network, mode = "collapse")
  
  the_network <- add_edge_Characteristics(the_network)
  
  
  
  the_network <- the_network %>% 
    delete_vertices(., 
                    v = which(V(.)$name%in%c("Alaska", "Hawaii", "Puerto Rico")))
  
  
  
  e.weight.flow.scaled <- log(E(the_network)$weight)
  e.weight.min <- min(e.weight.flow.scaled)
  e.weight.range <- diff(range(e.weight.flow.scaled))
  
  e.weight.flow.scaled <- (e.weight.flow.scaled-e.weight.min)/e.weight.range
  
  e.weight.quantiles <- quantile(e.weight.flow.scaled, probs = seq(0, 1, by = 0.05))
  
  
  
  # par("mar", "oma") <- list(mar = c(5.1, 4.1, 4.1, 2.1), oma = c(0, 0, 0, 0))
  par(mar = c(0,0,0,0), oma = c(0,0,0,0))
  
  png(filename = paste0("./03-Output/02-Figures/", sub(".*/(.+[_]network[0-9]*)[.]rd.+$", "\\1", network.files[i]), "_composite_%03d.png"), 
      height = 9, width = 16, units = "in", res = 300, pointsize = 12)
  plot_Network(the_network, 
                 e.weight.min = e.weight.min, 
                 e.weight.range = e.weight.range, 
                 e.weight.quantiles = e.weight.quantiles, 
                 the_option = 2, 
                 the_edge_factor_name = "decile_weight_no_loops", 
                 the_edge_factor = c(5:10))
    
  dev.off()
  
  
}



























# for(i in 1:length(network.files)){
#   
#   
#   
#   rm(list=ls(pattern="[.]network"))
#   load(network.files[i])
#   
#   the_network <- get(ls(pattern="[.]network"))
#   
#   the_network <- as.undirected(the_network, mode = "collapse")
#   
#   the_network <- add_edge_Characteristics(the_network)
#   
#   
#   
#   the_network <- the_network %>% 
#     delete_edges(., which(!E(.)$strength2%in%c(10)|is.loop(.)))
#   
#   
#   e.weight.flow.scaled <- log(E(the_network)$weight)
#   e.weight.min <- min(e.weight.flow.scaled)
#   e.weight.range <- diff(range(e.weight.flow.scaled))
#   
#   e.weight.flow.scaled <- (e.weight.flow.scaled-e.weight.min)/e.weight.range
#   
#   e.weight.quantiles <- quantile(e.weight.flow.scaled, probs = seq(0, 1, by = 0.05))
#   
#   
#   
#   # par("mar", "oma") <- list(mar = c(5.1, 4.1, 4.1, 2.1), oma = c(0, 0, 0, 0))
#   par(mar = c(0,0,0,0), oma = c(0,0,0,0))
#   
#   png(filename = paste0("./03-Output/02-Figures/top10_", sub(".*/(.+[_]network[0-9]*)[.]rd.+$", "\\1", network.files[i]), "%03d.png"), 
#       height = 9, width = 16, units = "in", res = 300, pointsize = 12)
#   for(ii in 1:4){
#     
#     if(ii==4){
#       ii <- c(NA, 4:11)
#     }
#     
#     the_network_subset <- the_network %>% 
#       delete_vertices(., 
#                       v = which(V(.)$name%in%c("Alaska", "Hawaii", "Puerto Rico")))%>%
#       delete_edges(., 
#                    edges = which(!E(.)$degree_separation%in%c(ii)))
#     
#     
#     plot_Network(the_network_subset, 
#                  e.weight.min = e.weight.min, 
#                  e.weight.range = e.weight.range, 
#                  e.weight.quantiles = e.weight.quantiles, 
#                  the_option = 1, 
#                  the_edge_factor_name = "decile_weight_no_loops", 
#                  the_edge_factor = c(5:10))
#     
#   }
#   dev.off()
#   
#   
# }


rm(list = ls())
gc()
