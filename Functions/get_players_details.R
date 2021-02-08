# recieves a list of players and a week and
# fetches the players' info for the given week
# Called by: get_a_league_teams

get_players_details <- function(list_of_players, week_number)
{
    
    temp_output <- get_player_details(list_of_players) %>% filter(round == week_number)
    
    inner_join(
        temp_output,
        get_player_info(temp_output$playername) %>% select(playername, element_type),
        by = "playername")
}