library(dplyr)
library(tidyr)
library(rgdal)
library(rgeos)
library(mosaic)
library(maptools)
library(reshape2)
library(ggplot2)


# 3. faza: Vizualizacija podatkov

bdp.evropa <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Leto) %>% 
  summarise(BDP=sum(`Vrednost`, na.rm=TRUE)) %>% inner_join(populacija.evropa, by = "Drzava")

bdp.kvartali <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Leto, Kvartal) %>%
  summarise(BDP=sum(Vrednost, na.rm =TRUE))

bdp.kvartali.slovenija <- podatki.slovenija %>% drop_na(4) %>% group_by(Dejavnosti, Leto) %>%
  summarise(BDP=sum(Vrednost, na.rm = TRUE))

bdp.kvartali.evropa <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Dejavnost, Leto) %>%
  summarise(BDP=sum(Vrednost, na.rm =TRUE))

bdp.kvartali.evropa.skupaj <- podatki.evropa %>% drop_na(5) %>% 
  group_by(Dejavnost, Leto) %>% summarise(BDP=sum(Vrednost, na.rm = TRUE))

bdp.evropa.2017 <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Leto) %>% 
  summarise(BDP=sum(`Vrednost`, na.rm=TRUE)) %>% filter(Leto == 2017) %>% inner_join(populacija.evropa, by = "Drzava")

bdp.evropa.2017$BDP <- (bdp.evropa.2017$BDP/bdp.evropa.2017$Vrednost)*1e6
bdp.evropa.2017$Leto <- NULL
bdp.evropa.2017$Vrednost <- NULL


graf1 <- ggplot(bdp.evropa %>%
                  filter(Drzava %in% c('Germany (until 1990 former territory of the FRG)',
                                       'Greece', 'Slovenia', 'Czechia'),
                         Leto %in% 2000:2017), aes(x=Leto, y=BDP*1e6/Vrednost, fill=Drzava)) +
  geom_col(position="dodge") + xlab("Leto") + ylab("BDP na prebivalca") +
  ggtitle("Primerjava štirih držav") + theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5)) +
  scale_fill_manual(values=c("Black","Blue","Red","Green"),name = "Država", breaks = c("Germany (until 1990 former territory of the FRG)","Greece","Slovenia","Czechia"), 
                      labels = c("Nemčija","Grčija","Slovenija","Češka"))

#print(graf1)

graf2 <- ggplot(bdp.kvartali.slovenija %>% ungroup() %>%
                  filter(Leto == 1995,
                         Dejavnosti %in% c('A Kmetijstvo, lov, gozdarstvo, ribištvo',
                                           'BCDE Rudarstvo, predelovalne dejavnosti, oskrba z elektriko in vodo, ravnanje z odplakami, saniranje okolja',
                                           'J Informacijske in komunikacijske dejavnosti',
                                           'F Gradbeništvo',
                                           'K Finančne in zavarovalniške dejavnosti')) %>%
                  transmute(Dejavnosti, zacetniBDP=BDP) %>%
                  inner_join(bdp.kvartali.slovenija) %>% filter(Leto != 2018),
                aes(x=Leto, y=BDP/zacetniBDP, color=Dejavnosti)) +
  geom_line(size = 2) + xlab("Leto") + ylab("Rast/padanje") +
  scale_color_discrete(name = "Dejavnost", breaks = c("A Kmetijstvo, lov, gozdarstvo, ribištvo",
                                 "BCDE Rudarstvo, predelovalne dejavnosti, oskrba z elektriko in vodo, ravnanje z odplakami, saniranje okolja",
                                 "J Informacijske in komunikacijske dejavnosti",
                                 "F Gradbeništvo",
                                 "K Finančne in zavarovalniške dejavnosti"),labels = c("A","BCDE","J","F","K"))+
  ggtitle("Spreminjanje nominalnega deleža dejavnosti A, BCDE, F, J in K")+
  theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5))
  

#print(graf2)


#Naraščanje izstopajočih deležev v skupnem evropskem BDP
graf3 <- ggplot(bdp.kvartali.evropa.skupaj %>% ungroup()%>% 
                  filter(Leto == 1995,
                         Dejavnost %in% c('Agriculture, forestry and fishing',
                                          'Industry (except construction)',
                                          'Information and communication',
                                          'Construction',
                                          'Financial and insurance activities')) %>%
                  transmute(Dejavnost, zacetniBDP=BDP) %>%
                  inner_join(bdp.kvartali.evropa.skupaj) %>% filter(Leto != 2018),
                aes(x=Leto,y=BDP/zacetniBDP,color=Dejavnost)) +
  geom_line(size = 2) +
  scale_color_discrete(name = "Dejavnost", breaks = c("Agriculture, forestry and fishing",
                                                      "Industry (except construction)",
                                                      "Information and communication",
                                                      "Construction",
                                                      "Financial and insurance activities"),labels = c("A","BCDE","J","F","K"))+
  ylab("Rast/padanje") + ggtitle("Spreminjanje nominalnega deleža dejavnosti A, BCDE, F, J in K")
  

#print(graf3)

#Zemljevid

source("https://raw.githubusercontent.com/jaanos/APPR-2018-19/master/lib/uvozi.zemljevid.r")

zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", mapa = "zemljevidi", pot.zemljevida = "", encoding = "UTF-8") %>% fortify()

