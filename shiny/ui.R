library(shiny)

fluidPage(
  #titlePanel(""),
  #sidebarPanel(
  #  selectInput("id_poz", "Izberi dejavnost", choices = unique(bdp.slovenija$Dejavnosti))
  #),
  #mainPanel(plotOutput("graf1")),
  
  tabPanel("Zemljevid",
           sidebarPanel(
             selectInput("letnica", label = "Leto", 
                         choices = unique(bdp.evropa$Leto))),
           mainPanel(plotOutput("zemljevid1")))
)
