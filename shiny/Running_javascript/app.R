# simple shiny app just to test the JS function call

library(shiny)

ui <- fluidPage(
  tags$head(
    
    # tags$meta(content = "charset=windows-1250"),
    
    tags$script(src = "message-handler.js"),
    
    tags$script(src = "scripts.js", charset = "utf-8")),
  
  actionButton("do", "Click Me"),
  
  actionButton("btnSayHello", "Say Hello!", onclick = "sayhello('Hello world :) ');"),
  
  actionButton("btnHandler1", "Toggle background"),
  
  tags$div(
    id = "myDiv",
    "Jakub Małecki"
  )
  
  
)

server <- function(input, output, session) {
  observeEvent(input$do, {
    session$sendCustomMessage(type = 'testmessage',
                              message = 'Thank you for clicking')
  })
  
  
  observeEvent(input$btnHandler1, {
    
    message1 = input$btnHandler1
    
    session$sendCustomMessage("handler1", message1)
  })
  
}

shinyApp(ui, server)