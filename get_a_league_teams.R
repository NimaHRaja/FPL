source("Functions/init.R")

league_id <- 1138028
week_number <- 8

league_entries <- get_league_entries(league_id)


entries_teams <- 
    do.call("rbind", lapply(league_entries$entry,
                            function(x){get_entry_picks(x, week_number)$picks %>% 
                                    mutate(entry = x)})) 

# entries_teams <- entries_teams %>% filter(multiplier != 0)

sim_matrix <- 
    inner_join(
        entries_teams %>% select(element,entry),
        entries_teams %>% select(element,entry),
        by = "element") %>% 
    group_by(entry.x,entry.y) %>%
    summarise(similarity = n()) %>% 
    ungroup() %>% 
    rename(entry = entry.x) %>%
    inner_join(league_entries %>% select(entry_name,entry), by = "entry") %>% 
    select(-entry) %>% 
    rename(entry = entry.y) %>%
    inner_join(league_entries %>% select(entry_name,entry), by = "entry") %>%
    mutate(similarity = similarity/15)
