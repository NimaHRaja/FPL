get_live_league_comparisons <- function(league_id, week_number, live_matches = NULL, my_player){
    
    teams <- get_a_league_teams(league_id, week_number, refetch = TRUE)
    
    live_teams <- teams
    
    if(!is.null(live_matches)){
        live_teams <- live_teams %>% filter(fixture %in% live_matches & position < 12) 
    }
    
    ##############################
    
    live_points_dcast <- 
        live_teams %>% mutate(live_points = multiplier * total_points) %>%
        dcast(playername ~ player_name, value.var = "live_points")
    
    live_points_dcast[is.na(live_points_dcast)] <- 0
    
    ##############################
    
    live_points_delta <- 
        inner_join(
            melt(live_points_dcast, id.vars = "playername"),
            melt(live_points_dcast, id.vars = "playername") %>% filter(variable == my_player),
            by = "playername") %>% mutate(delta = value.y - value.x) %>%
        filter(delta != 0) %>% 
        dcast(variable.x ~ playername , value.var = "delta")
    
    live_points_delta[is.na(live_points_delta)] <- 0
    
    ###############################
    
    live_players_dcast <- 
        live_teams %>% mutate(live_points = multiplier) %>%
        dcast(playername ~ player_name, value.var = "live_points") 
    
    live_players_dcast[is.na(live_players_dcast)] <- 0
    
    ###############################
    
    live_players_delta <- 
        inner_join(
            melt(live_players_dcast, id.vars = "playername"),
            melt(live_players_dcast, id.vars = "playername") %>% filter(variable == my_player),
            by = "playername") %>% mutate(delta = value.y - value.x) %>%
        filter(delta != 0) %>% 
        dcast(variable.x ~ playername , value.var = "delta")
    
    live_points <- 
        live_teams %>% group_by(player_name) %>% 
        summarise(tot_points = sum(multiplier * total_points),
                  tot_players = sum(multiplier)) %>%
        arrange(-tot_points)
    
    ################################
    
    list(teams = teams, 
         live_teams = live_teams, 
         live_points_dcast = live_points_dcast, 
         live_points_delta = live_points_delta, 
         live_players_dcast = live_players_dcast, 
         live_players_delta = live_players_delta,
         live_points = live_points 
    )
    
}