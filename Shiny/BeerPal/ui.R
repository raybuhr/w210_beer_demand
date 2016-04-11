library(shiny)
library(rAmCharts)

shinyUI(fluidPage(
    sidebarLayout(
     conditionalPanel(condition="1==1",
      sidebarPanel(
        selectInput("beer_style",
                    h2("Style of Beer"),
                    choices = bp_styles$Style,
                    selected = "All"
                    ),
        selectInput("beer_state",
                    h2("State of Brewery"),
                    choices = bp_states$state,
                    selected = "All"
                    )
        )
      ),
        mainPanel(
            amChartsOutput("amhistchart")
        )
    )
))