
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

#    MEAN_FATALITIES<-aggregate(FATALITIES~EVTYPE,data=TOTAL_FATALITIES,FUN="mean")
#    MEAN_INJURIES<-aggregate(INJURIES~EVTYPE,data=TOTAL_INJURIES,FUN="mean")
#    
#    TOP10F<-MEAN_FATALITIES[order(-(MEAN_FATALITIES[,2])),][1:10,]
#    TOP10I<-MEAN_INJURIES[order(-(MEAN_INJURIES[,2])),][1:10,]
#    

#
#    MEAN_DAMAGES<-aggregate(TOTALDMG~EVTYPE,data=TOTAL_DAMAGES,FUN="mean")
#    TOP10D<-MEAN_DAMAGES[order(-(MEAN_DAMAGES[,2])),][1:10,]

library(shiny)
library(ggplot2)
library(googleVis)
library(grid)
library(gridExtra)


shinyServer(function(input, output) {
   
  TOTAL_DAMAGES<-read.table("total_damages")
  TOTAL_FATALITIES<-read.table("total_fatalities")
  TOTAL_INJURIES<-read.table("total_injuries")
  MEAN_FATALITIES<-aggregate(FATALITIES~EVTYPE,data=TOTAL_FATALITIES,FUN="mean")
  MEAN_INJURIES<-aggregate(INJURIES~EVTYPE,data=TOTAL_INJURIES,FUN="mean")
  MEAN_DAMAGES<-aggregate(TOTALDMG~EVTYPE,data=TOTAL_DAMAGES,FUN="mean")

myOptions <- reactive({
  list(
    page='enable',
    pageSize=input$pagesize,
    sortColumn=1,sortAscending=F
    )
  })
output$tableD <- renderGvis({
  gvisTable(MEAN_DAMAGES,options=myOptions(),formats=list(TOTALDMG="#,###.##"))
  })

output$tableH <- renderGvis({
  gvisTable(merge(MEAN_FATALITIES,MEAN_INJURIES),options=myOptions(),formats=list(INJURIES="#,###", FATALITIES="#,###"))
})


output$barPlot <- renderPlot({
    n=as.numeric(input$topfactors)
    TOP10D<-MEAN_DAMAGES[order(-(MEAN_DAMAGES[,2])),][1:n,]
    TOP10D$TOTALDMG<-as.numeric(TOP10D$TOTALDMG/1000000)
    qplot(data=TOP10D, x = reorder(EVTYPE,-TOTALDMG), y = TOTALDMG,geom="bar",
          stat="identity",fill=TOTALDMG,main ="Mean crop and property damages per year, mln $",
          xlab="Events",ylab="Total Damages, mil. USD")+theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })

output$barPlotH <- renderPlot({
  n=as.numeric(input$topfactors)
  TOP10F<-MEAN_FATALITIES[order(-(MEAN_FATALITIES[,2])),][1:n,]
  TOP10I<-MEAN_INJURIES[order(-(MEAN_INJURIES[,2])),][1:n,]
  plotF<-qplot(data=TOP10F, x = reorder(EVTYPE,-FATALITIES), y = FATALITIES,geom="bar",
        stat="identity",fill=FATALITIES,main ="Mean fatalities per year",
        xlab="Events",ylab="Fatalities")+theme(axis.text.x = element_text(angle = 90, hjust = 1))
  plotI<-qplot(data=TOP10I, x = reorder(EVTYPE,-INJURIES), y = INJURIES,geom="bar",
               stat="identity",fill=INJURIES,main ="Mean injuries per year",
               xlab="Events",ylab="Injuries")+theme(axis.text.x = element_text(angle = 90, hjust = 1))
  grid.arrange(plotF, plotI, ncol = 1, nrow=2, heights=c(1, 1))
  
})
#output$gvismotionD<-renderGvis({
#  n=as.numeric(input$topfactors)
#  TOPDNAMES<-MEAN_DAMAGES[order(-(MEAN_DAMAGES[,2])),][1:n,1]

#TOPD<-TOTAL_DAMAGES[TOTAL_DAMAGES$EVTYPE %in% TOPDNAMES,]
#gvisMotionChart(data=TOPD,idvar="EVTYPE",timevar="YEAR",date.format = "%Y")
#})
})
