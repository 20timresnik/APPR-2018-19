library(shiny)

#Shiny zemljevid BDP-ja po državah Evrope

fluidPage(
  tabPanel("Zemljevid",
           sidebarPanel(
             selectInput("letnica", label = "Leto", 
                         choices = unique(bdp.evropa.brez$Leto))),
           mainPanel(plotOutput("zemljevid1")))
)
