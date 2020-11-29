---
title: "FPL_PCA"
author: "Nima Hamedani-Raja"
date: "28/11/2020"
output: 
  html_document: 
    keep_md: yes
    number_sections: yes
---



# about

Here, I am (back)documenting (some of) the steps I've taken to use *PCA* to analyse *FPL* teams.  
To do: explain template and differentials, PCA, ... 


```r
source("Functions/init.R")
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```
## Warning: package 'ggplot2' was built under R version 3.6.3
```

# Getting data

## Data

I am using *fplscrapR*. I have also modified some of fplscrapR's methods.  
I am focusing on two subsets of data: teams of 8 players who compete in a private league, as well as the top 10K players.  
I am focusing on week 9 rather arbitrarily, simply because that's when I did this!

## getting and cleaning teams

### getting all players of all teams of a league

I'm using *get_a_league_teams()*.


```r
writeLines(readLines("Functions/get_a_league_teams.R"))
```

```
## # get_a_league_teams recieves league_id and week_number
## # and returns the teams of entries of 
## # the given league_id for the given week_number + metadata.
## # it also searches for a local version of the data file before 
## # fetching the data from FPL.
## 
## get_a_league_teams <- function(league_id, week_number, first_page = 1, num_pages = 1){
##     
##     output_file <- 
##         paste("data/entries_teams_", league_id, "_week", week_number, "_", 
##               first_page, "-", num_pages, ".csv", sep = "")
##     
##     if(file.exists(output_file)){
##         
##         output <- read.csv(output_file)
##         
##     }else{
##         
##         league_entries <- get_league_entries_updated(league_id) %>% rename(team_id = id)
##         league_name <- get_league_updated(league_id)$league$name
##         
##         output <- 
##             do.call("rbind", lapply(league_entries$entry,
##                                     function(x){get_entry_player_picks(x, week_number) %>%
##                                             mutate(entry = x)})) %>%
##             inner_join(league_entries, by = "entry") %>%
##             mutate(league_id = league_id,
##                    week_number = week_number,
##                    league_name = league_name)
##         
##         output <- 
##             inner_join(output,
##                        get_players_details(unique(output$id),week_number), 
##                        by = "playername")
##         
##         
##         write.csv(output,output_file, row.names = FALSE)
##     }
##     
##     output
## }
```

```r
private_league_entries_teams_flat <- get_a_league_teams(1138028,9)
head(private_league_entries_teams_flat)
```

```
##    id     playername position multiplier is_captain is_vice_captain event
## 1  35   Ørjan Nyland       12          0      FALSE           FALSE     9
## 2  41   Tyrone Mings        2          1      FALSE           FALSE     9
## 3 106   Ross Barkley        7          1      FALSE           FALSE     9
## 4 123    Reece James        3          1      FALSE           FALSE     9
## 5 128 Vicente Guaita        1          1      FALSE           FALSE     9
## 6 141  Wilfried Zaha       14          0      FALSE           FALSE     9
##     entry  team_id event_total          player_name rank last_rank rank_sort
## 1 5073634 32193448           6 Alireza Bahraminasab    1         1         1
## 2 5073634 32193448           6 Alireza Bahraminasab    1         1         1
## 3 5073634 32193448           6 Alireza Bahraminasab    1         1         1
## 4 5073634 32193448           6 Alireza Bahraminasab    1         1         1
## 5 5073634 32193448           6 Alireza Bahraminasab    1         1         1
## 6 5073634 32193448           6 Alireza Bahraminasab    1         1         1
##   total      entry_name league_id week_number league_name element fixture
## 1   522 Run Forrest Run   1138028           9 Singularity      35      79
## 2   522 Run Forrest Run   1138028           9 Singularity      41      79
## 3   522 Run Forrest Run   1138028           9 Singularity     106      79
## 4   522 Run Forrest Run   1138028           9 Singularity     123      85
## 5   522 Run Forrest Run   1138028           9 Singularity     128      80
## 6   522 Run Forrest Run   1138028           9 Singularity     141      80
##   opponent_team total_points was_home         kickoff_time team_h_score
## 1             3            0     TRUE 2020-11-21T15:00:00Z            1
## 2             3            1     TRUE 2020-11-21T15:00:00Z            1
## 3             3            1     TRUE 2020-11-21T15:00:00Z            1
## 4            14            8    FALSE 2020-11-21T12:30:00Z            0
## 5             4            3    FALSE 2020-11-23T17:30:00Z            1
## 6             4            0    FALSE 2020-11-23T17:30:00Z            1
##   team_a_score round minutes goals_scored assists clean_sheets goals_conceded
## 1            2     9       0            0       0            0              0
## 2            2     9      90            0       0            0              2
## 3            2     9       4            0       0            0              0
## 4            2     9      90            0       0            1              0
## 5            0     9      90            0       0            0              1
## 6            0     9       0            0       0            0              0
##   own_goals penalties_saved penalties_missed yellow_cards red_cards saves bonus
## 1         0               0                0            0         0     0     0
## 2         0               0                0            0         0     0     0
## 3         0               0                0            0         0     0     0
## 4         0               0                0            0         0     0     2
## 5         0               0                0            0         0     3     0
## 6         0               0                0            0         0     0     0
##   bps influence creativity threat ict_index value transfers_balance selected
## 1   0       0.0        0.0      0       0.0    40            -57113   605193
## 2   9      13.2        1.3     19       3.4    53            205584  1035405
## 3   3       0.0        0.0      0       0.0    60             37773   331745
## 4  28      13.2       11.1     11       3.5    50             29343   936916
## 5  18      29.4        0.0      0       2.9    50             -8182   296717
## 6   0       0.0        0.0      0       0.0    74             83431  2263264
##   transfers_in transfers_out
## 1          199         57312
## 2       230729         25145
## 3        74546         36773
## 4        82283         52940
## 5         8858         17040
## 6       208184        124753
```

### Cleaning private_league_entries_teams_flat

Not all these columns are needed. Let's trim it down.


```r
private_league_entries_teams_flat <- private_league_entries_teams_flat %>% 
    select(id, playername,multiplier,entry,player_name,entry_name,league_name,week_number,
           league_name,total_points,value)
