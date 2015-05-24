
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyAce)

shinyUI(fluidPage(
  titlePanel("Major harming factors for US economy and health: 60-years survey"), 
  
  sidebarLayout(
    sidebarPanel(
      helpText("StormData Highlights based on NOAA Strom Database."),
      
      br(),
      
      radioButtons("Sector", 
                         label = h5("Choose the influenced sector:"), 
                         choices = list("Economy" = 1, 
                                        "Helth" = 2),
                         selected = 1),
      
      br(),
#      dateRangeInput("dates", label = h3("Date range"),format = "yyyy-mm-dd"),
#      br(),
      selectInput("view", 
                  label = "Select the view:",
                  choices = list("Bar Plot", "Table"),
                  selected = 1),
      
      br(),
      
      conditionalPanel("input.view=='Bar Plot'", 
                       sliderInput("topfactors", label = "Number of factors to display:",
                         min = 2, max = 40,2)
                       
      
      ),      
      conditionalPanel("input.view=='Table'",
                       selectInput(inputId = "pagesize",
                                  label = "Rows per page",
                                  choices=list("10"=10,"20"=20,"50"=50,"200"=200),
                                  selected = NULL,multiple = FALSE)
      )
 #     submitButton('Submit')
    ),
  
     
    mainPanel(
      wellPanel(
        conditionalPanel(
          condition = "input.view=='Bar Plot'&input.Sector==1",
          plotOutput("barPlot")
        ),
        conditionalPanel(
          condition = "input.view=='Bar Plot'&input.Sector==2",
          plotOutput("barPlotH",height = "800px")
        ),
        conditionalPanel(
          condition = "input.view=='Table'&input.Sector==1",
          h4(helpText("Mean crop and property damages per year")),
          htmlOutput("tableD")
        ),
        conditionalPanel(
          h4(helpText("Mean number of Fatalities and Injuries per year")),
          condition = "input.view=='Table'&input.Sector==2",
          htmlOutput("tableH")
        )
      )
      
      
    )  
  )
))
