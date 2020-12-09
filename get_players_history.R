all_rankings1 <- read.csv("all_rankings1.csv")

users_sample <- all_rankings1[1:1000,]


Sys.time()

user_history <- 
    do.call("rbind",lapply(users_sample$entry, get_entry_hist))

Sys.time()


user_current <- 
    users_sample %>% mutate(season_name = '2020/21',
                            total_points = total,
                            name = player_name) %>%
    select(season_name, total_points, rank, name)

user_history_current <- rbind(user_history, user_current)

library(reshape2)

user_history_current %>% mutate(total_points = as.integer(total_points)) %>%
    dcast(formula = name  ~ season_name,value.var = "total_points", sum) %>% 
    ggplot(aes(x = `2019/20`, y = `2020/21`)) + geom_point()


player_history %>% filter(season_name > '2017') %>% 
    mutate(rank = as.integer(rank)) %>% filter(rank < 20000) %>% group_by(name) %>%
    summarise(n()) %>% View()
