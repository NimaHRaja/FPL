# I've updated fplscrapR::get_league_entries to include 
# first and last pages, i.e. skipping the first N pages.

get_league_entries_updated <- 
    
    function (leagueid = NULL, leaguetype = "classic", first_page, num_pages = 1) 
    {
        if (is.null(leagueid)) 
            stop("You'll need to input a league ID, mate.")
        if (length(leagueid) != 1) 
            stop("One league at a time, please.")
        if (num_pages%%1 != 0) 
            stop("The number of pages needs to be a whole number.")
        {
            fplfetchhandle <- curl::new_handle()
            curl::handle_setform(fplfetchhandle, login = readline("Please enter your FPL login email: "), 
                                 password = getPass::getPass(msg = "Please enter your FPL password:"), 
                                 redirect_uri = "https://fantasy.premierleague.com/a/login", 
                                 app = "plfpl-web")
            fplfetchmemory <- curl::curl_fetch_memory("https://users.premierleague.com/accounts/login/", 
                                                      handle = fplfetchhandle)
            }
        if (fplfetchmemory$url != "https://fantasy.premierleague.com/a/login?state=success") 
            stop("The authentication didn't work. You've most likely entered an incorrect FPL email and/or password.")
        {
            entries <- data.frame()
            for (i in first_page:(first_page+num_pages-1)) {
                standings <- jsonlite::fromJSON(curl::curl(paste("https://fantasy.premierleague.com/api/leagues-", 
                                                                 leaguetype, "/", leagueid, "/standings/?", 
                                                                 "page_standings=", i, sep = ""), 
                                                           handle = fplfetchhandle))
                entries <- rbind(entries, standings$standings$results)
            }
            return(entries)
            }
    }