.libPaths = c("/home/ray/R/x86_64-pc-linux-gnu-library/3.2", .libPaths())
source("/home/ray/.Renviron")

library(microserver)
# First of all you need to define the routes for which your app will be responding.
# There is no differentiation between GET, POST, PUT, etc. - all routes respond
# to all types of requests

routes <- list(
    # every route is a map between path and the function that should be called
    # on the request
    # Let's make a route with path 'hello' that returns 'world'
    '/hello' = function(...) 'world',
    # That simple!
    # Now let's make something more complicated
    # Let's make a route 'sum' that would sum all the inputs for a JSON payload
    # that looks like {"values": [1,2,3,-5.6,...]}
    # and let's make it work with POST requests (or, generally speaking)
    # for requests that have a JSON body
    '/sum'   = function(p, q) {
        if (length(p) == 0) 'must be a POST request' else sum(unlist(p$values))
    },
    # You can also submit a wildcard route that will be called
    # whenever someone queries a route that was not specified
    # in the configuration
    function(...) { "This is microserver demo" },
    
    # My own takes on this, returning beers from a queried state
    '/state_beers' = function(p, q) {
        if (length(p) != 1) 'must be a POST request for a single state' 
        else
        library(RPostgreSQL)
        drv <- dbDriver("PostgreSQL")
        con <- dbConnect(drv, dbname = "beer",
                         host = "localhost", port = 5432,
                         user = "ray", password = Sys.getenv("PGPW"))
        query <- paste0("
                    select 
                        beers.name as beer_name,
                        cat.cat_name as beer_category,
                        styles.style_name as beer_style,
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
                        breweries.state IN ('", unlist(p$values), "');"
                            )
        result <- dbGetQuery(con, query)
        dbDisconnect(con)
        data.frame(result)
    }
)
# And then you can just run the server using the routes that you've defined
microserver::run_server(routes, port = 8103)