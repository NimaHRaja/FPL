# get_a_league_teams recieves league_id and week_number
# and returns the teams of entries of 
# the given league_id for the given week_number + metadata.
# it also searches for a local version of the data file before 
# fetching the data from FPL. This can be turned off if refetch is set to TRUE.
# Calls: get_league_entries_updated
# Calls: get_league_updated

get_a_league_teams <- 
    function(league_id, week_number, first_page = 1, num_pages = 1, refetch = FALSE){
        
        output_file <- 
            paste("data/entries_teams_", league_id, "_week", week_number, "_", 
                  first_page, "-", num_pages, ".csv", sep = "")
        
        if(file.exists(output_file) & !refetch){
            
            output <- read.csv(output_file)
            
        }else{
            
            league_entries <- 
                get_league_entries_updated(league_id, 
                                           week_number = week_number,
                                           first_page = first_page, 
                                           num_pages = num_pages) %>% 
                rename(team_id = id)
            league_name <- get_league_updated(league_id)$league$name
            
            output <- 
                get_entry_player_picks(league_entries$entry, week_number) %>%
                inner_join(league_entries, by = "entry") %>%
                mutate(league_id = league_id,
                       week_number = week_number,
                       league_name = league_name)
            
            output <- 
                inner_join(output,
                           get_players_details(unique(output$id),week_number), 
                           by = "playername")
            
            
            write.csv(output,output_file, row.names = FALSE)
        }
        
        output
    }
