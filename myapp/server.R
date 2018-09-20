library(shiny)
library(shiny)
library(datasets)
library(ggplot2)
library(plotly)
data("cars")

shinyServer(function(input, output) {
     
     fit1 <- lm(dist~speed-1, cars)
     x <- seq(0,30,by=0.1)
     y <- fit1$coefficients[1]*x
     f1 <- as.data.frame(cbind(x,y))
     
     fit2 <- glm(dist~speed + I(speed^2) -1, data=cars)
     x <- seq(0,30,by=0.1)
     y <- fit2$coefficients[2]*x^2 + fit2$coefficients[1]*x
     f2 <- as.data.frame(cbind(x,y))
     
     cutspeed <- 20
     d1 <- as.data.frame(cbind(cars,speedsp=ifelse(cars$speed > cutspeed, cars$speed - cutspeed, 0 )))
     fit4 <- lm(dist~speedsp+speed-1, data=d1)
     x <- seq(0,30,by=0.1)
     x2 <- ifelse(x > cutspeed, x - cutspeed, 0 )
     y <- fit4$coefficients[2]*x + fit4$coefficients[1]*x2
     f4 <- as.data.frame(cbind(x,y))
     
     yint1 <- reactive({
          xii <- input$xint
          predict(fit1, newdata = data.frame(speed = xii))
     })
     
     yint2 <- reactive({
          xii <- input$xint
          predict(fit2, newdata = data.frame(speed = xii))
     })

     yint4 <- reactive({
          xii <- input$xint
          predict(fit4, newdata = data.frame(speed = xii,
                                             speedsp = ifelse(xii > cutspeed,
                                                              xii - cutspeed, 0 )))
     })
     
     tgl1 <- function() {geom_line(data=f1,aes(x=x,y=y), color="black", size=input$lnwt/2)}
     tgl2 <- function() {geom_line(data=f2,aes(x=x,y=y), color="red", size=input$lnwt/2)}
     tgl3 <- function() {geom_line(data=f4,aes(x=x,y=y), color="blue", size=input$lnwt/2)}
     
     plot <- reactive({
          p = ggplot() +
               geom_point(data=cars, aes(x=speed,y=dist),alpha=input$ptalpha/100) +
               coord_cartesian(xlim=c(0,30),ylim=c(0,150)) +
               geom_vline(xintercept = input$xint, size=input$lnwt/2) +
               geom_hline(yintercept = yint1(), linetype=2, color="black", size=input$lnwt/2) +
               geom_hline(yintercept = yint2(), linetype=2, color="red", size=input$lnwt/2) +
               geom_hline(yintercept = yint4(), linetype=2, color="blue", size=input$lnwt/2) +
               geom_point(aes(x=input$xint,y=yint1()), color="black", size=2.5) +
               geom_point(aes(x=input$xint,y=yint2()), color="red", size=2.5) +
               geom_point(aes(x=input$xint,y=yint4()), color="blue", size=2.5) +
               labs(x="Speed/Miles per Hour", y="Stopping Distance/Feet") +
               scale_x_continuous(breaks = seq(0,30,by=2)) +
               scale_y_continuous(breaks = seq(0,150,by=10)) +
               theme(legend.position = "none") + theme_classic()
          if(input$mod1tg) {p = p + tgl1()}
          if(input$mod2tg) {p = p + tgl2()}
          if(input$mod3tg) {p = p + tgl3()}
          p
     })
     
     output$plot <- renderPlotly({
          print(
               ggplotly(plot())
          )
     })
     
     output$tout0 <- renderText({paste("Car stopping distance at ",input$xint,"mph (",round(input$xint/1.6,1), "km/h )")})
     output$tout1 <- renderText({paste("Black Linear model:",round(yint1(),2),"feet (",round(yint1()/0.3,2), "meters )")})
     output$tout2 <- renderText({paste("Red Polynomial model:",round(yint2(),2),"feet (",round(yint2()/0.3,2), "meters )")})
     output$tout3 <- renderText({paste("Blue Spline model:",round(yint4(),2),"feet (",round(yint4()/0.3,2), "meters )")})
})