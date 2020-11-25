source("Functions/init.R")
entries_teams <- get_a_league_teams(1138028,9)


entries_teams <- entries_teams %>% filter(multiplier != 0)

AA <- entries_teams %>% dcast(player_name ~ playername, value.var = "multiplier")

AA[is.na(AA)] <- 0

row.names(AA) <- AA$player_name

AA <- AA %>% select(-player_name)

BB <- 
prcomp(AA)


(((BB$x %*% t(BB$rotation)) + (as.matrix(rep(1,8)) %*% t(BB$center))) - AA) %>% melt() %>% summarise(min(value))


BB$x %>% View()
BB$rotation %>% View()

points <- read.csv("points_week9.csv", sep = ";")


CC <- BB$rotation %>% as.data.frame()

CC$player_name <- row.names(CC)

DD <- inner_join(CC, points, by = "player_name")

EE <- DD %>% melt(id.var = c("player_name", "Points")) 

FF <-EE %>% group_by(variable) %>% summarise(PC_points = sum(value*Points)) %>% rename(PC = variable)

GG <- FF %>% select(-PC)

BB$x %*% as.matrix(GG) + 20.625 + 46


HH <- melt(BB$x) %>% mutate(PC = (Var2)) %>% inner_join(FF, by = "PC") %>%
    mutate(PC_points = PC_points * value)

II <- HH %>% dcast(Var1 ~ PC, value.var = "PC_points") 
row.names(II) <- II$Var1
II <- II %>% select(-Var1)


