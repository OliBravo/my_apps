library(shiny)
library(leaflet)
library(ggmap)
library(geosphere)
library(dplyr)


ui <- bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  leafletOutput("my_map", width = "100%", height = "100%"),
  
  absolutePanel(
    top = 20,
    right = 20,
    fixed = T,
    draggable = T,
    
    actionButton("btnGenerate", "Generate data"),
    
    sliderInput("radius", "Set the radius:",
                min = 500,
                max = 5000,
                value = 1000,
                step = 500)
    
  ),
  
  tableOutput("tblData"), 
  
  plotOutput("ward")
)


server <- function(input, output, session){
  
  distM <- reactive({
  
    
    if (!is.null(need(map_points$lng, message = F)))
      return(NULL)
    
    
    pp <- as.data.frame(cbind(map_points$lng,
               map_points$lat))
  
    a <- apply(pp, 1, function(x){
      xlng <- x[1]
      xlat <- x[2]
      
      geosphere::distHaversine(
        p1 = c(xlng, xlat),
        p2 = pp
      )
    })
    
    
    return(a)
  })
  
  map_points <- reactiveValues(lng = NULL, lat = NULL, id = NULL)
  
  
  map_data <- eventReactive(input$btnGenerate, {
    
    N <- 100
    
    longitude <- rnorm(N)/20 + 16.95
    latitude <- rnorm(N)/20 + 52.4
    
    map_points$lng = longitude
    map_points$lat = latitude
    map_points$id = paste0("Point_",1:N)
    
    data.frame(longitude, latitude)
  })
  
  
  
  observeEvent(input$my_map_marker_mouseover, {
    click <- input$my_map_marker_mouseover
    clng <- click$lng
    clat <- click$lat
    
    print(c(clng, clat))
    
    
      address <- revgeocode(c(clng, clat))
      
      leafletProxy("my_map") %>%
        clearShapes() %>%
        addCircles(lng = clng, lat = clat, radius = input$radius,
                   popup = address)
    
    
  })
  
  
  observeEvent(input$my_map_marker_mouseout, {
    
    leafletProxy("my_map") %>%
      clearShapes()
  })
  
  
  observeEvent(input$my_map_click, {
    
    click <- input$my_map_click
    clng <- click$lng
    clat <- click$lat
    
    lbl <- paste0("POINT_",length(map_points$lng) + 1)
    
    leafletProxy("my_map") %>%
      addMarkers(lng = clng, lat = clat, label = lbl)
    
    map_points$lng <- c(map_points$lng, clng)
    map_points$lat <- c(map_points$lat, clat)
    map_points$id[length(map_points$lng)] <- paste0("New_point_", length(map_points$lng))
  })
  
  
  output$my_map <- renderLeaflet({
    
    leaflet(map_data()) %>% addMarkers(data = map_data(),
                                       label = paste0("POINT_", row.names(map_data()))) %>%
      addTiles()
      
  })
  
  
  observe({
    
    
    
    try({
      if (input$my_map_zoom <= 13){
      
      
      leafletProxy("my_map") %>%
        clearMarkers() %>%
        clearShapes()
      
      dst <- distM()
      
      dst2 <- as.dist(dst)
      
      
      ward_fit <- hclust(d = dst2, method = "ward.D2")
      
      output$ward <- renderPlot({
        
        plot(ward_fit)
      })
      
      
      K <- round(nrow(dst)/ ifelse(input$my_map_zoom <= 11, 8, 3), 0) + 1
      
      
      
      groups <- cutree(ward_fit, k = K)
      
      for (i in 1:K){
        idx <- which(groups == i)
        
        gr <- cbind(map_points$lng[idx],
                    map_points$lat[idx])
        
        leafletProxy("my_map") %>%
          addMarkers(lng = mean(gr[,1]),
                     lat = mean(gr[,2]),
                     label = (paste("aggregated:", length(idx))))
      }} else {
      
      leafletProxy("my_map") %>%
        clearMarkers() %>%
        addMarkers(lng = map_points$lng,
                   lat = map_points$lat,
                   label = map_points$id)
      }
    })
  })
  
  
  output$tblData <- renderTable({
    
    map_data()
  })
  
}


shinyApp(ui, server)
