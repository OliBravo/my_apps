# functions to call in order to render appropriate page


renderLoginPage <- function(){
  fluidPage(
  
    tags$head(
      tags$link(href = "style.css", rel="stylesheet", type="text/css")
    ),
    
    tags$div(
      
      id = "login-container",
      
      class = "wrapper",
      
      wellPanel(
        
        textInput("txtLogin", "Login"),
        
        passwordInput("txtPassword", "Password"),
        
        actionButton("btnLogin", type = "button", "Sign In")
      ),
      
      wellPanel(
        
        id = "login-failed",
        
        # tags$div(
        "Unable to connect to the database."
        # )
        
      )
    ),
    
    mainPanel(
      
    )
  )
}


renderAuthorised <- function(){
  
  fluidPage(
    
    tags$div(
      class = "log-container",
      
      tags$div(
        id="succ_login",
        "Successfully signed in."),
      
      tags$div(
        id="logout",
        actionLink("lnkLogOut", "Log out")
      )
    )
    ,
    
    
    sidebarLayout(
      sidebarPanel(
        numericInput("cust_id",
                     label = "Customer ID:",
                     min = 1,
                     max = 1,
                     value = 1)
      ),
      
      mainPanel(
        
        wellPanel(
          tags$label("Customer ID:"),
          textOutput("rst_cust_id", inline = T),
          tags$br(),
          
          tags$label("First name:"),
          textOutput("rst_fname", inline = T),
          tags$br(),
          
          tags$label("Last name:"),
          textOutput("rst_lname", inline = T),
          tags$br(),
          
          tags$label("Address 1:"),
          textOutput("rst_address1", inline = T),
          tags$br(),
          
          tags$label("Address 2:"),
          textOutput("rst_address2", inline = T)
          # tags$br()
          
        )    
      )
    )
    
  )
}



renderAccessDenied <- function(){
  
  fluidPage(
    
    tags$div("Access denied. You have no permission to see the content."),
    
    actionButton("btnBackToLogin", label = "Sign In")
  )
}