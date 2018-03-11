library(leaflet)
library(leaflet.extras)
library(rdrop2)
library(spatstat)

#Sources:
#https://rstudio.github.io/leaflet/shiny.html
#https://rpubs.com/bhaskarvk/leaflet-heat

Crime.Type = c("Other theft","Vehicle crime","Burglary","Violence and sexual offences","Anti-social behaviour","Public order","Shoplifting","Other crime","Criminal damage and arson","Possession of weapons","Bicycle theft","Drugs","Robbery","Theft from the person")


shinyUI(bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("mymap", width = "100%", height = "100%"),
  
  absolutePanel(bottom=10, left=10,
                textOutput("Pvalue"),
                plotOutput("Kest", height = 300, width=400)
  ),
  
  absolutePanel(top = 10, right = 10,
                sliderInput("Year", label="Dates Available from 2010-12 to 2018-01:", 2010, 2018, value=2018, step=1, sep=""),
                sliderInput("Month", "Month:", 1, 12, value=1, step=1),
                selectInput("Crimes", "Crime Type:", c(Crime.Type)),
                actionButton("Start", "Draw Map")
  )
))
