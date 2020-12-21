source("Functions/init.R")

league_A <- 
    get_live_league_comparisons(league_id = 1138028, 
                                week_number = 14, 
                                my_player = "Nima H-R")
league_B <- 
    get_live_league_comparisons(league_id = 58361, 
                                week_number = 14, 
                                my_player = "Nima H-R")


View(league_A$live_points_dcast)
View(league_A$live_points_delta)
View(league_A$notstarted_players_delta)
league_A$live_points
league_A$points_so_far


View(league_B$live_points_dcast)
View(league_B$live_points_delta)
View(league_B$notstarted_players_delta)
league_B$live_points
league_B$points_so_far
