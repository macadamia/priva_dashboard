# Priva Dashboard for Ayr
library(shiny)

source('global.R')
source('helpers.R')

ui <- dashboardPage(skin = "green",
                    
    dashboardHeader(title = "Priva (Ayr)", titleWidth = 250),
    
    dashboardSidebar( width = 250,
      uiOutput("uiDateRange"),
      checkboxInput("allData", "Get All Data", value = F),
      downloadButton("downloadData", "Download"),
      textInput("searchText","Search...",placeholder = "Sensor Name"),
      selectInput("name", "Name of Variable", choices = unique(datapoints$name), selected = head(datapoints$name,1))
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
                                 plotlyOutput("graph")
                               ),
                             )
                    ),
        ),
  )
)


