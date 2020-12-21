source("Functions/init.R")
entries_teams <- get_a_league_teams(1138028,9)


entries_teams <- entries_teams %>% filter(multiplier != 0)
# entries_teams <- entries_teams %>% filter(entry_name %in% c("Kamjam", "Coldspur", "Saman"))


sim_matrix <- 
    inner_join(
        entries_teams %>% rbind(entries_teams %>% filter(is_captain) %>% mutate(is_captain = FALSE)) %>% select(id,entry_name,is_captain),
        entries_teams %>% rbind(entries_teams %>% filter(is_captain) %>% mutate(is_captain = FALSE)) %>% select(id,entry_name,is_captain),
        by = c("id", "is_captain")) %>% 
    group_by(entry_name.x,entry_name.y) %>%
    summarise(similarity = n()) %>% 
    ungroup() %>% 
    mutate(similarity = similarity/12)

dissim_matrix <- 
    sim_matrix %>%
    dcast(entry_name.x ~ entry_name.y, value.var = "similarity") 

row.names(dissim_matrix) <- dissim_matrix$entry_name.x
dissim_matrix <- dissim_matrix %>% select(-entry_name.x)
dissim_matrix[is.na(dissim_matrix)] <- 0
dissim_matrix <- 1- dissim_matrix

plot(hclust(as.dist(dissim_matrix)))



####
A <- prcomp(center = FALSE, dissim_matrix)

res <- 
A$x %>% melt() %>% rename(entry_name = Var1) %>% inner_join(entries_teams, by = "entry_name") %>% 
    group_by(Var2, playername) %>%
    summarise(vv = sum(value*multiplier)) %>% 
    dcast(playername ~ Var2, value.var = "vv") 

sum(res$PC2)









#################

library(dplyr)
library(reshape2)
options(stringsAsFactors = FALSE)

AA <- read.csv("data/top10K_picks_week9.csv")
AA %>% arrange(entry) %>% head(30) %>% dcast(playername ~ entry) %>% View()


BB <- AA %>% arrange(entry) %>% head(450) %>% select(playername,entry)

inner_join(BB, BB, by = "playername") %>% group_by(entry.x, entry.y) %>% summarise(count = n()) %>% 
    dcast(entry.x ~ entry.y, value.var = "count") %>% View()

