# Priva Dashboard for Ayr
library(shiny)

source('global.R')
source('helpers.R')

ui <- dashboardPage(skin = "green",
                    
    dashboardHeader(title = "Priva (Ayr)", titleWidth = 250),
    
    dashboardSidebar( width = 250,
      dateRangeInput("dateRange", label = "Date Range", start = "2023-06-01", min = "2023-06-01", end = as.character(Sys.Date()), max = as.character(Sys.Date()) ),
      checkboxInput("allData", "Get All Data", value = F),
      downloadButton("downloadData", "Download")
      ),
      
      dashboardBody(
        tags$header(tags$meta(name="description", content="Ayr Protected Cropping"),
                    tags$script(src = 'https://kit.fontawesome.com/69344d48e4.js')
        ),
        useShinyjs(),
        tabsetPanel(id = "mainPanelSet",
                    tabPanel("Graphs & Forecasts",                
                             fluidRow(
                               fluidRow(
                                 plotlyOutput("temp1")
                               ),
                               fluidRow(
                                 plotlyOutput("temp2")
                               )
                             )
                    ),
        ),
  )
)


