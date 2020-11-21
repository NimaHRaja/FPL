source("Functions/init.R")

top_users <- read.csv("all_rankings1.csv")

Sys.time()
top10K_picks <- 
    do.call("rbind",lapply(top_users$entry[1:10000], function(x){
        get_entry_player_picks(entryid = x, gw = 9)}))

Sys.time()

# AA %>% group_by(playername) %>% summarise(n()) %>% View()
