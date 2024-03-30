# ili processing, calculation of weekly proportions of season cumulative totals


## load data
load("./01-Data/01-Processed-Data/ili.rds")



##packages
library(dplyr)
library(tidyr)
library(lubridate)



## ili season designation
ili.seasonal.distributions <- ili %>% 
  filter(!is.na(week) & !region%in%c("Commonwealth of the Northern Mariana Islands", "Virgin Islands")) %>%
  mutate(region = droplevels(region), 
         year = year(week_start), #weird entries/errors for year values with week start at end of december (e.g., 12/30/12); maybe cuz epiweek one?
         season = ifelse(week<40, 
                         paste0(year-1, "-", year), 
                         paste0(year, "-", year+1)
                         ))


## create scaffold to mount data to identify implicit zeros
scaffold <- expand.grid(region = unique(ili.seasonal.distributions$region), 
                        # season = unique(ili.seasonal.distributions$season), 
                        week_start = unique(ili.seasonal.distributions$week_start)) %>%
  mutate(week = epiweek(week_start), 
         year = year(week_start)) %>%
  mutate(season = ifelse(week<40, 
                         paste0(year-1, "-", year), 
                         paste0(year, "-", year+1)))


### merge data to shell
ili.seasonal.distributions <- full_join(scaffold, 
                                        ili.seasonal.distributions, 
                                        by = c("region", "week_start", "week", "year", "season"))

### missingness evaluation
# missingness <- ili.seasonal.distributions %>%
#   group_by(region, season) %>%
#   summarise(n = n(),
#             n.miss = sum(is.na(ilitotal))) %>%
#   ungroup() %>%
#   mutate(p.miss = n.miss / n) %>%
#   select(-n, -n.miss) %>%
#   pivot_wider(names_from = season,
#               values_from = p.miss) %>%
#   arrange(region)
# 
# View(missingness)
# 
# # florida missing 2010-11 season completely
# # puerto rico missing 2010-11, 2011-12, and almost all 2012-13
# # dataset is truncated for 2020-21 season due to time of download likely
# # # trim data to span from 2011-12 through 2019-2020 seasons
# # # # matches with the commuting data coverage as well
# # # # will need to see how missing 2 seasons of data for PR will impact analyses


## seasonal totals and weekly proportions
ili.seasonal.distributions <- ili.seasonal.distributions %>%
  filter(!season%in%c("2010-2011", "2020-2021")) %>% 
  group_by(season, region) %>%
  mutate(ili.cumulative = sum(ilitotal),
         tp.cumulative = sum(total_patients),
         n = n(), 
         n.miss = sum(is.na(ilitotal))) %>%
  ungroup() %>% 
  mutate(p.cili = ilitotal / ili.cumulative, 
         p.cpatients = total_patients / tp.cumulative) 




## lag can calculate percent change

ili <- ili.seasonal.distributions %>%
  arrange(week_start) %>%
  group_by(region) %>%
  mutate(ili.lag1 = lag(ilitotal, 1), 
         p.cili.lag1 = lag(p.cili, 1)) %>%
  ungroup() %>%
  mutate(ili.roc = (ilitotal-ili.lag1)/ili.lag1) %>% 
  mutate(ili.roc = ifelse(ili.roc>1,1,ili.roc)) 




## save
save(ili, file = "./01-Data/02-Analytic-Data/ili.rds")


## clean environment
rm(list = ls())
gc()
