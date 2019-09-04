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

bdp.slovenija <- podatki.slovenija %>% drop_na(4) %>% group_by(Dejavnosti, Leto) %>%
  summarise(BDP=sum(Vrednost, na.rm = TRUE))

bdp.kvartali.evropa <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Dejavnost, Leto) %>%
  summarise(BDP=sum(Vrednost, na.rm =TRUE))

bdp.kvartali.evropa.skupaj <- podatki.evropa %>% drop_na(5) %>% 
  group_by(Dejavnost, Leto) %>% summarise(BDP=sum(Vrednost, na.rm = TRUE))

bdp.evropa.2017 <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Leto) %>% 
  summarise(BDP=sum(`Vrednost`, na.rm=TRUE)) %>% filter(Leto == 2017) %>% inner_join(populacija.evropa, by = "Drzava")

bdp.evropa.2017$Drzava <- gsub("Germany (until 1990 former territory of the FRG)","Germany",bdp.evropa.2017$Drzava, fixed = TRUE)

bdp.evropa$Drzava <- gsub("Germany (until 1990 former territory of the FRG)","Germany",bdp.evropa$Drzava, fixed = TRUE)

bdp.evropa.2017$BDP <- (bdp.evropa.2017$BDP/bdp.evropa.2017$Vrednost)*1e6
bdp.evropa.2017$Leto <- NULL
bdp.evropa.2017$Vrednost <- NULL

bdp.kvartali.slovenija <- podatki.slovenija %>% drop_na(4) %>% group_by(Dejavnosti,Leto, Kvartal) %>%
  summarise(BDP=sum(Vrednost, na.rm = TRUE))


graf1 <- ggplot(bdp.evropa %>%
                  filter(Drzava %in% c('Germany',
                                       'Greece', 'Slovenia'),
                         Leto %in% 1995:2017), aes(x=Leto, y=BDP*1e6/Vrednost, fill=Drzava)) +
  geom_col(position="dodge") + xlab("Leto") + ylab("BDP na prebivalca") +
  ggtitle("Primerjava treh evropskih držav") + theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5)) +
  scale_fill_manual(values=c("Blue","Red","Dark Green"),name = "Država", breaks = c("Germany","Greece","Slovenia"), 
                      labels = c("Nemčija","Grčija","Slovenija"))

#print(graf1)

graf2 <- ggplot(bdp.slovenija %>% ungroup() %>%
                  filter(Leto == 1995,
                         Dejavnosti %in% c('A Kmetijstvo, lov, gozdarstvo, ribištvo',
                                           'BCDE Rudarstvo, predelovalne dejavnosti, oskrba z elektriko in vodo, ravnanje z odplakami, saniranje okolja',
                                           'F Gradbeništvo',
                                           'J Informacijske in komunikacijske dejavnosti',
                                           'K Finančne in zavarovalniške dejavnosti')) %>%
                  transmute(Dejavnosti, zacetniBDP=BDP) %>%
                  inner_join(bdp.slovenija) %>% filter(Leto != 2018),
                aes(x=Leto, y=BDP/zacetniBDP, color=Dejavnosti)) +
  geom_line(size = 1.5) + xlab("Leto") + ylab("Rast/padanje") +
  scale_color_manual(values=c("Green", "Black", "Gray", "Blue", "Red") ,name = "Dejavnost", breaks = c("A Kmetijstvo, lov, gozdarstvo, ribištvo",
                                 "BCDE Rudarstvo, predelovalne dejavnosti, oskrba z elektriko in vodo, ravnanje z odplakami, saniranje okolja",
                                 "F Gradbeništvo",
                                 "J Informacijske in komunikacijske dejavnosti",
                                 "K Finančne in zavarovalniške dejavnosti"),labels = c("A","BCDE","F","J","K"))+
  ggtitle("Spreminjanje vrednosti različnih dejavnosti v SLO")+
  theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5))+
  theme_light()
  

#print(graf2)


#Naraščanje izstopajočih deležev v skupnem evropskem BDP
graf3 <- ggplot(bdp.kvartali.evropa.skupaj %>% ungroup()%>% 
                  filter(Leto == 1995,
                         Dejavnost %in% c('Agriculture, forestry and fishing',
                                          'Industry (except construction)',
                                          'Construction',
                                          'Information and communication',
                                          'Financial and insurance activities')) %>%
                  transmute(Dejavnost, zacetniBDP=BDP) %>%
                  inner_join(bdp.kvartali.evropa.skupaj) %>% filter(Leto != 2018),
                aes(x=Leto,y=BDP/zacetniBDP,color=Dejavnost)) +
  geom_line(size = 2) +
  scale_color_manual(values=c("Green", "Black", "Gray", "Blue", "Red"), name = "Dejavnost", breaks = c("Agriculture, forestry and fishing",
                                                      "Industry (except construction)",
                                                      "Construction",
                                                      "Information and communication",
                                                      "Financial and insurance activities"),labels = c("A","BCDE","F","J","K"))+
  ylab("Rast/padanje") + ggtitle("Spreminjanje vrednosti različnih dejavnosti v EU")+
  theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5))+
  theme_light()
  

#print(graf3)

