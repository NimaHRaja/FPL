# get_live_league_teams_points gets a league_id and a week_number,
# and returns the active teams of all the players of the given league.
# It also adds game_status (completed/live/not-started).
# To get the active teams, it finds the 12 players who played/could play.
# to add: minimum 3 defenders, benched captain, and chips.
# Calls: get_a_league_teams
# Called by: get_live_league_comparisons

get_live_league_teams_points <- function(league_id, week_number){
    
    teams <- get_a_league_teams(league_id, week_number, refetch = TRUE)
    
    teams <- 
        teams %>% 
        group_by(fixture) %>% 
        mutate(max_minutes_per_fixture = max(minutes)) %>% 
        ungroup() %>% 
        mutate(game_status = if_else(max_minutes_per_fixture == 90, "completed",
                                     if_else(max_minutes_per_fixture > 0, "live",
                                             "not_started")))
    
    # one goalkeeper and 10 filed players with the lowest position are picked.
    
    teams <- 
        rbind(
            teams %>% 
                filter(position %in% c(1,12)) %>%
                group_by(player_name) %>%
                filter(position == min(position)) %>%
                ungroup(),
            teams %>%
                filter(!position %in% c(1,12)) %>% 
                group_by(player_name) %>%
                mutate(rr = dense_rank(position)) %>% 
                filter(rr <= 10) %>%
                select(-rr) %>%
                ungroup()) %>% 
        mutate(multiplier = ifelse((multiplier == 0), 1, multiplier))
    
    teams
}