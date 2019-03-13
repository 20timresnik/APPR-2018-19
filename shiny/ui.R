library(shiny)

fluidPage(
  titlePanel(""),
  sidebarPanel(
    selectInput("id_poz", "Izberi dejavnost", choices = unique(bdp.slovenija$Dejavnosti))
  ),
  mainPanel(plotOutput("graf1"))
)
