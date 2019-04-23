library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(shinydashboard)
library(googleVis)
library(tidyr)

data = read.csv("./final_data.csv", stringsAsFactors = FALSE)

dagov = data %>% 
  group_by(Paying) %>% 
  summarise(total = sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(total)) %>% 
  top_n(15)
spenders = as.vector(dagov$Paying)