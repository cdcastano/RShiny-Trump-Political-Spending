library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(shinydashboard)
library(googleVis)

#ui.R#
shinyUI(dashboardPage(
  dashboardHeader(title = "Payments by Year:"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "introtab", icon = icon("newspaper")),
      selectizeInput("spender", "Select Political Entity:", choices = spenders),
      selectizeInput("year1", "Select Year:", choices = 2015:2018),
      menuItem("WHO DID THEY PAY?", tabName = "whotab", icon = icon("user")),
      menuItem("WHAT DID THEY PAY FOR?", tabName = "whattab", icon = icon("money-bill-wave")),
      menuItem("WHERE DID THEY PAY?", tabName = "wheretab", icon = icon("map"))
      )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "introtab", h2("Political spending at Trump-owned Properties by Entity", align = 'center'), 
                                    h4("Coded by: Chris Castano (cdc67@georgetown.edu)", align = 'center'),
                                    img(src='http://static.digg.com/images/6a4a5c6a1f404b3da2141eaec0860206_9733b849c381477383942c1516d20f9d_header.jpeg', align = 'center', 
                                        height = 383, width = 1280),
                                    p(''),
                                    p('This app generates basic visualizations of state and 
                                      federal spending at Trump-owned properties in the United States. 
                                      Despite many past presidents doing their utmost to separate their 
                                      financial and political interests, the president continues to benefit from government 
                                      officials and organizations, both foreign and domestic, patronizing his businesses.'),
                                    p(''),
                                    p('The data used for this app is free to download from the ProPublica Data Store. 
                                      I do not own it. I have not modified its content significantly except to make visualization easier. 
                                      This version of the data was accessed April 12, 2019'),
                                    p(''),
                                    strong("ProPublica's notes:"),
                                    em("Please note: Federal government spending is incomplete because many government 
                                      agencies have actively fought requests to disclose spending at Trump properties. 
                                      The data we have so far was released, in part, after lawsuits. We'll continue to update 
                                      this page as we receive more data."),
                                    em("Federal Election Commission data is from April 30, 2015 through May 8, 2018; 
                                       Federal agency expenditure data from the Department of Commerce is from Jan. 15, 2017 
                                       through April 10, 2018; data from the Department of Defense is from Jan. 20, 2017 through 
                                       June 14, 2017; data from the Department of Homeland Security is from Jan. 20, 2017 through 
                                       Feb. 13, 2018; data from the General Services Administration is from Jan. 20, 2017 through 
                                       Nov. 20, 2017; data from the Department of State is from Jan. 20, 2017 through Aug. 2, 2017, 
                                       with three expenditures with unknown transaction dates; State and local government agency 
                                       expenditure data is from Jan. 20, 2017 through June 2018.")
              ),
      
      tabItem(tabName = "whotab", h3("What Trump-owned company was this entity paying?"), fluidRow(box(htmlOutput("whobar")))),
      tabItem(tabName = "whattab", h3("What types of services was this entity paying for?"), fluidRow(box(htmlOutput("whatbar")))),
      tabItem(tabName = "wheretab", h3("Where was this spender making this payment?"), fluidRow(box(htmlOutput("wherebar"))), fluidRow(box(htmlOutput("wheremap"))))
))))