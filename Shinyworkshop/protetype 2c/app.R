library(shiny)
library(sf)
library(tmap)
library(tidyverse)

mpsz <- st_read(dsn = "data/geospatial", 
                layer = "MP14_SUBZONE_WEB_PL")

ui <- fluidPage(
  titlePanel("A simple map display"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE)
    ),
    mainPanel(
      plotOutput("mapPlot"),
      DT::dataTableOutput(outputId = "szTable")
    )
  )
)

server <- function(input, output){
  output$mapPlot <- renderPlot({
    tm_shape(mpsz)+
      tm_fill() +
      tm_borders(lwd = 0.1,  alpha = 1)
  })
  output$szTable <- DT::renderDataTable({
    if(input$show_data){
      DT::datatable(data = mpsz %>% select(1:7),
                    options= list(pageLength = 10),
                    rownames = FALSE)
    }
  })    
}

shinyApp(ui = ui, server = server)
