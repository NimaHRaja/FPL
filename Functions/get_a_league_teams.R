# get_a_league_teams recieves league_id and week_number
# and returns the teams of entries of 
# the given league_id for the given week_number + metadata.

get_a_league_teams <- function(league_id, week_number){
    
    league_entries <- get_league_entries_updated(league_id)
    
    do.call("rbind", lapply(league_entries$entry,
                            function(x){get_entry_picks(x, week_number)$picks %>% 
                                    mutate(entry = x)})) %>%
        inner_join(league_entries, by = "entry") %>%
        mutate(league_id = league_id, 
               week_number = week_number,
               league_name = get_league_updated(1138028)$league$name)
}