#server.R#
shinyServer(function(input, output) {
  output$whobar = renderGvis({
   whobardata = data %>% 
      filter(Paying == input$spender, year == input$year1) %>% 
      group_by(Paid) %>% 
      summarise(TotalUSD = sum(amount, na.rm = TRUE)) %>% 
      filter(TotalUSD > 5000)
    gvisColumnChart(whobardata, options = list(legend = "none", vAxes="[{title:'Total Amount Paid (USD)'}]",
                            hAxes="[{title:'Organization Paid'}]", height = 500))
  })
  
  output$whatbar = renderGvis({
    whatbardata = data %>% 
      filter(Paying == input$spender, year == input$year1) %>% 
      group_by(purpose_scrubbed) %>% 
      summarise(TotalUSD = sum(amount, na.rm = TRUE))
    gvisColumnChart(whatbardata, options = list(legend = "none", vAxes="[{title:'Total Amount Paid (USD)'}]",
                                                hAxes="[{title:'Payment Category'}]", height = 500))
  })
  
  output$wherebar = renderGvis({
    wherebardata = data %>% 
      filter(Paying == input$spender, year == input$year1) %>% 
      group_by(state) %>% 
      summarise(TotalUSD = sum(amount, na.rm = TRUE))
      gvisColumnChart(wherebardata, options = list(title = 'State Totals', legend = "none", vAxes="[{title:'Total Amount Paid (USD)'}]",
                                                   hAxes="[{title:'U.S. State'}]", width = 800, height = 300))
  })

  output$googmap = renderGvis({
    googwheremapdata = data %>%
      filter(Paying == input$spender, year == input$year1) %>% 
      group_by(Paid) %>% 
      summarise(TotalUSD = sum(amount, na.rm = TRUE), llong = first(latlong.y)) %>% 
      mutate(finalStr = paste(Paid,as.character(TotalUSD), sep = ": $"))
    gvisMap(googwheremapdata, "llong" , "finalStr", 
            options=list(showTip=TRUE, 
                         enableScrollWheel=TRUE,
                         mapType='terrain', 
                         useMapTypeControl=TRUE, height = 300))
  })
})