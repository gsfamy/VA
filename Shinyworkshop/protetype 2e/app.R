library(shiny)
library(sf)
library(tmap)
library(tidyverse)

sgpools <- read_csv("data/aspatial/SGPools_svy21.csv")
sgpools_sf <- st_as_sf(sgpools, 
                       coords = c("XCOORD", 
                                  "YCOORD"),
                       crs= 3414)

ui <- fluidPage(
  titlePanel("Interactive Map View"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput(inputId = "showData",
                    label = "Show data table",
                    value = TRUE)
    ),
    mainPanel(
      tmapOutput("mapPlot"),
      DT::dataTableOutput(outputId = "aTable")
    )
  )
)

server <- function(input, output, session){
  output$mapPlot <- renderTmap({
    tm_shape(sgpools_sf)+
      tm_bubbles(col = "OUTLET TYPE",
                 size = "Gp1Gp2 Winnings",
                 border.col = "black",
                 border.lwd = 0.5)
  })
  output$aTable <- DT::renderDataTable({
    if(input$showData){
      DT::datatable(data = sgpools_sf %>% 
                      select(1:4),
                    options= list(pageLength = 10),
                    rownames = FALSE)
    }
  })    
}

shinyApp(ui = ui, server = server)
