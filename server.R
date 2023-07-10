#Priva Dashboard for Ayr

server <- function(input, output, session) {
  
  output$temp1 <- renderPlotly( {
    data <- getDataForDevice("80000005-0001-0001-0000-000080000bcc")
    datetime <- anytime(data$timestamp)
    p <- plot_ly(data, x = datetime, y = ~value,  type = "scatter", mode='lines', name="observed",
                 line=list(color="#ff7979", width = 4),showlegend = F) %>% 
      layout(xaxis=xaxis,yaxis=temperatureYAxis,margin=margin, hovermode = 'closest')
  })
  
  output$temp2 <- renderPlotly( {
    data <- getDataForDevice("80000005-0001-0002-0000-000080000bcc")
    datetime <- anytime(data$timestamp)
    p <- plot_ly(data, x = datetime, y = ~value,  type = "scatter", mode='lines', name="observed",
                 line=list(color="#ff7979", width = 4),showlegend = F) %>% 
    layout(xaxis=xaxis,yaxis=temperatureYAxis,margin=margin, hovermode = 'closest')
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
        
        AEST <- as.character(anytime(tmp$timestamp))
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
        print(csv)
      }
      zip(file, files)
    }
  )
  
}