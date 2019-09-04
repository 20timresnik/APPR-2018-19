library(shiny)

function(input, output) 
  {
# output$graf1 <- renderPlot({
#     ggplot(bdp.slovenija %>% filter(Dejavnosti == input$id_poz), aes(x = Leto, y = BDP)) + 
#      geom_area()+
#      labs(title = "Vrednost komponente BDP-ja skozi leta") + theme(plot.title = element_text(hjust = 0.5)) +
#      ylab("Leto") + xlab("Vrednost")
#  })

  output$zemljevid1 <- renderPlot({
    ggplot() +
      geom_polygon(data=left_join(evropa, bdp.evropa %>% filter(Leto == input$letnica), by=c("NAME"="Drzava")),
                                    aes(x=long, y=lat, group=group, fill=BDP),alpha = 0.8, color = "black") + 
                     coord_cartesian(xlim=c(-25, 40), ylim=c(35, 72)) +
                     scale_fill_gradient2(low ="yellow", mid = "orange", high = "red", na.value = "white")+
                     xlab("") + ylab("") + ggtitle("BDP po državah") +
                     theme(plot.title = element_text(hjust = 0.5)) 
    
    
    
    
  })
  
  }

