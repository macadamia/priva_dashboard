# Priva Dashboard for Ayr
library(shiny)

source('global.R')
source('helpers.R')

ui <- dashboardPage(skin = "green",
                    
    dashboardHeader(title = "Priva (Ayr)"),
    
    dashboardSidebar(
      radioButtons("metVariable","Choose type",
                   c("Measured Temperature 1" = "temp0001", "Measured Temperature 2" = "temp0002"),
                   selected = "temp001")
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
        )
      ),
)


