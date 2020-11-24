

entries_teams <- get_a_league_teams(1138028,9)


entries_teams <- entries_teams %>% filter(multiplier != 0)

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

dissim_matrix <- 
    sim_matrix %>%
    select(-entry) %>%
    dcast(entry_name.x ~ entry_name.y, value.var = "similarity") 

row.names(dissim_matrix) <- dissim_matrix$entry_name.x
dissim_matrix <- dissim_matrix %>% select(-entry_name.x)
dissim_matrix[is.na(dissim_matrix)] <- 0
dissim_matrix <- 1- dissim_matrix
