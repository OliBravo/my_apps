library(shiny)
library(leaflet)
library(geojsonio)
library(RColorBrewer)
library(scales)
library(ggmap)


## read from a shape file
# file <- system.file("examples", "bison.zip", package = "geojsonio")
# file <- 
# dir <- tempdir()
# unzip(file, exdir = dir)
# shpfile <- list.files(dir, pattern = ".shp", full.names = TRUE)
# gj <- geojsonio::geojson_read(shpfile, what = "sp")
# class(gj)


ui <- bootstrapPage(
  
  tags$head(
    includeCSS("style/mystyle.css")
  ),
  
  tags$div(
    class = "map-container",
    leafletOutput("my_map", width = "100%", height = "100%")
  )#, 
  
  # absolutePanel(
  #   top = 20,
  #   right = 20,
  #   draggable = T,
  #   fixed = T,
  #   verbatimTextOutput(outputId = "hover_info", placeholder = T)
  # )
  
)


server <- function(input, output, session){
  
  coord <- reactiveValues(lng = NULL, lat = NULL, desc = NULL)
  
  
  output$my_map <- renderLeaflet({
    
    states <- geojsonio::geojson_read("json/poland.geojson", what = "sp", stringsAsFactors = F)
    
    states@data$my_value <- sample(1:100, 16)
    
    
    pal <- colorBin("YlOrRd", domain = 1:100, bins = 5)
    
    
    
    labels <- sprintf(
      "<strong>%s</strong><br/>%g mln PLN sales",
      states@data$name, states@data$my_value
    ) %>% lapply(htmltools::HTML)
    
    # leaflet(states) %>%
    #   setView(18,52,7) %>%
    #   addTiles()
    leaflet(states) %>%
      setView(18,52, 7) %>%
      addPolygons(
        fillColor = ~pal(my_value),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.4,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      addLegend(pal = pal, values = ~my_value, opacity = 0.7, title = NULL,
                position = "bottomright") %>%
      addTiles()
  })
  
  
  observeEvent(input$my_map_click, {
    
    click <- input$my_map_click
    coord$lng <- click$lng
    coord$lat <- click$lat
    
    # print(click)
    
    
    
    shiny::showModal(
      modalDialog(
        title = "Details",

        tags$div(
          class = "detail-desc-outer",
          # tags$div(tags$label("Please add a description to the point:")),
          textAreaInput("txtDesc", label = "Dodaj opis do obiektu:", placeholder = "tutaj opisz obiekt...")
          ),

        footer = tags$div(
          class = "footer-btns",

          actionButton("btnOK", "OK"),
          actionButton("btnCancel", "Cancel")
        )

      )
    )
    
    
  })
  
  
  observeEvent(input$btnOK, {
    
    rev <- revgeocode(c(coord$lng, coord$lat),
                      output = "more")
    
    print(rev$administrative_area_level_1)
    
    leafletProxy("my_map") %>%
      addMarkers(lng = coord$lng,
                 lat = coord$lat,
                 label = rev$address)
    
    shiny::removeModal()
  })
  
  observeEvent(input$btnCancel, {
    
    shiny::removeModal()
  })
  
  
  observeEvent(input$my_map_polygon_click, {
    
    click <- input$my_map_polygon_click
    
    print(click)
  })
  
  
  observeEvent(input$my_map_marker_mouseover, {
    
    ev <- input$my_map_marker_mouseover
    lng <- ev$lng
    lat <- ev$lat
    
    print(ev)
    
    rev <- revgeocode(c(lng, lat),
                      output = "more")
    
    print(rev)
    
    output$hover_info <- renderText({
      
      rev$administrative_area_level_1
    })
  })
}


shinyApp(ui, server)
