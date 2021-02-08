options(stringsAsFactors = FALSE)

library(fplscrapR)
library(dplyr)
library(ggplot2)
library(reshape2)

source("Functions/get_league_entries_updated.R")
source("Functions/get_league_updated.R")
source("Functions/get_a_league_teams.R")
source("Functions/get_players_details.R")
source("Functions/get_live_league_teams_points.R")
source("Functions/get_live_league_comparisons.R")
source("get_a_list_of_entries_history.R")


#### find a way to remove lapplys