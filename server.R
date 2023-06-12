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
}