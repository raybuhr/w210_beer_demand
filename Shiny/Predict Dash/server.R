shinyServer(function(input, output, session) {
  
 library(randomForest)
# load('beerRF2.Rdata')
 # model <- readRDS("beerRF.rds")
 model <- readRDS("beerRF_v2.rds")
  output$gen_map <- renderText({
    print(input$abv)
    print(input$style)
    beer_to_predict <- data.frame(cbind(abv_factor=input$abv),
                                        ibu_factor=input$ibu, 
                                        style_category=input$style,
                                        state_factor=input$state)
    
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
    
    beer_to_predict$state_factor <- factor(beer_to_predict$state_factor, 
                                           levels=c("OH",  "All", "TX",  "CA",  "PA",  "RI",  "FL",  "IL",  "NY",  "NJ",  "NC",  "KY",  "MD",  "MO",  "NE",  "MI",  "VA",  "VT", 
                                                    "CO",  "MN",  "SC",  "IA",  "DE",  "AZ",  "NH",  "OR",  "WA",  "MA",  "WI",  "CT",  "MS",  "SD",  "LA",  "TN",  "HI",  "GA", 
                                                    "IN",  "NM",  "DC",  "OK",  "ME",  "MT",  "UT",  "AK",  "AL",  "ID",  "NV",  "WV",  "KS",  "WY",  "AR",  "ND"))
    
    prediction <- round(predict(model, beer_to_predict), 3)
    toString(prediction)
  })
  
})