#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

#T1 y T2 son sliders
#A y Ea tambien es son slider

# Define UI for application
shinyUI(fluidPage(

    # Application title
    titlePanel("Tiempo para Esterilizacion a cierta Temperatura"),

    # Sidebar with a slider input for temperatuee
    sidebarLayout(
        sidebarPanel(
            
            helpText("Seleccione los siguientes parametros"),
            
            sliderInput("N1",
                        "Numero de microorganismos contaminantes (10^x) [N1]",
                        min = 1,max = 12, value = 6),
            
            sliderInput("N2",
                        "Probabilidad de contaminacion (10^-x) [N2]",
                        min = 1,max = 10, value = 3),
            
            sliderInput("Trange",
                        "Rango de temperaturas a visualizar (°C)",
                        min = 50,max = 200, value = c(80,135)),
            
            sliderInput("Th",
                        "Temperatura de sostenimiento (°C) [Thd]",
                        min = 50,max = 200, value = 121),
            
            #Opcion para elegir modo logaritmico
            radioButtons("scala", "Elige la escala para graficar el tiempo:",
                         choices = list("Escala real" = 1, "Escala logaritmica" = 2),
                         selected = 1)
            
        ),


        mainPanel(
            # Muestra el grafico,
            # para opcion logaritmica, probar con case_when
            #plotOutput(outputId = "Plot"),
            plotOutput(outputId = "multiPlot"),
            
            #plotOutput(outputId = case_when("Escala" == 1 ~ "realPlot",
            #                                "Escala" == 2 ~ "logPlot")),
            #Muestra una leyenda de texto
            textOutput("tHd")
        )
    )
))
