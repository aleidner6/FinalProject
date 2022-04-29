library(shiny)
library(tidyverse)
library(fmsb)



ui <- fluidPage(
  textInput("Batter", 
            "Batter", 
            value = "", 
            placeholder = "Type Name Here"),
  submitButton(text = "Create my plot!"),
  plotOutput(outputId = "radarPlot")
)



server <- shinyServer(function(input, output) {
  output$radarPlot <- renderPlot({
    Shiny_filter = Final_data[c("Max", "Min", input$Batter , "Mean"), ]
      
    
    
    colors_border = c(rgb(0.2, 0.5, 0.5, 0.9),
                      rgb(0.8, 0.2, 0.5, 0.9) ,
                      rgb(0.7, 0.5, 0.1, 0.9))
    colors_in = c(rgb(0.2, 0.5, 0.5, 0.4),
                  rgb(0.8, 0.2, 0.5, 0.4) ,
                  rgb(0.7, 0.5, 0.1, 0.4))
    
    radarchart(Shiny_filter,
      pcol = colors_border ,
      pfcol = colors_in ,
      plwd = 4 ,
      plty = 1,
      cglcol = "grey",
      cglty = 1,
      axislabcol = "grey",
      cglwd = 0.8,
      vlcex = 0.8
    )
    
  })
})

shinyApp(ui = ui, server = server)