# Comparing helli66 users' histories

source("Functions/init.R")

helli66_week8 <- get_league_entries(58361) 
helli66_week8 <- rbind(helli66_week8 %>% select(entry, player_name, total),
                       data.frame(entry = 4975808, player_name = "Nima Hamedani-Raja",total = 0))


helli66_history <- 
    do.call("rbind",lapply(helli66_week8$entry, get_entry_hist)) %>%
    mutate(total_points = as.integer(total_points)) %>%
    mutate(rank = as.integer(rank)) %>% 
    mutate(season = substr(season_name,0,4) %>% as.integer())


helli66_current <- 
    helli66_week8 %>% mutate(season_name = '2020/21',
                            total_points = total,
                            name = player_name,
                            season = 2020,
                            rank = 1) %>%
    select(season_name, total_points, rank, name, season)

helli66_history_current <- rbind(helli66_history, helli66_current)


# helli66_history %>%
    # ggplot(aes(x = season, y = rank, colour = name)) + geom_point() + geom_line()


# jpeg("helli66_history.jpg", width = 1200, height = 600)
helli66_history %>%
    filter(season >= 2015) %>%
    ggplot(aes(x = season, y = total_points, colour = name)) + geom_point() + geom_line() +
    ylim(c(1500,NA))
# dev.off()

jpeg("Nima_kambiz_comparison.jpg", width = 1200, height = 600)
helli66_history %>% 
    filter(name %in% c("Kambiz Jamshidi", "Nima Hamedani-Raja")) %>% 
    dcast(season ~ name, value.var = "total_points") %>%    
    ggplot(aes(x =`Nima Hamedani-Raja`, y = `Kambiz Jamshidi`, label = season )) + 
    geom_text(colour = "blue") +
    geom_abline(slope = 1, intercept =  0, colour = "red")
dev.off()
