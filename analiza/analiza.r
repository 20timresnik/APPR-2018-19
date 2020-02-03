library(dplyr)
library(tidyr)
library(rgdal)
library(rgeos)
library(mosaic)
library(maptools)
library(reshape2)
library(ggplot2)


# 4. faza: Analiza podatkov


#Izračun podatkov za napoved
podatki.napoved <- bdp.evropa %>% filter(Drzava == 'Slovenia', Leto %in% 1995:2017) %>%
  transmute(Leto, BDP=BDP*1e6/Vrednost)
fit <- lm(data = podatki.napoved, BDP ~ Leto)
a <- data.frame(Leto=seq(2018, 2025))
predict(fit, a)
napoved <- a %>% mutate(BDP=predict(fit, .))


#Graf napovedi
graf9 <- ggplot(podatki.napoved, aes(x=Leto, y=BDP)) +
  theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5)) +
  geom_col(data=napoved, aes(x=Leto, y=BDP), fill="grey43", alpha=0.6, width = 0.6, colour="grey0") +
  labs(title="Napoved BDP Slovenija", y="BDP/prebivalca") +
  geom_col(fill="springgreen4", width = 0.6, colour="grey0") +
  geom_smooth(method=lm, colour = "red", linetype = "11", size=2, fullrange = TRUE, se=FALSE)

