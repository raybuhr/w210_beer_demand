### Make Model
library(randomForest)
library(ggplot2)
beers <- read.csv("beer_info.csv", stringsAsFactors=FALSE)
nrow(beers)
colnames(beers)[8] <- 'beer_style'
colnames(beers)

ipas <- unique(beers$beer_style[grepl('IPA', beers$beer_style, ignore.case=T)])
lagers <- unique(beers$beer_style[grepl('lager', beers$beer_style, ignore.case=T)])
stouts <- unique(beers$beer_style[grepl('stout', beers$beer_style, ignore.case=T)])
porters <- unique(beers$beer_style[grepl('porter', beers$beer_style, ignore.case=T)])
browns <- unique(beers$beer_style[grepl('brown', beers$beer_style, ignore.case=T)])
pales <- unique(beers$beer_style[grepl('pale', beers$beer_style, ignore.case=T)])
belgians <- unique(beers$beer_style[grepl('belgian', beers$beer_style, ignore.case=T)])
wheats <- unique(beers$beer_style[grepl('wheat', beers$beer_style, ignore.case=T)])
sours <- c(unique(beers$beer_style[grepl('sour', beers$beer_style, ignore.case=T)]),
           unique(beers$beer_style[grepl('wild', beers$beer_style, ignore.case=T)]))
reds <- unique(beers$beer_style[grepl('red', beers$beer_style, ignore.case=T)])
blondes <- unique(beers$beer_style[grepl('blonde', beers$beer_style, ignore.case=T)])

beers$style_category[beers$beer_style %in% pales] <- 'Pale'
beers$style_category[beers$beer_style %in% lagers] <- 'Lager'
beers$style_category[beers$beer_style %in% stouts] <- 'Stout'

beers$style_category[beers$beer_style %in% porters] <- 'Porter'
beers$style_category[beers$beer_style %in% browns] <- 'Brown'
beers$style_category[beers$beer_style %in% ipas] <- 'IPA'

beers$style_category[beers$beer_style %in% belgians] <- 'Belgian'
beers$style_category[beers$beer_style %in% wheats] <- 'Wheat'
beers$style_category[beers$beer_style %in% sours] <- 'Sour'

beers$style_category[beers$beer_style %in% reds] <- 'Red'
beers$style_category[beers$beer_style %in% blondes] <- 'Blonde'
beers$style_category[is.na(beers$style_category)] <- 'Other'

beers$abv_factor <- factor(ifelse(beers$ABV < 3, '< 3%',
                                  ifelse(beers$ABV < 5, '3% - 4.9%',
                                         ifelse(beers$ABV < 8, '5% - 7.9%',
                                                ifelse(beers$ABV <= 10, '8% - 10%', '> 10%')))))

beers$ibu_factor <- factor(ifelse(beers$IBU < 10, '< 10',
                                  ifelse(beers$IBU < 26, '11 - 25',
                                         ifelse(beers$IBU < 51, '26 - 50',
                                                ifelse(beers$IBU < 76, '51 - 75',
                                                       ifelse(beers$IBU < 100, '76 - 100', '> 100'))))))


beers$style_category <- as.factor(beers$style_category)
beers$rating_factor <- as.factor(floor(beers$Overall_Rating))
beers$abv_factor <- factor(beers$abv_factor, levels=c('< 3%', 
                                                      '3% - 4.9%',
                                                      '5% - 7.9%',
                                                      '8% - 10%', 
                                                      '> 10%'))
beers$ibu_factor <- factor(beers$ibu_factor, levels=c('< 10', 
                                                      '11 - 25',
                                                      '26 - 50',
                                                      '51 - 75', 
                                                      '76 - 100',
                                                      '> 100'))
# Interaction terms
model <- randomForest(Overall_Rating ~ abv_factor + ibu_factor + style_category + 
                        (style_category * abv_factor) +
                        (style_category * ibu_factor), data=beers)
save(model, file='beerRF.RData')