#Razlika po kvartalih v Sloveniji

naslovi <- c('A Kmetijstvo, lov, gozdarstvo, ribištvo' = "Kmetijstvo, lov, gozdarstvo, ribištvo",
             'BCDE Rudarstvo, predelovalne dejavnosti, oskrba z elektriko in vodo, ravnanje z odplakami, saniranje okolja' = "Predelovalne dejavnosti",
             'F Gradbeništvo' = "Gradbeništvo",
             'K Finančne in zavarovalniške dejavnosti' = "Finančne in zavarovalniške dejavnosti")

graf4 <- ggplot(bdp.kvartali.slovenija %>% 
                  filter(Dejavnosti %in% c('A Kmetijstvo, lov, gozdarstvo, ribištvo',
                                           'BCDE Rudarstvo, predelovalne dejavnosti, oskrba z elektriko in vodo, ravnanje z odplakami, saniranje okolja',
                                           'F Gradbeništvo',
                                           'K Finančne in zavarovalniške dejavnosti'), 
                         Leto != 2018),
                aes(x = Leto, y = BDP, color=factor(Kvartal))) + 
  facet_wrap( ~ Dejavnosti, ncol = 2,
              labeller = labeller(Dejavnosti = naslovi), 
              scales = "free_y") +
  geom_point(size=2, shape = 10) + 
  labs(x="Leto",y="BDP v mio €", title = "Primerjava po kvartalih v SLO")+
  scale_color_manual(name = "Kvartal",values=c("Blue","Green","Red", "Brown"))+
  theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5))
  

#print(graf4)

graf6 <- ggplot(bdp.evropa %>% ungroup()%>% 
                  filter(Leto == 1996) %>%
                  transmute(Drzava, zacetniBDP=BDP) %>%
                  inner_join(bdp.evropa) %>% filter(Leto != 2018, Leto != 1995,
                                                    Drzava %in% c('Estonia',
                                                                  'Lithuania',
                                                                  'Slovenia',
                                                                  'Germany',
                                                                  'Greece',
                                                                  'Ireland',
                                                                  'France')),
                aes(x=Leto,y=BDP/zacetniBDP,color=Drzava))+
  geom_line(size = 2) + labs(x= "Leto", y = "Faktor rasti", title = "Rast BDP-jev nekaterih držav EU")+
  theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5))+
  scale_colour_discrete(name="Država",
                        breaks=c("Estonia",
                                 "Lithuania",
                                 "Slovenia",
                                 "Germany",
                                 "Greece",
                                 "Ireland",
                                 "France"),
                        labels=c("Estonija", 
                                 "Litva", 
                                 "Slovenija",
                                 "Nemčija",
                                 "Grčija",
                                 "Irska",
                                 "Francija")
                      )

#print(graf6)

naslovi2 <- c('Agriculture, forestry and fishing' = "Kmetijstvo, lov, gozdarstvo, ribištvo",
             'Industry (except construction)' = "Predelovalne dejavnosti",
             'Construction' = "Gradbeništvo",
             'Financial and insurance activities' = "Finančne in zavarovalniške dejavnosti")

graf7 <- ggplot(podatki.evropa %>% 
                  filter(Dejavnost %in% c('Agriculture, forestry and fishing',
                                           'Industry (except construction)',
                                           'Construction',
                                           'Financial and insurance activities'), 
                         Leto != 2018,
                         Drzava == 'Germany (until 1990 former territory of the FRG)'),
                aes(x = Leto, y = Vrednost, color=factor(Kvartal))) + 
  facet_wrap( ~ Dejavnost, ncol = 2,
              labeller = labeller(Dejavnost = naslovi2), 
              scales = "free_y") +
  geom_point(size=2, shape = 8) + 
  labs(x="Leto",y="BDP v mio €", title = "Primerjava po kvartalih v GER")+
  scale_color_manual(name = "Kvartal",values=c("Blue","Green","Red", "Brown"))+
  theme(axis.title=element_text(size=11), plot.title=element_text(size=15, hjust=0.5))


#Zemljevid

source("https://raw.githubusercontent.com/jaanos/APPR-2018-19/master/lib/uvozi.zemljevid.r")

zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", mapa = "zemljevidi", pot.zemljevida = "", encoding = "UTF-8") %>% fortify()

evropa <- zemljevid %>% filter(CONTINENT == "Europe" | NAME %in% c("Turkey", "Cypru"))

bdp.evropa.2017 <- bdp.evropa.2017 %>% filter(Drzava != "Luxembourg")

zemljevid.bdp.evropa <- ggplot() + geom_polygon(data=evropa %>% left_join(bdp.evropa.2017, by=c("NAME"="Drzava")),
                        aes(x=long, y=lat, group=group, fill=BDP),alpha = 0.8, color = "black") + 
  coord_cartesian(xlim=c(-25, 40), ylim=c(35, 72)) +
  scale_fill_gradient2(low ="yellow", mid = "orange", high = "red",midpoint = 30000, na.value = "white")+
  xlab("") + ylab("") + ggtitle("BDP po državah evrope") +
  theme(plot.title = element_text(hjust = 0.5))

#print(zemljevid.bdp.evropa)
