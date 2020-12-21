source("Functions/init.R")

Sys.time()
top10k_teams <- get_a_league_teams(league_id = 314, week_number = 13, first_page = 1, num_pages = 200)
Sys.time()








top10k_teams %>% group_by(player_name,entry_name) %>% summarise(count = n()) %>% 
    filter(count <= 15) %>% ungroup() %>%  
    group_by(player_name) %>% summarise(count = n()) %>% View()




top10k_teams %>% group_by(playername) %>% summarise(n()) %>% View()
top10k_teams %>% filter(position < 12) %>% group_by(playername) %>% summarise(n()) %>% View()
