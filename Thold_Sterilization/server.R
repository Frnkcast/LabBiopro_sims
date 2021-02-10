#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(mosaic)

#T1, T2, A, Ed

kd <- makeFun(A*exp(-Ed/(R*(Temp+273.15)))~Temp, Ed = 67.7, 
              A = 1.0e+36, R = 1.9872e-3)

thd_T <- makeFun(log(N1/N2)/(A*exp(-Ed/(R*(Temp+273.15)))) ~ Temp,
                 N1 = 1e+06, N2 = 1e-03, Ed = 67.7, 
                 A = 1.0e+36, R = 1.9872e-3)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Crea tabla de datos de tiempo y kD usando el rango de Temperaturas de entrada
    Data <- reactive({Table <- tibble(Temp = seq(input$Trange[1], input$Trange[2], by = 5),
                              Kd = kd(Temp), 
                              t = thd_T(Temp, N1 = 10^(input$N1), N2 = 10^(-input$N2)))})
    
    # Genera el valor del tiempo de sostenimiento a partir de la Temp de esterilización
    t_hold <- reactive({temp <- thd_T(input$Th, N1 = 10^(input$N1), N2 = 10^(-input$N2))})
    t_hold_Min <- reactive({temp <- thd_T(input$Th, N1 = 10^(input$N1), N2 = 10^(-input$N2))/60})

    
    output$multiPlot <- renderPlot({
        #Usando IF's para poder elegir entre 2 graficas usando el valor de los botones
        if(input$scala == 1){
            ggplot(data = Data(), aes(x = Temp, y = t))+
                geom_point()+geom_line()+
                geom_vline(aes(xintercept = input$Th), color = "red", linetype = 2)+
                geom_hline(aes(yintercept = t_hold()), color = "red", linetype = 2)+
                labs(x = "T [°C]", y = "Tiempo de sostenimiento [s]")
        } else if (input$scala == 2){
            ggplot(data = Data(), aes(x = Temp, y = t))+
                geom_point()+geom_line()+
                geom_vline(aes(xintercept = input$Th), color = "red", linetype = 2)+
                geom_hline(aes(yintercept = t_hold()), color = "red", linetype = 2)+
                scale_y_log10()+annotation_logticks(side = "l")+
                labs(x = "T [°C]", y = "Tiempo de sostenimiento [s] (escala logaritmica)")
        }
    })
    
    output$tHd <- renderText({
        paste0("El tiempo de retención a la temperatura de esterilización (",
              input$Th, "°C) es de: ", round(t_hold(),2), " segundos (o ", round(t_hold_Min(),2),
              " minutos).")
        
    })
    
    

})
