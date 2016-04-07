shinyServer(function(input, output, session) {
  library(ggplot2)
  library(scales)
  library(shiny)
  library(dplyr)
  library(grid)
  library(tidyr)
  library(maps)
  library(ggmap)

  beers <- read.csv('beers_with_style_3_15.csv')
  output$gen_map <- renderPlot({
    
    state_lookup <- data.frame(cbind(name = c('All', 'alabama', 'arizona', 'arkansas', 'california', 'colorado', 'connecticut',
                                              'deleware', 'florida', 'georgia', 'idaho', 'illinois', 'indiana',
                                              'iowa', 'kansas', 'kentucky', 'louisiana', 'maine', 'maryland', 'massachusetts',
                                              'michigan', 'minnesota', 'mississippi', 'missouri', 'montana', 'nebraska', 'nevada', 'new hampshire', 'new jersey',
                                              'new mexico', 'new york', 'north carolina', 'north dakota', 'ohio', 'oklahoma', 'oregon',
                                              'pennsylvania', 'rhode island', 'south carolina', 'south dakota', 'tennessee', 'texas',
                                              'utah', 'vermont', 'virginia', 'washington', 'west virginia', 'wisconsin', 'wyoming'),
                                     
                                     code = c('.', 'AL', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', "FL", 
                                              "GA", 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 
                                              'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY',
                                              'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX',
                                              'UT', 'VT', 'VA', 'WA', 'WV', 'WI', "WY")), stringsAsFactors = F)
    state_name <- state_lookup$name[state_lookup$code == input$state] #input$state
    state_map <- map_data("state", region = state_name)
    
    
    set.seed(123) #to control jitter
    
    selected_state <- paste0('\"',input$state, '\"')
    beers_sub <- beers %>%
      filter_(ifelse(input$state == 'All', "1==1", paste("location.venue_state ==", selected_state)))
    
    q <- ggplot() + 
      geom_point(data = beers_sub, aes(x = location.lng, y = location.lat,  
                fill = style_category, colour = style_category), 
                alpha=0.6, size = 5, position = position_jitter(w = 0.03, h = 0.03)) +
      #scale_fill_manual(values= colors) +
      #scale_color_manual(values= colors) +
      geom_polygon(data = state_map, aes(x = long, y= lat, group = group), fill=NA, colour='gray') +
      theme_classic() + 
      theme(line = element_blank(), title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank())
    
    print(q + coord_map())
  })
  
  
})