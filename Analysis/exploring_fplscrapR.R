# Exploring the library ......


# remotes::install_github("wiscostret/fplscrapR")

library(fplscrapR)

fplscrapR::get_league(22) %>% View()
fplscrapR::get_player_id()


fplscrapR::get_entry(11111) %>% View()
fplscrapR::get_entry_captain(1234,4) %>% View()
fplscrapR::get_entry_hist(5421) %>% View()
A <- fplscrapR::get_entry_picks(53720,6)
A$automatic_subs %>% View()
A$entry_history %>% View()
A$picks %>% View()
fplscrapR::get_entry_player_picks(8024,2) %>% View()
fplscrapR::get_entry_season(83230) %>% View()
fplscrapR::get_fdr() %>% View()
fplscrapR::get_game_list() %>% View()
fplscrapR::get_game_stats(35) %>% View()
B <- fplscrapR::get_league(897187)
B$league %>% View()
B$new_entries %>% View()
B$standings$results %>% View()
C <- fplscrapR::get_league_entries(897187)
D <- fplscrapR::get_player_details()
fplscrapR::get_player_hist(2) %>% View()
fplscrapR::get_player_id("Hugo Lloris") %>% View()
fplscrapR::get_player_info("Hugo Lloris") %>% View()
fplscrapR::get_player_name(4) %>% View()
fplscrapR::get_round_info(2) %>% View()


