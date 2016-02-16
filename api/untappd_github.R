### Untappd API ###
### Carson Forter ###

library(jsonlite)
library(httr)
library(data.table)

id <- 'insert id'
secret <- 'insert secret'

get_beer <- function(id, secret, beer_id) {
  data <- GET(paste0("https://api.untappd.com/v4/beer/info/", beer_id), 
              query=list(client_id=id, client_secret=secret))
  beer_info <- fromJSON(toString(data))
  beer_details <- beer_info$response[[1]][16]
  checkins <- as.data.frame(beer_info$response[[1]][19])
  venues <- rbindlist(lapply(checkins$media.items.venue, FUN=function(x) data.frame(x[1:3])))
  venue_loc <- rbindlist(lapply(checkins$media.items.venue, FUN=function(x) data.frame(c(x[6]))))
  venue_comb <- as.data.frame(cbind(venues, venue_loc))
  checkins$venue_id <- unlist(c(lapply(checkins$media.items.venue, FUN=function(x) ifelse(!is.null(x$venue_id), x$venue_id, 'No Location'))))
  checkins_loc <- merge(checkins, venue_comb, by.x="venue_id", by.y="venue_id", all.x=T)
  checkins_stats <- cbind(checkins_loc, rbind(unlist(c(beer_details))))
  checkins_stats
}

### Example call for Lagunitas IPA ###
lagunitas_ipa <- get_beer(id, secret, '4509')

### Iterate over many beers ###
beer_ids <- c()
all_beers <- do.call(rbind, lapply(beer_ids, FUN=function(x) get_beer(id, secret, x)))
.
