get_players_details <- function(list_of_players, week_number)
{
    do.call("rbind",  
            lapply(list_of_players, get_player_details)) %>% filter(round == week_number)
}