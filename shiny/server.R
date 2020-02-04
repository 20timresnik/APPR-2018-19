library(shiny)
library(dplyr)
library(ggplot2)



function(input, output) 
  {
 
  output$zemljevid1 <- renderPlot({
    ggplot() +
      geom_polygon(data=left_join(evropa, bdp.evropa.brez %>% filter(Leto == input$letnica), by=c("NAME"="Drzava")),
                                    aes(x=long, y=lat, group=group, fill=BDPPP), color = "black") + 
                     coord_cartesian(xlim=c(-25, 40), ylim=c(35, 72)) +
                     scale_fill_gradient2(low ="yellow", mid = "orange", high = "darkred", 
                                          na.value = "white", name="Vrednost na prebivalca",
                                          guide = "legend",
                                          midpoint=30000) +
                     xlab("") + ylab("") + ggtitle("BDP Evropa") +
                     theme(plot.title = element_text(hjust = 0.5))
    
  })
  
  }

