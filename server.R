library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(shinydashboard)
library(googleVis)

data2 = read.csv("propub_clean", stringsAsFactors = FALSE)

#server.R#
shinyServer(function(input, output) {
  output$whobar = renderGvis({
   whobardata = data2 %>% 
      filter(Paying == input$spender, year == input$year1) %>% 
      group_by(Paid) %>% 
      summarise(total = sum(amount, na.rm = TRUE)) %>% 
      filter(total > 5000)
    gvisColumnChart(whobardata, options = list(vAxes="[{viewWindowMode:'explicit',
			viewWindow:{min:0, max:400000}}]"))
  })
  
  output$whatbar = renderGvis({
    whatbardata = data2 %>% 
      filter(Paying == input$spender, year == input$year1) %>% 
      group_by(purpose_scrubbed) %>% 
      summarise(total = sum(amount, na.rm = TRUE))
    gvisColumnChart(whatbardata, options = list(vAxes="[{viewWindowMode:'explicit',
			viewWindow:{min:0, max:400000}}]"))
  })
  
  #output$wherebar = renderGvis({
   # wherebardata = data2 %>% 
    #  filter(Paying == input$spender, year == input$year1) %>% 
     # group_by(state) %>% 
      #summarise(total = sum(amount, na.rm = TRUE))
  #  gvisColumnChart(wherebardata, options = list(vAxes="[{viewWindowMode:'explicit',
		#	viewWindow:{min:0, max:400000}}]"))
  #})

  #output$wheremap = renderGvis({
   # wherebarmapdata = data2 %>% 
    #  filter(Paying == input$spender, year == input$year1) %>% 
     # group_by(state) %>% 
    #  summarise(total = sum(amount, na.rm = TRUE))
    #gvisGeoChart(wherebarmapdata, "state", "total", options=list(region="US", 
     #                                                       displayMode="regions", 
      #                                                      resolution="provinces"))
  #})
  
  output$googmap = renderGvis({
    googwheremapdata = data3 %>%
      filter(Paying == input$spender, year == input$year1) %>% 
      group_by(Paid) %>% 
      summarise(total = sum(amount, na.rm = TRUE), llong = first(latlong.y))
    gvisMap(googwheremapdata, "llong" , "total", 
            options=list(showTip=TRUE, 
                         showLine=TRUE, 
                         enableScrollWheel=TRUE,
                         mapType='terrain', 
                         useMapTypeControl=TRUE))
  })
})



