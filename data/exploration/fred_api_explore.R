
# Exploring the FRED API 
# --------------------------------------------------
# The FRED® API is a web service that allows developers 
# to write programs and build applications that retrieve 
# economic data from the FRED® and ALFRED® websites hosted 
# by the Economic Research Division of the Federal Reserve 
# Bank of St. Louis. Requests can be customized according 
# to data source, release, category, series, and other 
# preferences.

# first need to request API key
# https://research.stlouisfed.org/useraccount/apikeys
# then install fredr package 
# devtools::install_github("sboysel/fredr")

library(fredr)
library(dplyr)
library(ggplot2)
library(ggfortify)
library(ggvis)
library(lubridate)

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

# clear out unused dataframes
beer_sales <- NULL
beer_inventory <- NULL

# trend of beer sold by month
beer_data %>% ggvis(~month, ~sales) %>% 
    layer_points(fill:='red') %>% 
    layer_smooths(stroke='blue')

# trend of beer sold with lin. reg.
beer_data %>% ggvis(~month, ~sales) %>% 
    layer_lines(stroke:='red') %>% 
    layer_model_predictions(model="lm", se=T)

# trend of beer inventory by month 
beer_data %>% ggvis(~month, ~inventory) %>% 
    layer_lines(stroke:='red') %>% 
    layer_smooths()

# trend of beer inventory with lin. reg.
beer_data %>% ggvis(~month, ~inventory) %>% 
    layer_points(fill='blue') %>% 
    layer_model_predictions(model="lm", se=T)

# beer sales by month, sized by inventory with tooltip rendered through shiny
# beer_data %>% ggvis(~month, ~sales, size=~inventory) %>% 
#     layer_points(fill:='blue') %>% 
#     add_tooltip(function(df) df$sales)

# trend of ratio of beer sold to beer inventory by month
beer_data %>% ggvis(~month, ~sold_ratio) %>% 
    layer_points(fill:='green') %>% 
    layer_smooths()

# stepwise increment of ratio of sales runsum to inventory runsum
beer_data %>% ggvis(~ts, ~history_sold_ratio) %>%
    layer_bars()

series <- c("SALES"="darkgreen", "INVENTORY"="blue", "DIFF"='gray')
ggplot(data=beer_data, aes(x=month)) + 
    geom_line(aes(y=sales, group=1, color='SALES')) +
    geom_line(aes(y=inventory, group=2, color='INVENTORY')) + 
    geom_area(aes(y=unsold, group=3, color="DIFF")) + 
    scale_color_manual(name="Legend", values=series, 
                       guide=guide_legend(override.aes=aes(fill=NA))) +
    scale_fill_manual(name="Legend", values=series, guide='none') +
    xlab("Months 1992-01-01 to 2015-12-01") + 
    ylab("Millions of Dollars") + 
    ggtitle("Beer Sales and Inventory for the last 24 Years") +
    theme_minimal()

beer_model <- lm(sales ~ inventory + month, data=beer_data)
summary(beer_model)
autoplot(beer_model)

beer_by_month <- beer_data %>%
    filter(month >= '2010-01-01') %>%
    group_by(mnth=month(month)) %>%
    summarise(beer_sold=mean(sales),
              beer_made=mean(inventory))

ggplot(data=beer_by_month, aes(x=mnth)) + 
    geom_line(aes(y=beer_sold, color='avg. sold')) +
    geom_line(aes(y=beer_made, color='avg. prod')) + 
    scale_color_manual(name="Legend", values=c('darkgreen', 'darkblue')) + 
    scale_x_continuous(breaks=seq(1,12,1)) + 
    scale_y_continuous(breaks=seq(0,15000,2500), limits=c(0,15000)) + 
    xlab("Month of Year") + ylab("Millions of Dollars") + 
    ggtitle("Seasonality of Beer Sales Since 2010") +
    theme_minimal()

# write out dataframe for data directory
write.csv(beer_data, 
          "~/R/w210_beer_demand/data/FRED_beer_inventory_sales.csv", 
          row.names=F)
# writing out dataframes to csv for Rmd
write.csv(beer_data, 
          "~/R/w210_beer_demand/data/exploration/FRED_beer_inventory_sales.csv", 
          row.names=F)
write.csv(beer_by_month, 
          "~/R/w210_beer_demand/data/exploration/FRED_beer_by_month.csv", 
          row.names=F)