tail(private_league_entries_teams_flat)
```

```
##      id                    playername multiplier  entry     player_name
## 115 302 Bruno Miguel Borges Fernandes          2 297082 Kambiz Jamshidi
## 116 377                     Che Adams          1 297082 Kambiz Jamshidi
## 117 390                 Heung-Min Son          1 297082 Kambiz Jamshidi
## 118 435               Aaron Cresswell          1 297082 Kambiz Jamshidi
## 119 457                  Matt Doherty          0 297082 Kambiz Jamshidi
## 120 508               James Rodríguez          1 297082 Kambiz Jamshidi
##     entry_name league_name week_number total_points value
## 115     Kamjam Singularity           9           11   107
## 116     Kamjam Singularity           9            7    59
## 117     Kamjam Singularity           9           10    95
## 118     Kamjam Singularity           9            7    51
## 119     Kamjam Singularity           9            0    58
## 120     Kamjam Singularity           9            2    79
```

Multiplier (used by *FPL API*) demonstrates wether a player was benched (0), played (1), or was captain (2). I'm interested in active teams. so I'll remove the unused subs.


```r
private_league_entries_teams_flat <- private_league_entries_teams_flat %>% filter(multiplier != 0)
```

### dcating private_league_entries_teams_flat

After dcasting, each team is reprented by a vector of 1s(10 player), 2 (the captain), and 0s (the rest).  

```r
private_league_entries_teams <- 
    private_league_entries_teams_flat %>% dcast(player_name ~ playername, value.var = "multiplier")

private_league_entries_teams[is.na(private_league_entries_teams)] <- 0

row.names(private_league_entries_teams) <- private_league_entries_teams$player_name

private_league_entries_teams <- private_league_entries_teams %>% select(-player_name)

