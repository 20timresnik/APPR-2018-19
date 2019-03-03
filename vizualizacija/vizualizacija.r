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
  summarise(BDP=sum(`Vrednost`, na.rm=TRUE))

bdp.kvartali <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Leto, Kvartal) %>%
  summarise(BDP=sum(Vrednost, na.rm =TRUE))

bdp.kvartali.slovenija <- podatki.slovenija %>% drop_na(4) %>% group_by(Dejavnosti, Leto) %>%
  summarise(BDP=sum(Vrednost, na.rm = TRUE))

bdp.kvartali.evropa <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Dejavnost, Leto) %>%
  summarise(BDP=sum(Vrednost, na.rm =TRUE))

# Graf nemškega, španskega, grškega, slovenskega in češkega BDP na prebivalca
graf1 <- ggplot(bdp.evropa,aes(x=Leto, y= BDP)) +
  geom_bar(data = bdp.evropa %>% filter(Drzava == 'Germany (until 1990 former territory of the FRG)', Leto != 2018, Leto != 1995), aes(x=Leto, y=BDP/83),stat = "identity",position = position_dodge(),width = 0.5)+
  geom_bar(data = bdp.evropa %>% filter(Drzava == 'Spain', Leto != 2018, Leto != 1995), aes(x=Leto, y=BDP/46.7),stat = "identity",fill = "grey",position = position_dodge(),width = 0.5)+
  geom_bar(data = bdp.evropa %>% filter(Drzava == 'Greece', Leto != 2018, Leto != 1995),aes(x=Leto, y=BDP/10.7),stat = "identity", fill = "red",position = position_dodge(),width = 0.5)+
  geom_bar(data = bdp.evropa %>% filter(Drzava == 'Slovenia', Leto != 2018, Leto != 1995), aes(x=Leto, y=BDP/2),stat = "identity",fill = "blue",position = position_dodge(),width = 0.5)+
  geom_bar(data = bdp.evropa %>% filter(Drzava == 'Czechia', Leto != 2018), aes(x=Leto, y=BDP/10),stat = "identity",fill = "green",position = position_dodge(),width = 0.5)+
  xlab("Leto") + ylab("Vrednost BDP na prebivalca v €") + ggtitle("Primerjava petih držav")+
  theme(axis.title = element_text(size = 11), plot.title = element_text(size = 15, hjust = 0.5))

#print(graf1)

# Naraščanje nekaterih deležev v slovenskem BDP
graf2 <- ggplot(bdp.kvartali.slovenija, aes(x=Leto,y=BDP))+
  geom_line(data = bdp.kvartali.slovenija %>% filter(Dejavnosti == 'A Kmetijstvo, lov, gozdarstvo, ribištvo', Leto != 2018),aes(x=Leto, y=BDP*4557/606), color ="green",size = 2)+
  geom_line(data = bdp.kvartali.slovenija %>% filter(Dejavnosti == 'BCDE Rudarstvo, predelovalne dejavnosti, oskrba z elektriko in vodo, ravnanje z odplakami, saniranje okolja', Leto != 2018), color = "grey",size = 2)+
  geom_line(data = bdp.kvartali.slovenija %>% filter(Dejavnosti == 'J Informacijske in komunikacijske dejavnosti', Leto != 2018),aes(x=Leto, y=BDP*4557/448), color = "blue",size = 2)+
  geom_line(data = bdp.kvartali.slovenija %>% filter(Dejavnosti == 'F Gradbeništvo', Leto != 2018),aes(x=Leto, y=BDP*4557/1369), color="brown",size = 2)+
  geom_line(data = bdp.kvartali.slovenija %>% filter(Dejavnosti == 'K Finančne in zavarovalniške dejavnosti', Leto != 2018),aes(x=Leto, y=BDP*4557/644),color ="red",size = 2)+
  xlab("Leto") + ylab("Rast/padanje") + ggtitle("Spreminjanje nominalnega deleža dejavnosti A, BCDE, F, J in K")

print(graf2)


graf3 <- ggplot(bdp.kvartali.evropa) + aes(x=Leto, y=BDP)+
  geom_line(data = bdp.kvartali.evropa %>% filter(Drzava == 'Spain', Leto != 2018, Leto != 1995, Dejavnost == 'Industry (except construction)'))


#print(graf3)








# Uvozimo zemljevid.
#zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
#                             pot.zemljevida="OB", encoding="Windows-1250")
#levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
#zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
#zemljevid <- fortify(zemljevid)
#
# Izračunamo povprečno velikost družine
#povprecja <- druzine %>% group_by(obcina) %>%
#  summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
