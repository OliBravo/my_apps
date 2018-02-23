# database functions


db_connect <- function(login, password){
  
  # opens a connection to dvdrental database
  
  if (login == "" | password == ""){
    
    return(NULL)
  }
    
  # valid logins-passwords are: web-web, mike-mike123, jon-jon123
  DB_NAME <- "dvdrental"
  DB_HOST <- "localhost"
  DB_PORT <- 5432
  
  DB_USER <- login
  DB_PASSWORD <- password
  
  cnx <- try(
    dbConnect(
      RPostgres::Postgres(),
      dbname = DB_NAME,
      host = DB_HOST,
      user = DB_USER,
      password = DB_PASSWORD,
      port = DB_PORT),
    silent = F
  )
  
  
  # connection failed:
  if (class(cnx) == "try-error"){
    
    msg <- "Connection error"
    
    # database or server issues:
    if (grepl("could not connect to server",
             as.character(cnx))){
      
      msg <- "Could not connect to the server."
    }
  
    # authorization issues:
    if (grepl("authentication failed", as.character(cnx)) | grepl("permission denied", as.character(cnx)))
      msg <- "You are not allowed to access the content."
    

    showNotification(msg)
    
    return(NULL)
  }
  
  cnx
}



queryDB <- function(connection, sql, params = NULL){
  
  # tries to query the database using RPostgres::dbSendQuery method
  # returns NULL in case of errors
  
  tryCatch({
    r <- RPostgres::dbSendQuery(
      connection,
      sql,
      params = params
    )
    
    r <- dbFetch(r)
    
    r
  },
  error = function(e) {
    print(as.character(e))
    NULL
  })
  
}

