#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(plotly)
library(dplyr)
library(xlsx)
library(shinythemes)
library(ggplot2)
#library(dtplyr)
library(DT)
library(data.table)

myvar=0
if (myvar==1){
  setwd("F:/edX/AnalyticsEdge")
  Newpoc=fread("filterWk29.csv",stringsAsFactors = FALSE)
  Newpoc=data.frame(Newpoc)
  Newpoc$V1=NULL
  CountryList=fread("CountryList.csv",stringsAsFactors = FALSE, header=TRUE)
  CountryList=data.frame(CountryList)
  newdf=left_join(Newpoc,CountryList,by=c("DESTINATION_COUNTRY"="Code"))
  unique(Newpoc$PLATFORM)
  deliveredCountry=unique(Newpoc$Name)
  deliveredCountry=deliveredCountry[!is.na(deliveredCountry)]
  Dcountry=data.frame(deliveredCountry,stringsAsFactors = FALSE)
  Dcountry=cbind(Dcountry, t(sapply(Dcountry$deliveredCountry,geocode, USE.NAMES=F)))
  newdf=left_join(Newpoc,Dcountry,by=c("Name"="deliveredCountry"))
  Newpoc=newdf
  x=head(select(Newpoc,PLATFORM,lat,lon))
  Newpoc$PLATFORM <- gsub("R1", "1", Newpoc$PLATFORM)
  Newpoc$PLATFORM <- gsub("R2", "2", Newpoc$PLATFORM)
  Newpoc$PLATFORM <- gsub("Ã", "", Newpoc$PLATFORM)
  Newpoc$PLATFORM <- gsub("Â", "", Newpoc$PLATFORM)
  Newpoc$PLATFORM <- gsub(",", "", Newpoc$PLATFORM)
}
# Define UI local variables
vars = c(names(Newpoc))
PlatVar=unique(Newpoc$PLATFORM)
x= data.frame(lon = c(24.829377,80.152555,80.162762),
              lat = c(60.172232,13.073828,13.092347),
              label=c("KONE HQ", "KONE Factory", "KONE ITEC"),
              color=c("red","blue","black"))

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("cerulean"),
                  title = "Tendering Analytics",
                  tabsetPanel(
                    tabPanel(title = "Index",
                             "Description of tool here"
                    ),
                    tabPanel(title = "BoxPlot",
                             plotOutput("PlatHeight")
                    ),
                    tabPanel(title = "Charts View",
                    fluidRow(
                      column(3,
                              selectInput(inputId = "SelPlatform","Choose Platforms",PlatVar,multiple = TRUE) 
                              )
                            ),
                             
                             # selectInput(inputId = "Chars","Choose CHARS",vars,multiple = TRUE),
                             plotlyOutput("barcht"),
                             verbatimTextOutput("CarStats"),
                             plotlyOutput("barcht1"),
                             verbatimTextOutput("ShaftStats")
                    ),
                    tabPanel(title = "Map Interactive",
                             leafletOutput("mapKONE")
                    ),
                    tabPanel(title = "Search Tender",
                             fluidRow(
                               column(2),
                               column(3,
                                       selectInput(inputId = "select","Choose CHARS",vars,multiple = TRUE)
                               )
                             ),
                            dataTableOutput("mytable")
                    )
                  )
  

 ))
