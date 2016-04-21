library(shiny)
shinyUI(fluidPage(
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Roboto+Slab');
      @import url('//fonts.googleapis.com/css?family=Lato:300');
    
      body {
        background-color: #FFFFFF;
        font-family: 'Lato', sans-serif;
                    font-weight: 300;
                    line-height: 1.1;
                    font-size: 14pt;
                    color: #899DA4;
    }
      
      h1 {
        font-family: 'Roboto Slab';
        font-weight: 500;
        line-height: 1.1;
        color: #F26B21;
        display: inline-block;
        margin-top: 0px;
      }

      img {
        font-family: 'Roboto Slab';
        font-weight: 500;
        line-height: 1.1;
        color: #F26B21;
        margin-top: 500px
        align: right;
        display: inline-block;
        }

      h2 {
        font-family: 'Lato', sans-serif;
                    font-weight: 300;
                    line-height: 1.1;
                    font-size: 12pt;
                    color: #899DA4;
      }

      h3 {
        font-family: 'Lato', sans-serif;
                    font-weight: 300;
                    line-height: 1.1;
                    font-size: 8pt;
                    color: #899DA4;

      }

    shiny-plot-output {
        background-color: #00EFD1;
    }

      .test {
        font-family: 'Roboto Slab', serif;
                    font-weight: 100;
                    line-height: 1.1;
                    font-size: 18pt;
                    margin-left: 150px;
                    text-align: left;
                    color: #899DA4;
                    white-space: pre
      }

      .well {
                    background-color: #FFFFFF;
      }

      .irs-bar {
                    background-color: #F26B21;
      }

      .irs-from {
                    background-color: #F26B21;
      }

      .irs-to {
                    background-color: #F26B21;
      }

      a {
              color: #F26B21;
      }
      .shiny-output-error-validation {
              margin-top: 25px;
              margin-left: 10px;
      }
    "))
  ),
  #title="BEER DEMAND",
  #titlePanel(div(h1("BEER DEMAND"))), #, img(src='esh-logo.png', align = "right", width='230px'))),
  sidebarLayout(
    conditionalPanel(condition="1==1",
      sidebarPanel(
      selectInput("state", 
                  h2("Select State"), 
                  choices = c('All', 'AL','AR','AZ',
                              'CA','CO','CT',
                              'DE','FL','GA', 'IA',
                              'ID','IL','IN','KS',
                              'KY','LA','MA','MD',
                              'ME','MI','MN','MO',
                              'MS','MT','NC','ND',
                              'NE','NH','NJ','NM',
                              'NV','NY','OH','OK',
                              'OR','PA','RI','SC',
                              'SD','TN','TX','UT','VA',
                              'WA','WI','WV','WY'), selected='All'),
      width=2
    )),
    mainPanel(
      tabsetPanel(
        #tabPanel("About", div(p(br(), "Beer Demand Dashboard For MIDS W210", br())), width="1000px"),
        tabPanel("Map of Untappd Checkins", fluidRow(column(12, align = "center", plotOutput("gen_map", height="530px", width = "720px"))),
                 div(id="test1", class="test", textOutput("n_observations_ddt")))
         #navbarPage 
      )) #tabsetPanel() & mainPanel()
  ) #sidebarLayout()
))