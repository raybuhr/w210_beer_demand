library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "beer",
                 host = "localhost", port = 5432,
                 user = "ray", password = Sys.getenv("PGPW"))

untappd_beers <- read.csv("data/untappd/beer_info.csv", stringsAsFactors = FALSE)
dbWriteTable(con, "untappd_beers", untappd_beers, row.names=FALSE, append=TRUE)

untappd_breweries <- read.csv("data/untappd/breweries.csv", stringsAsFactors = FALSE)
dbWriteTable(con, "untappd_breweries", untappd_breweries, row.names=FALSE, append=TRUE)

untappd_users <- read.csv("data/untappd/user_info.csv", stringsAsFactors = FALSE)
dbWriteTable(con, "untappd_users", untappd_users, row.names=FALSE, append=TRUE)

dbDisconnect(con)
