


load("./01-Data/01-Processed-Data/satscan_clusters_ili_acs.rds")
load("./01-Data/01-Processed-Data/spatial.rdata")
load("./01-Data/02-Analytic-Data/ili2.rds")


library(dplyr)
library(tidyr)
library(sf)
library(igraph)


states <- as.character(unique(ili2$region))
cluster.df <- data.frame(state = states)
for(i in 1:length(states)){
  cluster.df[,states[i]] <- NA
  for(ii in 1:length(states)){
    cluster.df[which(cluster.df$state==states[ii]),states[i]] <- length(which(grepl(states[i], all.clusters.df$`Location IDs included`) & grepl(states[ii], all.clusters.df$`Location IDs included`)))
  }
}
# cluster.df[1:5,]
# ncol(cluster.df)



# # by season
# 
# ends <- seq(as.Date("2010-10-01"), as.Date("2021-10-01"), by = "years")[-1]-1
# starts <- seq(as.Date("2010-10-01"), as.Date("2021-10-01"), by = "years")[1:length(ends)]
# 
# 
# seasonal.cluster.dfs <- list()
# 
# 
# for(j in 1:length(starts)){
#   
#   seasonal.cluster.dfs[[j]] <- data.frame(state = states)
#   
#   acdf.season <- all.clusters.df %>% filter(week >= starts[j] & week <= ends[j])
#   
#   for(i in 1:length(states)){
#     seasonal.cluster.dfs[[j]][,states[i]] <- NA
#     for(ii in 1:length(states)){
#       seasonal.cluster.dfs[[j]][which(seasonal.cluster.dfs[[j]]$state==states[ii]),states[i]] <- length(which(grepl(states[i], acdf.season$`Location IDs included`) & grepl(states[ii], acdf.season$`Location IDs included`)))
#     }
#   }
#   
#   
#   
# }

















cluster.matrix <- as.matrix(cluster.df[,2:ncol(cluster.df)])
rownames(cluster.matrix) <- cluster.df$state


# hist(diag(cluster.matrix))
# quantile(diag(cluster.matrix))
# 
# hist(cluster.matrix[lower.tri(cluster.matrix)])
# quantile(cluster.matrix[lower.tri(cluster.matrix)])
# 
# 
# state.relation <- cbind(state = contig.us$NAME, states)
# # state.relation
# 
# row.names(cluster.matrix) <- state.relation[,1]
# 
# colnames(cluster.matrix) <- state.relation[,1]

cluster.matrix.nd <- cluster.matrix
diag(cluster.matrix.nd) <- 0





# set up network
## attach lat/lon coordinates to network vertices
### use centers of population
vlist <- cbind(pop.centers.state, st_coordinates(pop.centers.state)) %>% 
  as.data.frame() %>% 
  select(State = STNAME, x=X, y=Y, pop = POPULATION) %>%
  filter(State %in% states)
# %>%
#   filter(State%in%unlist(state.combos[,c("from", "to")]))
### alternatively, spatial polygon centroid
# library(geosphere)
# centroids <- st_as_sf(as.data.frame(centroid(as_Spatial(us.shape.state.contig))), coords = c(1,2)) %>%
#   cbind(., State = us.shape.state.contig$NAME, st_coordinates(.))
# vlist <- left_join(vlist, centroids, by = "State") %>% select(State, x=X, y=Y, pop)





clusters.network <- igraph::graph_from_adjacency_matrix(cluster.matrix, 
                                                        mode = "undirected", 
                                                        weighted = TRUE, 
                                                        diag = TRUE)


V(clusters.network)$x <- vlist$x[match(V(clusters.network)$name, vlist$State)]
V(clusters.network)$y <- vlist$y[match(V(clusters.network)$name, vlist$State)]
V(clusters.network)$pop <- vlist$pop[match(V(clusters.network)$name, vlist$State)]


ia.clusters.network <- clusters.network

save(ia.clusters.network, file = "./01-Data/02-Analytic-Data/satscan_clusters_ili_acs_network.rds")


rm(list = ls())
gc()


