#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  output$PlatHeight=renderPlot({
    boxplot(Newpoc$DIM_TRAVEL_HEIGHT_H~Newpoc$PLATFORM,col=c("red","blue","green"))
  })
  ########### Tab 2 starts Here
  
  
  output$barcht<-renderPlotly({
    cols=Newpoc$PLATFORM[1]
    if (!is.null(input$SelPlatform)){
      cols=input$SelPlatform
    }
    SubPoc=subset(Newpoc,Newpoc$PLATFORM %in% cols)
    qplot(DIM_CAR_SHELL_WIDTH_BB, DIM_CAR_SHELL_DEPTH_DD, data=SubPoc, colour=PLATFORM)
  })
  output$CarStats = renderPrint({summary(Newpoc$DIM_CAR_SHELL_WIDTH_BB,Newpoc$DIM_CAR_SHELL_DEPTH_DD)})
  output$barcht1<-renderPlotly({
    cols=Newpoc$PLATFORM[1]
    if (!is.null(input$SelPlatform)){
      cols=input$SelPlatform
    }
    SubPoc=subset(Newpoc,Newpoc$PLATFORM %in% cols)
    qplot(DIM_SHAFT_WIDTH_WW, DIM_SHAFT_DEPTH_WD, data=SubPoc, colour=PLATFORM)
  })
  output$ShaftStats = renderPrint({summary(Newpoc$DIM_SHAFT_WIDTH_WW,Newpoc$DIM_SHAFT_DEPTH_WD)})
  ############ Tab 3 stats here
  output$mapKONE = renderLeaflet({
    #require(leaflet)
    Newpoc_sub=subset(Newpoc,!is.na(lat))
    m=leaflet(Newpoc_sub) %>% addTiles() %>%
      #setView(lng=mean(x$lon),lat=mean(x$lat), zoom=3)%>%
addCircleMarkers(data=Newpoc_sub,lng=~lon,lat=~lat,radius=5,clusterOptions=markerClusterOptions())
      #addCircles(popup= ~PLATFORM, radius=~(DIM_TRAVEL_HEIGHT_H/1000))
      print(m)
  })
  ###############Tab 4 starts here
  output$mytable = renderDataTable({
    #columns = names(Newpoc)
    columns=c("PLATFORM","TYP_HL_PREPACK")
    if (!is.null(input$select)) {
      columns = input$select
    }
    #####Option 1
    #datatable(Newpoc[,columns,drop=FALSE], filter="top",options = list(lengthChange = FALSE),callback=JS("
    #                                                                               //hide column filters for the first two columns
    #                                                                              $.each([0, 1], function(i, v) {
    #                                                                              $('input.form-control').eq(v).hide()
    #                                                                              });"))
    ##### Option 1 ends
    datatable(Newpoc[,columns,drop=FALSE],filter="top")
  })
  
  
  
  
})
