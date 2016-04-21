library(shiny)
library(rAmCharts)

bp_styles = read.csv("beerpal_styles.csv", stringsAsFactors = FALSE)
bp_states = read.csv("beerpal_states.csv", stringsAsFactors = FALSE)

shinyUI(fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectInput("beer_style",
                    h3("Style of Beer"),
                    choices = bp_styles$Style,
                    selected = "All"
                    ),
        selectInput("beer_state",
                    h3("State of Brewery"),
                    choices = bp_states$state,
                    selected = "All"
                    ),
        selectInput("category",
                    h3("Category"),
                    choices = c("rating", "reviews"),
                    selected = "rating")
        )
      ,
        mainPanel(
            amChartsOutput("amhistchart")
        )
    )
))