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

source("rendering_functions.R")
source("database_functions.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  user <- reactiveValues(logged = FALSE)
  
  db_res <- reactive({
    
    cnx <- db_connect(input$txtLogin, input$txtPassword)
    
    validate(
      need(cnx, message = F)
    )
    
    
    res <- RPostgres::dbSendQuery(
      cnx,
      "select * from customers where customerid = $1",
      params = list(input$cust_id)
    )
    
    rst <- dbFetch(res)
    
    dbDisconnect(cnx)
    
    return(rst)
  })
  
  
  observe({
    
    if (!user$logged){
      
      output$page <- renderUI({
        
        renderLoginPage()
      })
    } else {
      
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
      
      hlp_res <- RPostgres::dbSendQuery(
        cnx,
        statement = "select max(customerid) from customers"
      )
      
      max_cust_id <- dbFetch(hlp_res)
      
      
      updateNumericInput(
        session,
        inputId = "cust_id",
        max = max_cust_id
      )
      
      dbDisconnect(cnx)
    }
  })
  
  
  # output$customers <- renderTable({
  #   
  #   cnx <- db_connect(input$txtLogin, input$txtPassword)
  #   
  #   validate(
  #     need(cnx, message = F)
  #   )
  #   
  #   
  #   res <- RPostgres::dbSendQuery(
  #     cnx,
  #     "select * from customers where customerid = $1",
  #     params = list(input$cust_id)
  #   )
  #   
  #   db_res$rst <- dbFetch(res)
  #   
  #   
  #   dbDisconnect(cnx)
  #   
  #   db_res$rst
  # })
  
  
  output$rst_cust_id <- renderText({
    db_res()$customerid
  })
  
  output$rst_fname <- renderText({
    db_res()$firstname
  })
  
  output$rst_lname <- renderText({
    db_res()$lastname
  })
  
  output$rst_address1 <- renderText({
    db_res()$address1
  })
  
  output$rst_address2 <- renderText({
    db_res()$address2
  })
  
  
  observeEvent(input$lnkLogOut, {
    
    user$logged = FALSE
  })
  
  
})
