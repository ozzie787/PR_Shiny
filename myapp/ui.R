library(shiny)
library(datasets)
library(data.table)
library(ggplot2)
library(plotly)
data("cars")

# Define UI for application that draws a histogram
shinyUI(fluidPage(tabsetPanel(

     tabPanel("App", 
  # Application title
  titlePanel("Stopping distance of a 1920's Car"),
  
  # Sidebar with a slider input for car speed 
  sidebarLayout(
    sidebarPanel(
         sliderInput("xint","Speed (miles/hour):", min=0, max=30, value=15, step=0.1),
         sliderInput("ptalpha","% Point ocapacity:", min=10, max=100, value=50, step=1),
         sliderInput("lnwt","Graph line width", min=0.5, max=3, value=1.25, step=0.05),
         checkboxInput("mod1tg","Show/Hide black linear fit", value=TRUE),
         checkboxInput("mod2tg","Show/Hide red polynomial fit", value=TRUE),
         checkboxInput("mod3tg","Show/Hide blue spline fit", value=TRUE)
    ),
    
    # Generate plot and predicted values
    mainPanel(
         plotlyOutput("plot", width = "100%", height = "200%"),
         
         h3(textOutput("tout0")),
         dataTableOutput("dt1"),
         p("Note conversions to metric are approximate: 1 mph = 1.60934 km/h; 1 ft = 0.3048 m.")

    )
  )
     ),
  
     tabPanel("Getting Started",
     
     titlePanel("Getting Started"),
     includeMarkdown("doc.md")
     )
  
)))
