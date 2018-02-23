#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(DBI)
library(RPostgres)
library(dplyr)
library(tidyr)

source("rendering_functions.R")
source("database_functions.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  user <- reactiveValues(logged = FALSE) # to track if a user's logged in
  
  cursor <- reactiveValues(position = 1) # resulting recordset navigation
  
  db_res <- eventReactive(input$btnLogin, {
    
    # returns a recordset with customer information;
    # row level security policies are defined in the database, so we don't have to
    # handle security issues in the code; instead we can just query the database.
    
    cnx <- db_connect(input$txtLogin, input$txtPassword)
    
    
    validate(
      need(cnx, message = "Unable to connect to the database.")
    )
    
    
    rst <- queryDB(
      cnx,
      sql = "select * from customer order by customer_id"
    )
    
    
    dbDisconnect(cnx)
    
    return(rst)
  })
  
  
  observe({
    # which page should we render:
    
    if (!user$logged){
      # user's not logged in
      output$page <- renderUI({
        
        renderLoginPage()
      })
    } else {
      # user is authorized to see the content
      output$page <- renderUI({
        
        renderAuthorised()
      })
    }
  })
  
  
  observeEvent(input$btnLogin, {


    cnx <- db_connect(input$txtLogin, input$txtPassword)


    if(is.null(cnx)){

      shinyjs::toggle("login-failed", condition = T)

    } else {

      user$logged <- TRUE

      dbDisconnect(cnx)

    }
  })
  
  
  observeEvent(input$btnNext, {
    
    cursor$position <- min(cursor$position + 1, nrow(db_res()))
  })
  
  
  observeEvent(input$btnPrev, {
    
    cursor$position <- max(1, cursor$position - 1)
  })
  
  
  output$tblRst <- renderTable({
    
    validate(
      need(db_res(), message = "The recordset is empty.")
    )

    db_res()[cursor$position,] %>% gather()
    
  })
  
  
  observe({
    
    if (user$logged){
      db_res()
      cursor$position <- 1
    }
      
  })
  
  
  observeEvent(input$lnkLogOut, {
    
    user$logged = FALSE
  })
  
  
  output$txtInfo <- renderText({
    
    sprintf("%i of %i records", cursor$position, nrow(db_res()))
  })
  
})
