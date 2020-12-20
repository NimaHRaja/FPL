get_live_league_comparisons <- function(league_id, week_number, live_matches = NULL, my_player){
    
    teams <- get_a_league_teams(league_id, week_number, refetch = TRUE)
    
    teams <- 
        teams %>% 
        group_by(fixture) %>% 
        mutate(max_minutes_per_fixture = max(minutes)) %>% 
        ungroup() %>% 
        mutate(game_status = if_else(max_minutes_per_fixture == 90, "completed",
                                     if_else(max_minutes_per_fixture > 0, "live",
                                             "not_started")))
    
    live_players <- teams %>% filter(position < 12 & game_status == "live")
    completed_players <- teams %>% filter(position < 12 & game_status == "completed")
    notstarted_players <- teams %>% filter(position < 12 & game_status == "not_started")
    
    ##############################
    
    get_points_dcast <- function(local_DF){
        
        points_dcast <- data.frame()
        
        if(length(local_DF) != 0){
            points_dcast <- 
                local_DF %>% mutate(points = multiplier * total_points) %>%
                dcast(playername ~ player_name, value.var = "points")
            
            points_dcast[is.na(points_dcast)] <- 0
        }
        
        points_dcast
    }
    
    ##############################
    
    live_points_dcast <- get_points_dcast(live_players)
    completed_points_dcast <- get_points_dcast(completed_players)
    
    ##############################
    
    get_points_delta <- function(local_DF){
        
        points_delta <- data.frame()
        
        if(length(local_DF) != 0){
            points_delta <- 
                inner_join(
                    melt(local_DF, id.vars = "playername"),
                    melt(local_DF, id.vars = "playername") %>% filter(variable == my_player),
                    by = "playername") %>% mutate(delta = value.y - value.x) %>%
                filter(delta != 0) %>% 
                dcast(variable.x ~ playername , value.var = "delta")
            
            points_delta[is.na(points_delta)] <- 0
        }
        
        points_delta
    }
    
    ############################### 
    
    live_points_delta <- get_points_delta(live_points_dcast)
    completed_points_delta <- get_points_delta(completed_points_dcast)
    
    ###############################
    
    notstarted_players_dcast <- data.frame()
    
    if(length(notstarted_players) != 0){
        notstarted_players_dcast <- 
            notstarted_players %>% mutate(live_points = multiplier) %>%
            dcast(playername ~ player_name, value.var = "live_points") 
        
        notstarted_players_dcast[is.na(notstarted_players_dcast)] <- 0
    }
    
    notstarted_players_delta <- data.frame()
    
    if(length(notstarted_players_dcast) != 0){
        
    notstarted_players_delta <- 
        inner_join(
            melt(notstarted_players_dcast, id.vars = "playername"),
            melt(notstarted_players_dcast, id.vars = "playername") %>% filter(variable == my_player),
            by = "playername") %>% mutate(delta = value.y - value.x) %>%
        filter(delta != 0) %>% 
        dcast(variable.x ~ playername , value.var = "delta")
    
    notstarted_players_delta[is.na(notstarted_players_delta)] <- 0
    }
    
    ###############################

    live_points <-
        teams %>% group_by(player_name) %>%
        filter(game_status == "live") %>%
        summarise(tot_points = sum(multiplier * total_points),
                  tot_players = sum(multiplier)) %>%
        arrange(-tot_points)
    
    points_so_far <-
        teams %>% group_by(player_name) %>%
        filter(game_status != "not_started") %>%
        summarise(tot_points = sum(multiplier * total_points),
                  tot_players = sum(multiplier)) %>%
        arrange(-tot_points)
    
    ################################
    
    list(teams = teams, 
         live_players = live_players, 
         completed_players = completed_players,
         notstarted_players = notstarted_players,
         live_points_dcast = live_points_dcast, 
         completed_points_dcast = completed_points_dcast,
         live_points_delta = live_points_delta, 
         completed_points_delta = completed_points_delta,
         notstarted_players_dcast = notstarted_players_dcast,
         notstarted_players_delta = notstarted_players_delta,
         live_points = live_points,
         points_so_far = points_so_far
    )
}