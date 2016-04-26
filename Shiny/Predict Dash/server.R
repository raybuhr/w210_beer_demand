shinyServer(function(input, output, session) {
  
 library(randomForest)
# load('beerRF2.Rdata')
 model <- readRDS("beerRF.rds")
  output$gen_map <- renderText({
    print(input$abv)
    print(input$style)
    beer_to_predict <- data.frame(cbind(abv_factor=input$abv),
                                        ibu_factor=input$ibu, style_category=input$style)
    beer_to_predict$abv_factor <- factor(beer_to_predict$abv_factor, levels=c('< 3%', 
                                                                              '3% - 4.9%',
                                                                              '5% - 7.9%',
                                                                              '8% - 10%', 
                                                                              '> 10%')) 
    beer_to_predict$ibu_factor <- factor(beer_to_predict$ibu_factor, levels=c('< 10', 
                                                                              '11 - 25',
                                                                              '26 - 50',
                                                                              '51 - 75', 
                                                                              '76 - 100',
                                                                              '> 100'))
    beer_to_predict$style_category <- factor(beer_to_predict$style_category, levels=c('Pale', 'Lager','Stout','Porter','Brown','IPA','Belgian','Wheat','Sour',
                                                                               'Red', 'Blonde', 'Other'))
    
    prediction <- round(predict(model, beer_to_predict), 3)
    toString(prediction)
  })
  
})