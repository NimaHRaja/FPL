get_points_dcast <- function(teams_local, game_type = "all_active"){
    
    points_dcast <- data.frame()
    
    if(game_type != "all_active"){
        teams_local <- teams_local %>% filter(game_status == game_type)
    }else{
        teams_local <- teams_local %>% filter(game_status != "not_started")
        
    }
    
    if(dim(teams_local)[1] != 0){
        points_dcast <- 
            teams_local %>% mutate(points = multiplier * total_points) %>%
            dcast(playername ~ player_name, value.var = "points")
        
        points_dcast[is.na(points_dcast)] <- 0
    }
    
    points_dcast
}

get_points_delta <- function(teams_local, game_type = "all_active", my_player){
    
    points_delta <- data.frame()
    local_DF <- get_points_dcast(teams_local, game_type)
    
    if(dim(local_DF)[1] != 0){
        points_delta <- 
            inner_join(
                melt(local_DF, id.vars = "playername"),
                melt(local_DF, id.vars = "playername") %>% filter(variable == my_player),
                by = "playername") %>% mutate(delta = value.y - value.x) %>%
            filter(delta != 0)
        
        if(dim(points_delta)[1] != 0){
            points_delta <- points_delta %>% 
                dcast(variable.x ~ playername , value.var = "delta")
            
            points_delta[is.na(points_delta)] <- 0
        }
    }
    
    points_delta
}
