# --------------------------------------------------------------
# OpenBeerDB 
# http://www.openbeerdb.com/
# --------------------------------------------------------------

setwd('/home/ray/R/w210_beer_demand/data/')

# Downlaad the OpenBeerDB datasets
system("wget http://openbeerdb.com/files/openbeerdb_csv.zip")
# Unzip the archive
system("unzip openbeerdb_csv.zip")

setwd('/home/ray/R/w210_beer_demand/data/openbeerdb_csv/')

# read csv files into local dataframes

beers <- read.csv("beers.csv", stringsAsFactors = FALSE)
breweries <- read.csv("breweries.csv", stringsAsFactors = FALSE)
breweries_geocode <- read.csv("breweries_geocode.csv", stringsAsFactors = FALSE)
categories <- read.csv("categories.csv", stringsAsFactors = FALSE)
styles <- read.csv("styles.csv", stringsAsFactors = FALSE)

# cleanup of dataframes
beers <- beers[,c(1:9,11)]
beers$id <- as.integer(beers$id)
beers$brewery_id <- as.integer(beers$brewery_id)
beers$cat_id <- ifelse(beers$cat_id==-1, NA, beers$cat_id)
beers$cat_id <- as.integer(beers$cat_id)
beers$style_id <- ifelse(beers$style_id==-1, NA, beers$style_id)
beers$style_id <- as.integer(beers$style_id)
beers$abv <- as.numeric(beers$abv)
beers$ibu <- as.numeric(beers$ibu)
beers$srm <- as.numeric(beers$srm)
beers <- beers[is.na(beers$id)!=TRUE,]

breweries <- breweries[, c(1:10,12)]
breweries$id <- as.integer(breweries$id)
colnames(breweries) <- c(colnames(breweries)[1:6], 'zipcode', colnames(breweries)[8:11])

# styles, categories and geocode data look good

# Inset the csv files to PostgreSQL db
library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "beer",
                        host = "localhost", port = 5432,
                        user = "ray", password = Sys.getenv("PGPW"))

dbWriteTable(con, "openbeerdb_beers", beers, row.names=FALSE, append=TRUE)
dbWriteTable(con, "openbeerdb_breweries", breweries, row.names=FALSE, append=TRUE)
dbWriteTable(con, "openbeerdb_breweries_geocode", breweries_geocode, row.names=FALSE, append=TRUE)
dbWriteTable(con, "openbeerdb_categories", categories, row.names=FALSE, append=TRUE)
dbWriteTable(con, "openbeerdb_styles", styles, row.names=FALSE, append=TRUE)

# test run on pg db

beers_in_texas <- dbGetQuery(con, "
select 
    beers.id as beer_id,
    beers.name as beer_name,
    cat.cat_name as beer_category,
    styles.style_name as beer_style,
    beers.abv as beer_abv,
    beers.ibu as beer_ibu,
    breweries.name as brewery_name,
    breweries.state as brewery_state
from
    openbeerdb_beers as beers
    left join openbeerdb_breweries as breweries
        on beers.brewery_id = breweries.id
    left join openbeerdb_categories as cat
        on beers.cat_id = cat.id
    left join openbeerdb_styles as styles 
        on beers.style_id = styles.id
where 
    breweries.state = 'Texas'
")

# head(beers_in_texas)
# --------------------
# beer_id                                     beer_name beer_category           beer_style
# 1    5734                           Phoenixx Double ESB   British Ale Extra Special Bitter
# 2    5324                                    Jasparilla   British Ale              Old Ale
# 3    5798                                  Iron Thistle   British Ale           Scotch Ale
# 4    5741 (512) Whiskey Barrel Aged Double Pecan Porter     Irish Ale               Porter
# 5    5738                            (512) Pecan Porter     Irish Ale               Porter
# 6    3638                      Texas Special 101 Porter     Irish Ale               Porter
# beer_abv beer_ibu                brewery_name brewery_state
# 1      7.2        0    Real Ale Brewing Company         Texas
# 2      9.0        0     Independence Brewing Co         Texas
# 3      8.0        0 Rahr & Sons Brewing Company         Texas
# 4      8.2        0       (512) Brewing Company         Texas
# 5      6.8        0       (512) Brewing Company         Texas
# 6      0.0        0  Hoffbrau Steaks Brewery #1         Texas

dbDisconnect(con)
