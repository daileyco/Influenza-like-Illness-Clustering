




library(TTAT)



library(dplyr)
library(purrr)
library(ape)
library(tibble)
library(tidyr)


load("./01-Data/02-Analytic-Data/analysis_grid.rdata")

load("./01-Data/01-Processed-Data/ai_df.rds")

load("./01-Data/01-Processed-Data/tree_data.rdata")

load("./01-Data/02-Analytic-Data/network_summaries.rds")



error.index <- sapply(1:nrow(analysis.grid),
                      function(this.set){
                        class(pluck(analysis.grid$thecommunities[this.set],1))
                      })%in%c("try-error")



analysis.grid.list <- split(analysis.grid, error.index)
analysis.grid.list$`FALSE` <- analysis.grid.list$`FALSE` %>% mutate(data.index = row_number())

analysis.grid.list$`FALSE` <- full_join(analysis.grid.list$`FALSE`, 
                                        ai.df, 
                                        by = c("data.index"="analysis.grid.nonna.index"))

analysis.grid <- bind_rows(analysis.grid.list)








tip.coverage <- tree.tip.df%>%
  mutate(week = lubridate::epiweek(Date), 
         year = lubridate::year(Date), 
         season = ifelse(week<40, 
                         paste0(year-1, "-", year), 
                         paste0(year, "-", year+1)))%>%
  group_by(season, Location)%>%
  summarise(n=n())%>%
  ungroup()%>%
  tidyr::pivot_wider(names_from = season, 
                     values_from = n) %>%
  arrange(Location) %>%
  full_join(membership.df%>%mutate(Location=gsub(" ", "", State))%>%select(Location))















save(network.summaries, #networks transformation framework with summary statistics
     analysis.grid, #community detection framework with communities objects+k_communities+modularity+ttassociationindex
     membership.df, #locations with communities membership
     tip.coverage, #locations with tip frequencies by season for tree data
      
     file = "./01-Data/02-Analytic-Data/analysis_aggregate.rdata"
     )



rm(list=ls())
gc()
