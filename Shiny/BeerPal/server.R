library(shiny)
library(rAmCharts)
library(dplyr)

shinyServer(function(input, output) {
    bp = read.csv("beerpal_reviews.csv", stringsAsFactors = FALSE)
    bp2 = bp
    bp3 = bp
    bp4 = bp
    bp2$Style = "All"
    bp3$state = "All"
    bp4$Style = "All"
    bp4$state = "All"
    bp = rbind(bp, bp2, bp3, bp4)
    # bp_styles = bp %>% 
    #     group_by(Style) %>% 
    #     dplyr::summarise(amount=n()) %>% 
    #     filter(amount >= 16)
    # write.csv(bp_styles, "beerpal_styles.csv", row.names = FALSE)
    bp_styles = read.csv("beerpal_styles.csv", stringsAsFactors = FALSE)
    # bp_states = bp %>% 
    #     group_by(state) %>% 
    #     dplyr::summarise(amount=n())
    # write.csv(bp_states, "beerpal_states.csv", row.names = FALSE)
    bp_states = read.csv("beerpal_states.csv", stringsAsFactors = FALSE)
    output$amhistchart <- renderAmCharts({
        ratings = bp[bp$Style == input$beer_style & bp$state == input$beer_state, input$category]
        amHist(x = ratings
               , creditsPosition = "top-right"
               )
    })
})