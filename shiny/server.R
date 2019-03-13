library(shiny)

function(input, output) {
  output$graf1 <- renderPlot({
      ggplot(bdp.slovenija %>% filter(Dejavnosti == input$id_poz), aes(x = Leto, y = BDP)) + 
      geom_line(size = 1.2, col = "blue")+
      labs(title = "Vrednost komponente BDP-ja skozi leta") + theme(plot.title = element_text(hjust = 0.5)) +
      ylab("Leto") + xlab("Vrednost")
  })

  }

