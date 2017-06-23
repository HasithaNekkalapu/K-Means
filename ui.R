
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hasitha Nekkalapu - 1001511218 "),
  
  textInput("caption_1", "DIS", ""),
  
  textInput("caption_2", "SEC", ""),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 20,
                  value = 4)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      textOutput("txt1"),
      plotOutput("clustertPlot"),
      plotOutput("barPlot")
    )
  )
))