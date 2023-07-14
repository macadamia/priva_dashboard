#Priva Dashboard for Ayr

server <- function(input, output, session) {
  
  variable <- reactive({
    print("variable reacted")
    datapoints %>% dplyr::select(name, variableId) %>% dplyr::filter(grepl(input$searchText, name)) # blank searchText returns all
  })
  
  observeEvent(variable(), {
    print("variable updated")
    updateSelectInput(inputId = "name", choices = unique(variable()$name))
  })
  
  chosenTable <- reactive({
    print("ChosenTable")
    datapoints %>% dplyr::select(name, variableId) %>% dplyr::filter(input$name ==name) %>%  select(variableId)
  })
  
  
  output$uiDateRange <- renderUI ({
    today <- Sys.Date()
    lastWeek <- today - 7
    dateRangeInput("dateRange", label = "Date Range", start = as.character(lastWeek), min = "2023-06-01", end = as.character(today), max = as.character(today) )
  })

  output$graph <- renderPlotly( {
    req(input$name)
    if(is.null(input$dateRange)) {
      return(NULL)
    }
    
    start <- as.numeric(anytime(input$dateRange[1])) - 36000
    end <- as.numeric(anytime(input$dateRange[2])) - 36000

    cat("chosen Table",chosenTable()$variableId, "\n")
    data <- getDataRangeForDevice(chosenTable()$variableId, start, end)
    theTitle <- paste(input$name, chosenTable()$variableId, sep = "\n")
    datetime <- anytime(data$timestamp + 36000)

    p <- plot_ly(data, x = datetime, y = ~value,  type = "scatter", mode='lines', name="observed",
                 text = as.numeric(data$timestamp + 36000),
                 line=list(color="#ff7979", width = 4),showlegend = F) %>% 
      layout(xaxis=xaxis,yaxis=genericYAxis,margin=margin, hovermode = 'closest', title = theTitle)
  })

  output$downloadData <- downloadHandler (
    filename = paste(paste("PrivaData", as.character(Sys.time()), sep = "_"), "zip", sep= "."),
    content = function(file) {
      td <- tempdir()
      print(td)
      owd <- setwd(td)
      on.exit(setwd(owd))
      
      tables <- getTables()[,1]
      
      files <- vector()
      withProgress(message = 'Getting files', value = 0, {
        N <- length(tables)
        i <- 1
        for(tabName in tables) {
          csv <- paste(tabName, 'csv', sep = ".")
          
          sensorName <- getSensorName(tabName)
          
          if(input$allData) {
            tmp <- getAllDataForDevice(tabName)
          } else {
            #browser() 
            start <- as.numeric(anytime(input$dateRange[1])) - 36000
            end <- as.numeric(anytime(input$dateRange[2])) - 36000
            tmp <- getDataRangeForDevice(tabName, start, end)
          }
          
          AEST <- iso8601(anytime(tmp$timestamp + 36000))
          results <- cbind(tmp$timestamp, AEST, tmp$value)
          colnames(results) <- c("UnixTimestamp", "AEST", "Value")
          
          write.csv(results, file.path(td, 'tmp.csv'), row.names=F)
          
          csvFile <- file(file.path(td,'tmp.csv'), "r")
          theCSV <- readLines(csvFile)
          close(csvFile)
          
          csvFile <- file(csv, "w")
          write(sensorName, csv)
          close(csvFile)
          csvFile <- file(csv, "a")
          writeLines(theCSV, csvFile)
          close(csvFile)
          
          files <- c(files, csv)
          incProgress(1/N, detail = paste("Doing file", i, 'of', N))
          i <- i + 1
        }
      })
      withProgress(message = 'Zipping files', value = i, {
        zip(file, files)
        incProgress(N,"Done")
      })
    }
  )
  
}