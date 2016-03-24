# -----------------------------------------------
# Read FRED Data into PG DB 
# -----------------------------------------------

library(fredr)
library(dplyr)
library(RPostgreSQL)

# read in beer sales and production from Federal Reserve of St Louis API (FRED)
beer_sales <- fredr(endpoint="series/observations", series_id='S4248SM144NCEN')
ts <- seq(1, nrow(beer_sales), 1)
beer_data <- data.frame(ts, beer_sales[,3:4])
beer_data$date <- as.Date(beer_data$date)
beer_data$value <- as.numeric(beer_data$value)


beer_inventory <- fredr(endpoint="series/observations", series_id='I4248IM144SCEN')
beer_data$inventory <- as.numeric(beer_inventory$value)
colnames(beer_data) <- c('ts', 'month', 'sales', 'inventory')
beer_data$inv_runsum <- cumsum(beer_data$inventory)
beer_data$sales_runsum <- cumsum(beer_data$sales)
beer_data$unsold <- beer_data$inventory - beer_data$sales
beer_data$unsold_runsum <- cumsum(beer_data$unsold)
beer_data$sold_ratio <- beer_data$sales / beer_data$inventory
beer_data$history_sold_ratio <- beer_data$sales_runsum / beer_data$inv_runsum

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "beer",
                 host = "localhost", port = 5432,
                 user = "ray", password = Sys.getenv("PGPW"))

dbWriteTable(con, "fred_beer_inventory_sales", beer_data, row.names=FALSE, append=TRUE)

# test the new table with random query 
# s <- paste(sample(seq(1,200,1), 10), collapse=",")
# q <- paste0("select * from fred_beer_inventory_sales where ts in (",
#            s, ")")
# dbGetQuery(con, q)

dbDisconnect(con)
