

getDataForDevice <- function(tabname) {
  
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "priva", user = mysqlUser, password = mysqlPassword)
  q <- paste0("select max(timestamp) from`",tabname,"`")
  res <- dbSendQuery(con, q)
  fetched <- dbFetch(res, n=1)
  dbClearResult(res)
  
  recentTimestamp <- fetched$`max(timestamp)`
  threeDaysAgo <- recentTimestamp - 3 * 24 * 3600
  
  q <- paste0("select * from `",tabname,"` where timestamp >= ", threeDaysAgo," and timestamp <= ",recentTimestamp," order by timestamp asc")
  print(q)
  res <- dbSendQuery(con, q)
  fetched <- dbFetch(res, n=-1)
  print(paste("Fetched", nrow(fetched),"records\n"))
  dbClearResult(res)
  
  dbDisconnect(con)
  return(fetched)
}