

getDataForDevice <- function(tabname) {
  
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "priva", user = mysqlUser, password = mysqlPassword)
  q <- paste0("select max(timestamp) from`",tabname,"`")
  res <- dbSendQuery(con, q)
  fetched <- dbFetch(res, n=1)
  dbClearResult(res)
  
  recentTimestamp <- fetched$`max(timestamp)`
  threeDaysAgo <- recentTimestamp - 3 * 24 * 3600
  
  q <- paste0("select * from `",tabname,"` where timestamp >= ", threeDaysAgo," and timestamp <= ",recentTimestamp," order by timestamp asc")
  res <- dbSendQuery(con, q)
  fetched <- dbFetch(res, n=-1)
  dbClearResult(res)
  
  dbDisconnect(con)
  return(fetched)
}

getAllDataForDevice <- function(tabname) {
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "priva", user = mysqlUser, password = mysqlPassword)
  q <- paste0("select * from `",tabname,"`order by timestamp asc")
  res <- dbSendQuery(con, q)
  fetched <- dbFetch(res, n=-1)
  dbClearResult(res)
  
  dbDisconnect(con)
  return(fetched)
}

getDataRangeForDevice <- function(tabname, startTS, endTS) {
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "priva", user = mysqlUser, password = mysqlPassword)
  q <- paste0("select * from `",tabname,"` where timestamp >= ", startTS," and timestamp <= ", endTS," order by timestamp asc")
  res <- dbSendQuery(con, q)
  fetched <- dbFetch(res, n=-1)
  dbClearResult(res)
  
  dbDisconnect(con)
  return(fetched)
}

getTables <- function() {
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "priva", user = mysqlUser, password = mysqlPassword)
  res <- dbSendQuery(con, "show tables like '800000%'")
  fetched <- dbFetch(res, n=-1)
  dbClearResult(res)
  
  dbDisconnect(con)
  return(fetched)
}

getSensorName <- function(tabname) {
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "priva", user = mysqlUser, password = mysqlPassword)
  res <- dbSendQuery(con, paste0("select name from datapoints where variableId = '", tabname, "'"))
  fetched <- dbFetch(res, n=-1)
  dbClearResult(res)
  
  dbDisconnect(con)
  return(fetched$name)
}
