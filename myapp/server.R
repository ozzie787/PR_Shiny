library(shiny)
library(datasets)
library(ggplot2)
library(plotly)
data("cars")

shinyServer(function(input, output) {
     
     currxint <- function() {
          reactive({as.numeric(input$xint)})
     }
     
     fit1 <- lm(dist~speed-1, cars)
     fit2 <- glm(dist~speed + I(speed^2) -1, data=cars)
     cutspeed <- 20
     d1 <- as.data.frame(cbind(cars,speedsp=ifelse(cars$speed > cutspeed, cars$speed - cutspeed, 0 )))
     fit4 <- lm(dist~speedsp+speed-1, data=d1)
     
     x <- seq(0,30,by=0.1)
     y <- fit1$coefficients[1]*x
     f1 <- as.data.frame(cbind(x,y))
     
     x <- seq(0,30,by=0.1)
     y <- fit2$coefficients[2]*x^2 + fit2$coefficients[1]*x
     f2 <- as.data.frame(cbind(x,y))
     
     x <- seq(0,30,by=0.1)
     x2 <- ifelse(x > cutspeed, x - cutspeed, 0 )
     y <- fit4$coefficients[2]*x + fit4$coefficients[1]*x2
     f4 <- as.data.frame(cbind(x,y))
     
     xint <- currxint()
     ndat <- as.data.frame(xint)
     colnames(ndat) <- "speed"
     yint1 <- predict(fit1, newdata = ndat)
     
     output$plot <- renderPlotly({
          print(
               ggplotly( ggplot() +
               geom_point(data=cars, aes(x=speed,y=dist),alpha=input$ptalpha/100) +
               coord_cartesian(xlim=c(0,30),ylim=c(0,130)) +
               geom_line(data=f1,aes(x=x,y=y), color="black", size=input$lnwt/2) +
               geom_line(data=f2,aes(x=x,y=y), color="red", size=input$lnwt/2) +
               geom_line(data=f4,aes(x=x,y=y), color="blue", size=input$lnwt/2) +
               geom_vline(xintercept = input$xint, size=input$lnwt/2) +
               labs(x="Speed/Miles per Hour", y="Stopping Distance/Feet") +
               scale_x_continuous(breaks = seq(0,30,by=2)) +
               scale_y_continuous(breaks = seq(0,150,by=10)) +
               theme_classic() + theme(legend.position = "none"))
          )
     })
     
     output$tout1 <- renderText({input$xintusr})
     output$tout2 <- renderText({input$ptalpha})
     output$tout3 <- renderText({input$lnwt})
})