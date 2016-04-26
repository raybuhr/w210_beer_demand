
# join beer brewery data to beer_info.csv ---------------------------------
library(dplyr)
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "beer",
                 host = "localhost", port = 5432,
                 user = "ray", password = Sys.getenv("PGPW"))

q = dbGetQuery(con, "select * 
               from untappd_breweries")

dbDisconnect(con)

q = filter(q, Country=="United States") %>% 
    select(Brewery_ID, State) %>% 
    filter(!is.na(State) & State != "")

beers = left_join(beers, q, by="Brewery_ID")

q = beers %>% group_by(State) %>% summarise(amt=n())

beers$State = gsub("CA 92121", replacement = "CA", beers$State, ignore.case = FALSE)
beers$State = gsub("Connecticut, 06478", replacement = "CT", beers$State, ignore.case = FALSE)
beers$State = gsub("IN 46319", replacement = "CT", beers$State, ignore.case = FALSE)
beers$State = gsub("MI, 48089", replacement = "CT", beers$State, ignore.case = FALSE)
beers$State = toupper(beers$State)


write.csv(beers, "beer_info.csv", row.names = FALSE)
