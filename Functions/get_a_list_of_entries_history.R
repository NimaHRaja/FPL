# receives a list_of_entries
# and returns their history + their current position

get_a_list_of_entries_history <- function(list_of_entries, current_season = '2020/21'){
    
    print(Sys.time())
    
    user_history <- 
        do.call("rbind",lapply(list_of_entries$entry, 
                               function(x) {get_entry_hist(x) %>% mutate(entry = x)}))
    
    print(Sys.time())
    
    
    user_current <- 
        list_of_entries %>% mutate(season_name = current_season,
                                   total_points = total,
                                   name = player_name,
                                   entry = entry) %>%
        select(season_name, total_points, rank, name, entry)
    
    rbind(user_history, user_current) %>% filter(rank != "")
    
}