t(private_league_entries_teams)
```

```
##                               Alireza Bahraminasab Behrang Tajdin
## Aaron Cresswell                                  0              0
## Aaron Ramsdale                                   0              1
## Alex McCarthy                                    0              0
## Andrew Robertson                                 0              1
## Benjamin Chilwell                                0              1
## Bruno Miguel Borges Fernandes                    2              2
## Callum Wilson                                    0              0
## Che Adams                                        0              0
## Dominic Calvert-Lewin                            1              1
## Emiliano Martínez                                0              0
## Gabriel Magalhães                                1              0
## Hakim Ziyech                                     0              0
## Harry Kane                                       1              0
## Heung-Min Son                                    1              1
## Jack Grealish                                    0              0
## James Justin                                     0              0
## James Rodríguez                                  0              0
## James Ward-Prowse                                0              1
## Jamie Vardy                                      0              1
## Jannik Vestergaard                               0              0
## João Pedro Cavaco Cancelo                        0              0
## Jordan Pickford                                  0              0
## Kasper Schmeichel                                0              0
## Kurt Zouma                                       0              0
## Kyle Walker                                      0              0
## Kyle Walker-Peters                               0              1
## Mateusz Klich                                    0              0
## Max Kilman                                       0              0
## Michael Keane                                    0              0
## Pablo Fornals                                    1              0
## Patrick Bamford                                  1              1
## Reece James                                      1              0
## Ross Barkley                                     1              0
## Tariq Lamptey                                    0              0
## Timo Werner                                      0              0
## Tomas Soucek                                     0              1
## Trent Alexander-Arnold                           0              0
## Tyrick Mitchell                                  0              0
## Tyrone Mings                                     1              0
## Vicente Guaita                                   1              0
## Willian Borges Da Silva                          0              0
## Yves Bissouma                                    0              0
##                               Hamid Hamedani Kambiz Jamshidi Nima H-R
## Aaron Cresswell                            1               1        0
## Aaron Ramsdale                             0               0        0
## Alex McCarthy                              0               0        1
## Andrew Robertson                           0               0        0
## Benjamin Chilwell                          0               1        0
## Bruno Miguel Borges Fernandes              0               2        2
## Callum Wilson                              1               0        0
## Che Adams                                  0               1        0
## Dominic Calvert-Lewin                      1               0        1
## Emiliano Martínez                          1               0        0
## Gabriel Magalhães                          0               0        0
## Hakim Ziyech                               0               1        0
## Harry Kane                                 2               0        1
## Heung-Min Son                              1               1        1
## Jack Grealish                              1               1        1
## James Justin                               1               0        0
## James Rodríguez                            1               1        0
## James Ward-Prowse                          0               0        0
## Jamie Vardy                                0               0        0
## Jannik Vestergaard                         1               0        0
## João Pedro Cavaco Cancelo                  0               0        0
## Jordan Pickford                            0               0        0
## Kasper Schmeichel                          0               1        0
## Kurt Zouma                                 0               0        1
## Kyle Walker                                0               1        0
## Kyle Walker-Peters                         0               0        1
## Mateusz Klich                              0               0        0
## Max Kilman                                 1               0        1
## Michael Keane                              0               0        0
## Pablo Fornals                              0               0        0
## Patrick Bamford                            0               1        1
## Reece James                                0               0        0
## Ross Barkley                               0               0        0
## Tariq Lamptey                              0               0        0
## Timo Werner                                0               0        0
## Tomas Soucek                               0               0        0
## Trent Alexander-Arnold                     0               0        0
## Tyrick Mitchell                            0               0        0
## Tyrone Mings                               0               0        0
## Vicente Guaita                             0               0        0
## Willian Borges Da Silva                    0               0        0
## Yves Bissouma                              0               0        1
##                               Nima Hamedani-Raja Saman Moghimi-Araghi
## Aaron Cresswell                                0                    0
## Aaron Ramsdale                                 0                    0
## Alex McCarthy                                  0                    0
## Andrew Robertson                               0                    0
## Benjamin Chilwell                              0                    0
## Bruno Miguel Borges Fernandes                  2                    0
## Callum Wilson                                  0                    0
## Che Adams                                      1                    0
## Dominic Calvert-Lewin                          1                    1
## Emiliano Martínez                              1                    0
## Gabriel Magalhães                              0                    0
## Hakim Ziyech                                   1                    0
## Harry Kane                                     0                    0
## Heung-Min Son                                  1                    2
## Jack Grealish                                  0                    1
## James Justin                                   0                    0
## James Rodríguez                                0                    0
## James Ward-Prowse                              0                    0
## Jamie Vardy                                    0                    0
## Jannik Vestergaard                             0                    0
## João Pedro Cavaco Cancelo                      1                    0
## Jordan Pickford                                0                    1
## Kasper Schmeichel                              0                    0
## Kurt Zouma                                     1                    1
## Kyle Walker                                    0                    0
## Kyle Walker-Peters                             1                    0
## Mateusz Klich                                  0                    1
## Max Kilman                                     0                    0
## Michael Keane                                  0                    1
## Pablo Fornals                                  0                    0
## Patrick Bamford                                1                    1
## Reece James                                    0                    1
## Ross Barkley                                   0                    0
## Tariq Lamptey                                  1                    0
## Timo Werner                                    0                    1
## Tomas Soucek                                   0                    0
## Trent Alexander-Arnold                         0                    0
## Tyrick Mitchell                                0                    0
## Tyrone Mings                                   0                    0
## Vicente Guaita                                 0                    0
## Willian Borges Da Silva                        0                    1
## Yves Bissouma                                  0                    0
##                               Umar Hussain
## Aaron Cresswell                          0
## Aaron Ramsdale                           0
## Alex McCarthy                            0
## Andrew Robertson                         1
## Benjamin Chilwell                        0
## Bruno Miguel Borges Fernandes            1
## Callum Wilson                            0
## Che Adams                                0
## Dominic Calvert-Lewin                    1
## Emiliano Martínez                        0
## Gabriel Magalhães                        0
## Hakim Ziyech                             0
## Harry Kane                               2
## Heung-Min Son                            1
## Jack Grealish                            1
## James Justin                             0
## James Rodríguez                          1
## James Ward-Prowse                        0
## Jamie Vardy                              0
## Jannik Vestergaard                       0
## João Pedro Cavaco Cancelo                0
## Jordan Pickford                          0
## Kasper Schmeichel                        1
## Kurt Zouma                               1
## Kyle Walker                              0
## Kyle Walker-Peters                       0
## Mateusz Klich                            0
## Max Kilman                               0
## Michael Keane                            0
## Pablo Fornals                            0
## Patrick Bamford                          0
## Reece James                              0
## Ross Barkley                             0
## Tariq Lamptey                            0
## Timo Werner                              0
## Tomas Soucek                             0
## Trent Alexander-Arnold                   1
## Tyrick Mitchell                          1
## Tyrone Mings                             0
## Vicente Guaita                           0
## Willian Borges Da Silva                  0
## Yves Bissouma                            0
```




