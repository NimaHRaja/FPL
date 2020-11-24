# I've updated fplscrapR::get_league to read 
# username and password are read from a local file.

get_league_updated <- 
    
    function (leagueid = NULL, leaguetype = "classic") 
    {
        if (is.null(leagueid)) 
            stop("You'll need to input a league ID, mate.")
        if (length(leagueid) != 1) 
            stop("One league at a time, please.")
        {
            fplfetchhandle <- curl::new_handle()
            curl::handle_setform(fplfetchhandle, 
                                 login = read.csv("login_data.csv") %>% select(username) %>% as.character(), 
                                 password = read.csv("login_data.csv") %>% select(password) %>% as.character(), 
                                 redirect_uri = "https://fantasy.premierleague.com/a/login", 
                                 app = "plfpl-web")
            fplfetchmemory <- curl::curl_fetch_memory("https://users.premierleague.com/accounts/login/", 
                                                      handle = fplfetchhandle)
            }
        if (fplfetchmemory$url != "https://fantasy.premierleague.com/a/login?state=success") 
            stop("The authentication didn't work. You've most likely entered an incorrect FPL email and/or password.")
        {
            league <- jsonlite::fromJSON(curl::curl(paste("https://fantasy.premierleague.com/api/leagues-", 
                                                          leaguetype, "/", leagueid, "/standings/", 
                                                          sep = ""), handle = fplfetchhandle))
            return(league)
            }
    }