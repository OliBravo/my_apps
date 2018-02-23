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
        
        "Unable to connect to the database."
        
      )
    ),
    
    mainPanel(
      
    )
  )
}


renderAuthorised <- function(){
  
  # when authorization is succesful a user is presented a page with customer information
  
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
        
        tags$p("This is a sample database application. It connects to a PostgreSQL server running on localhost.
               There are security policies defined in the database, so depending on which user is currently logged in
               a different customer recordest is returned."),
        
        tags$p("The application is very simple, but the purpose was to show how user authentication can be implemented.
               Users' logins are the same as in the database. Access to the content is managed entirely by the PostgreSQL's
               privilege system.")
      ),
      
      mainPanel(
        
        wellPanel(
          
          tableOutput("tblRst"),
          
          tags$div(
            
            class = "recordset-nav",
            
            actionButton("btnPrev", "< Previous"),
            
            actionButton("btnNext", " Next >"),
            
            textOutput("txtInfo", inline = T)  
            
          )
        )    
      )
    )
    
  )
}
