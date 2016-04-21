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
  if(beer_info$meta$code == 200)
  {
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
  sleep_time <- abs(rnorm(1))
  print(sleep_time)
  Sys.sleep(sleep_time)
  }
}


### Test call ### 
ipa <- get_beer(id, secret, '4509')
beer_info$meta$code
### Iterate over many beers ###
beer_ids <- c('4509', '3839')
beer_ids <- c(86654,
6373,
5180,
10718,
9823,
69711,
46947,
138244,
92859,
28719,
6373,
13359,
87021,
24331,
5771,
6407,
2603,
10050,
917,
4482,
2447,
4509,
25260,
6725,
5173,
5428,
6373,
79957,
13018,
6373,
2391,
4178,
7121,
1382,
1425,
2447,
5659,
14407,
6284,
5428,
5428,
84681,
5558,
6308,
4997,
5011,
5771,
7198,
5180,
4509,
4997,
6731,
6388,
220669,
6284,
1553,
6412,
25796,
6284,
230,
821,
8380,
6373,
5180,
13359,
56064,
8380,
18866,
4041,
36208,
821,
4509,
3899,
821,
6887,
282,
3942,
4509,
1553,
89083,
4472,
25796,
4499,
4041,
120888,
74553,
574587,
4502,
8487,
748369,
10769,
45834,
4498,
39224,
8381,
5775,
6908,
646818,
280,
13359,
4499,
355380,
4499,
6767,
6921,
783273,
730995,
899374,
899374,
2603,
899374,
39846,
61832,
939866,
394451,
8381,
5775,
118443,
472782,
408044,
5040,
678992,
568188,
305204,
568415,
568188,
912763,
444244,
5558,
6908,
5775,
39187,
213707,
6914,
998820,
334312,
385012,
25796,
969250,
5775,
392748,
468139,
6908,
14590,
558747,
1006472,
966648,
966641,
946862,
29359,
7820,
6308,
1051694,
5804,
396906,
5804,
1353,
345505,
795543,
5066,
5804,
568188,
6585,
4499,
682454,
1051694,
2552,
1127084,
1096875,
333947,
6908,
1102998,
130673,
1139141,
5066,
5809,
899374,
302886,
349828,
30257,
21991,
3942,
1150707,
81914,
929842,
1173473,
5180,
178222,
929842,
3834,
52291,
845550,
798245,
1187016,
257657,
929842,
1222075,
1209780,
251864,
1295519,
1029694,
22090,
1325857,
5809,
916696,
789790,
21991,
993362,
958010,
5775,
817322,
1204285,
1256,
1353624,
312280,
1406048)
beer_ids1 <- beer_ids[1:30]
all_beers1 <- do.call(base::rbind, c(lapply(beer_ids1, FUN=function(x) {
  df <- get_beer(id, secret, x)
  row.names(df) <- NULL
  df
  }
  ))
)
nrow(all_bee)

df <- get_beer(id, secret, 140257)
data <- GET(paste0("https://api.untappd.com/v4/beer/info/", 4509), 
            query=list(client_id=id, client_secret=secret))
beer_info <- fromJSON(toString(data[[1]]))
data
