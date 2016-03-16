# ----------------------------------------------------------
# More FRED data 
# ----------------------------------------------------------

# Context and background notes for Price Index data located 
# in root at FRED_PPI_notes.md

library(dplyr)
library(fredr)
library(RPostgreSQL)

# Producer Price Index by Industry: Breweries: 
#    Bottled Beer and Ale Case Goods
# 2016-01: 174.9 Index Jun 1982=100 (+ see more) 
# Monthly, Not Seasonally Adjusted, PCU3121203121204Z, Updated: 2016-02-17 10:41 AM CST
fred_beer_price_index <- fredr(endpoint="series/observations", series_id='PCU3121203121204Z')
fred_beer_price_index <- fred_beer_price_index[, 3:4]
colnames(fred_beer_price_index) <- c("index_date", "breweries_bottles_cases")


# Producer Price Index by Industry: Beer, Wine, and Liquor Stores
# 2016-01: 126.0 Index Jun 2000=100 (+ see more) 
# Monthly, Not Seasonally Adjusted, PCU44534453, Updated: 2016-02-17 10:37 AM CST
t <- fredr(endpoint="series/observations", series_id='PCU44534453')
t <- t[,3:4]
colnames(t) <- c("index_date", "beer_wine_liquor_stores")

#join on index date
fred_beer_price_index <- left_join(fred_beer_price_index, t, by="index_date")

# Producer Price Index by Industry: Breweries: Canned Beer and Ale Case Goods
# 2016-01: 216.2 Index Jun 1982=100 (+ see more) 
# Monthly, Not Seasonally Adjusted, PCU3121203121201, Updated: 2016-02-17 10:41 AM CST
t <- fredr(endpoint="series/observations", series_id='PCU3121203121201')
t <- t[,3:4]
colnames(t) <- c("index_date", "breweries_cans_cases")

#join on index date
fred_beer_price_index <- left_join(fred_beer_price_index, t, by="index_date")

# Producer Price Index by Industry: Breweries: Beer and Ale in Barrels and Kegs
# 2016-01: 278.0 Index Jun 1982=100 (+ see more) 
# Monthly, Not Seasonally Adjusted, PCU3121203121207, Updated: 2016-02-17 10:41 AM CST
t <- fredr(endpoint="series/observations", series_id='PCU3121203121207')
# api inserted a lot of bad data here, so cut out that part
t <- t[116:nrow(t),3:4]
colnames(t) <- c("index_date", "breweries_barrels_kegs")

#join on index date
fred_beer_price_index <- left_join(fred_beer_price_index, t, by="index_date")

# Producer Price Index by Industry: Breweries
# 2016-01: 203.1 Index Jun 1982=100 (+ see more) 
# Monthly, Not Seasonally Adjusted, PCU312120312120, Updated: 2016-02-17 10:41 AM CST
t <- fredr(endpoint="series/observations", series_id='PCU312120312120')
t <- t[,3:4]
colnames(t) <- c("index_date", "breweries_overall")

#join on index date
fred_beer_price_index <- left_join(fred_beer_price_index, t, by="index_date")

# Producer Price Index by Industry: Merchant Wholesalers, Nondurable Goods: 
#    Wholesale Distribution of Beer, Wine, and Distilled Alcoholic Beverages
# 2016-01: 114.2 Index Feb 2009=100 (+ see more) 
# Monthly, Not Seasonally Adjusted, PCU4240004240008, Updated: 2016-02-17 10:37 AM CST
t <- fredr(endpoint="series/observations", series_id='PCU4240004240008')
t <- t[,3:4]
colnames(t) <- c("index_date", "wholesalers")

#join on index date
fred_beer_price_index <- left_join(fred_beer_price_index, t, by="index_date")

# format data types for db
fred_beer_price_index$index_date <- as.Date(fred_beer_price_index$index_date)
fred_beer_price_index[,2:7] <- as.numeric(unlist(fred_beer_price_index[,2:7]))
fred_beer_price_index <- data.frame(fred_beer_price_index)

# All Employees: Retail Trade: Beer, Wine, and Liquor Stores in California
# 2015-12: 16.9 Thousands of Persons (+ see more) 
# Monthly, Not Seasonally Adjusted, SMU06000004244530001, Updated: 2016-01-27 1:06 PM CST
ca_employees <- fredr(endpoint="series/observations", series_id='SMU06000004244530001')
ca_employees <- ca_employees[,3:4]
colnames(ca_employees) <- c("index_date", "employees")
ca_employees$employees <- as.numeric(ca_employees$employees) * 1000

# format data types for db
ca_employees$index_date <- as.Date(ca_employees$index_date)
ca_employees$employees <- as.numeric(ca_employees$employees)
ca_employees <- data.frame(ca_employees)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "beer",
                 host = "localhost", port = 5432,
                 user = "ray", password = Sys.getenv("PGPW"))

dbWriteTable(con, "fred_beer_price_index", fred_beer_price_index, 
             row.names=FALSE, append=TRUE)

dbWriteTable(con, "ca_beer_liquor_store_employees", ca_employees, 
             row.names=FALSE, append=TRUE)

dbDisconnect(con)
