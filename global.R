#Global information
library(shinydashboard)
library(shinyjs)
library(shinydashboardPlus)
library(anytime)
library(tidyverse)
library(RMariaDB)
library(plotly)
library(readxl)
library(Dict)

mysqlUser <- 'dashboard_user'
mysqlPassword <- "Mang02020!"


con <- dbConnect(RMariaDB::MariaDB(), dbname = "priva", user = mysqlUser, password = mysqlPassword)
res <- dbSendQuery(con, "select * from datapoints")
datapoints <- dbFetch(res, n=-1)
dbClearResult(res)
dbDisconnect(con)

tableDetails1 <- vector()
for(i in 1:nrow(datapoints)) {
  eval(parse(text=paste0("tableDetails1 <- c(tableDetails1, '",datapoints$name[i],"' = '",datapoints$variableId[i],"')")))
}
tableDetails2 <- tableDetails1


f1 <- list(
  family = "Arial, sans-serif",
  size = 18,
  color = "black"
)

f2 <- list(
  family = "Arial, sans-serif",
  size = 10,
  color = "black"
)

xaxis <- list(
  title = "",
  type='date',
  titlefont = f1,
  tickfont = f2,
  showticklabels = TRUE,
  # nticks= 10,
  tickangle = 45,
  tickformat = "%d %b %I:%M %p",
  hoverformat = "%d %b %I:%M %p"
)

xaxistxt <- list(
  title = "",
  type='text',
  titlefont = f1,
  tickfont = f2,
  showticklabels = TRUE,
  nticks= 5,
  tickangle = 45,
  tickformat = "%d %b",
  hoverformat = "%d %b"
)

temperatureYAxis <- list(
  title = "Temperature (°C)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

genericYAxis <- list(
  title = "Value",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

RhYAxis <- list(
  title = "Relative Humidity (%)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

vpdYAxis <- list(
  title = "Vapour-pressure Deficit (kPa)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

dtYAxis <- list(
  title = "Delta-T (°C)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

dpYAxis <- list(
  title = "Dew Point (°C)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

solradYAxis <- list(
  title = "Solar Radiation(W/m<sup>2</sup>)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

windSpeedYAxis <- list(
  title = "Wind Speed (km/h)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

windDirectionYAxis <- list(
  title = "Wind Direction (º)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1,
  side = "right",
  overlaying = "y"
)

batteryYAxis <- list(
  title = "Battery (V)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

solpanYAxis <- list(
  title = "Solar Panel (V)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)

rainfallYAxis <- list(
  title = "Rainfall (mm)",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f1
)