# database functions


db_connect <- function(login, password){
  
  # DB_USER <- "reader"
  # DB_PASSWORD <- "reader"
  DB_NAME <- "ds2"
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
  
  if (class(cnx) == "try-error")
    return(NULL)
  
  cnx
}