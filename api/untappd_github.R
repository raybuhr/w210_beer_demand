### Untappd API ###
### Carson Forter ###

library(jsonlite)
library(httr)
library(data.table)

id <- 'insert id'
secret <- 'insert secret'


#https://api.untappd.com/v4/method_name?client_id=CLIENTID&client_secret=CLIENTSECRET
#https://api.untappd.com/v4/beer/info/3839

get_beer <- function(id, secret, beer_id) {
  # Initial GET request and parsing JSON 
  data <- GET(paste0("https://api.untappd.com/v4/beer/info/", beer_id), 
              query=list(client_id=id, client_secret=secret))
  beer_info <- fromJSON(toString(data[[1]]))
  
  beer_details <- data.frame(cbind(bid = beer_info$response$beer$bid, 
                                   beer_name = beer_info$response$beer$beer_name,
                                   brewery = beer_info$response$beer$brewery$brewery_name,
                                   brewery_state = beer_info$response$beer$brewery$location$brewery_state,
                                   brewery_city = beer_info$response$beer$brewery$location$brewery_city,
                                   brewery_lat = beer_info$response$beer$brewery$location$lat,
                                   brewery_lng = beer_info$response$beer$brewery$location$lng,
                                   monthly_count = beer_info$response$beer$stats$monthly_count,
                                   total_count = beer_info$response$beer$stats$monthly_count,
                                   total_user_count = beer_info$response$beer$stats$total_user_count))
  
  venues <- rbindlist(lapply(beer_info$response$beer$media$items$venue, FUN=function(x) data.frame(x[1:3])))
  venue_loc <- rbindlist(lapply(beer_info$response$beer$media$items$venue, FUN=function(x) data.frame(c(x[7]))))
  venue_comb <- as.data.frame(cbind(venues, venue_loc))
  venue_id <- unlist(c(lapply(beer_info$response$beer$media$items$venue, FUN=function(x) ifelse(!is.null(x$venue_id), x$venue_id, 'No Location'))))
  
  beer_checkin <- data.frame(cbind(beer_info$response$beer$media$items$beer, 
                                   beer_info$response$beer$media$items$brewery,
                                   beer_info$response$beer$media$items$use,
                                   venue_id))
  
  venue_merge <- merge(beer_checkin, venue_comb, by.x="venue_id", by.y="venue_id", all.x=T)                                  
  merged <- merge(beer_details, venue_merge, by.x="bid", by.y="bid", all.x=T)
  merged[,-c(29,30)]
}


### Test call ### 
ipa <- get_beer(id, secret, '4509')

### Iterate over many beers ###
beer_ids <- c('4509', '3839')
all_beers <- do.call(base::rbind, c(lapply(beer_ids, FUN=function(x) {
  df <- get_beer(id, secret, x)
  row.names(df) <- NULL
  df
  }
  ))
)