# remotes::install_github("wiscostret/fplscrapR")

library(fplscrapR)

fplscrapR::get_player_hist(111) %>% View()
fplscrapR::get_entry_hist(222) %>% View()
fplscrapR::get_entry_picks(333,2)$picks %>% View()
fplscrapR::get_league(22) %>% View()
fplscrapR::get_player_id()
