# Script to create summary table

## load data
load("./01-Data/02-Analytic-Data/satscan_clusters.rds")

## packages
library(dplyr)
library(tidyr)
library(lubridate)



## helper functions
source("./02-Scripts/02-Helper-Functions/tabulator.R")



## summarize data
### indicator of distance metric
clusters <- clusters %>%
  mutate(distance = ifelse(is.na(`Coordinates / radius`), "Commuting Network", "Spatial"), 
         ew = epiweek(week))


clusters.summary <- clusters %>% 
  mutate(across(c(matches("[M|m]ean|P")), ~as.numeric(.x))) %>%
  mutate(meandiff = `Mean inside` - `Mean outside`, 
         wtdmeandiff = `Weighted mean inside` - `Weighted mean outside`, 
         p05 = `P-value`<0.05)

clusters.summary <- create.Table.1(c("Cluster Size", 
                                     "Mean inside", "Mean outside", "meandiff",
                                     "Weighted mean inside", "Weighted mean outside", "wtdmeandiff",
                                     "ew"), "distance", 
                                   clusters.summary%>%
                                     filter(p05))

# %>%
#   group_by(distance) %>%
#   summarise(n = n(), 
#             n.sig = sum(p05), 
#             p.sig = n.sig / n *100,
#             across(c(`Cluster Size`,matches("[M|m]ean")), 
#                    .fns = list(mean = ~mean(.x[which(p05)]), 
#                                sd = ~sd(.x[which(p05)]),
#                                median = ~median(.x[which(p05)]),
#                                min = ~min(.x[which(p05)]),
#                                max = ~max(.x[which(p05)])))) %>%
#   ungroup() %>%
#   pivot_longer(!distance, names_to = "Variable", values_to = "Value")
# 
# 
# 
# clusters.summary <- clusters.summary %>% 
#   mutate(param = sub("^.+[_](.+)$", "\\1", Variable) %>% 
#            ifelse(.=="n.sig", "n", .) %>% 
#            ifelse(.=="p.sig", "pr", .) %>% 
#            factor(., levels = c("mean", "sd", "median", "min", "max", "n", "pr"))) %>% 
#   mutate(Variable = sub("[_].+", "", Variable) %>% 
#            ifelse(.%in%c("p.sig", "n.sig"), "sig", .)) %>% 
#   pivot_wider(names_from = param, values_from = Value)
# 
# 
# clusters.summary <- clusters.summary %>%
#   mutate(n = ifelse(is.na(n), NA, ifelse(is.na(pr), paste0("n = ",n), paste0(n," (", round(pr,1), ")"))), 
#          mean = ifelse(is.na(mean), NA, paste0(round(mean,2), " (", round(sd, 2), ")")),
#          median = ifelse(is.na(median), NA, paste0(round(median,2), " [", round(min,2), ",", round(max,2), "]"))) %>% 
#   select(-pr, -sd, -min, -max) %>%
#   pivot_longer(c(n, mean, median), names_to = "Parameter", values_to = "Value") %>% 
#   filter(!is.na(Value))
# 
# 
# clusters.summary <- clusters.summary %>%
#   mutate(Variable = ifelse(Variable%in%c("n"), "", ifelse(Variable%in%c("sig"), "P<0.05", Variable)), 
#          Parameter = case_when(Variable%in%c("n") ~ "", 
#                                Variable%in%c("P<0.05") ~ "n (%)", 
#                                Parameter%in%c("mean") ~ "Mean (SD)", 
#                                Parameter%in%c("median") ~ "Median [Min,Max]", 
#                                TRUE ~ NA), 
#          distance = ifelse(distance%in%c("commuting"), "Commuting Network", "Spatial")) %>%
#   pivot_wider(names_from = distance, values_from = Value)




table.summary.clusters <- clusters.summary



## save

save(table.summary.clusters, 
     file = "./03-Output/01-Tables/table_summary_clusters.rds")




## clean environment
rm(list = ls())
gc()









