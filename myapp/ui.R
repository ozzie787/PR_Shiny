library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("My App"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
         sliderInput("xint","Speed of 1920's Car (miles/hour):", min=0, max=30, value=15, step=0.1),
         sliderInput("ptalpha","%Point ocapacity:", min=0, max=100, value=50, step=1),
         sliderInput("lnwt","Graph line width", min=0, max=5, value=1, step=0.1),
         checkboxInput("mod1tg","Show/Hide fit 1", value=TRUE),
         checkboxInput("mod2tg","Show/Hide fit 2", value=TRUE),
         checkboxInput("mod3tg","Show/Hide fit 3", value=TRUE)
         # submitButton()
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
         plotlyOutput("plot"),
         "Hola",
         textOutput("tout1"),
         textOutput("tout2"),
         textOutput("tout3")
    )
  )
))
