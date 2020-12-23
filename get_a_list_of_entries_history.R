get_a_list_of_entries_history <- function(list_of_entries){
    
    print(Sys.time())
    
    user_history <- 
        do.call("rbind",lapply(list_of_entries$entry, 
                               function(x) {get_entry_hist(x) %>% mutate(entry = x)}))
    
    print(Sys.time())
    
    
    user_current <- 
        list_of_entries %>% mutate(season_name = '2020/21',
                                   total_points = total,
                                   name = player_name,
                                   entry = entry) %>%
        select(season_name, total_points, rank, name, entry)
    
    rbind(user_history, user_current) %>% filter(rank != "")
    
}