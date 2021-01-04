# recieves a list of players and a week and
# fetches the players' info for the given week

get_players_details <- function(list_of_players, week_number)
{
    
    temp_output <- get_player_details(list_of_players) %>% filter(round == 10)
    
    inner_join(
        temp_output,
        get_player_info(temp_output$playername),
        by = "playername")
}