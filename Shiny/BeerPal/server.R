library(shiny)
library(rAmCharts)

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
    bp_styles = bp %>% 
        group_by(Style) %>% 
        summarise(amount=n()) %>% 
        filter(amount >= 16)
    bp_states = bp %>% 
        group_by(state) %>% 
        summarise(amount=n())
    output$amhistchart <- renderAmCharts({
        ratings = bp[bp$Style == input$beer_style & bp$state == input$beer_state, 6]
        amHist(x = ratings
               , creditsPosition = "top-right"
               )
    })
})