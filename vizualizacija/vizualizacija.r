library(dplyr)
library(tidyr)
library(ggplot2)

# 3. faza: Vizualizacija podatkov

bdp.evropa <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Leto) %>% 
  summarise(BDP=sum(`Vrednost`, na.rm=TRUE))

#bdp.kvartali <- podatki.evropa %>% drop_na(5) %>% group_by(Drzava, Leto, Kvartal) %>%
#  summarise(BDP=sum('Vrednost', na.rm =TRUE))

#bdp.kvartali <- podatki.slovenija %>% drop_na(4) %>% group_by(Dejavnosti, Leto) %>%
#  summarise(BDP=mean(''))

# Graf slovenskega BDP

slovenia <- bdp.evropa %>% filter(Drzava == 'Slovenia', Leto != 2018)
slovenia <- as.data.frame(slovenia)

sl <- ggplot(slovenia) + aes(x=slovenia[,2],y=slovenia[,3]) + geom_point()
sl <- sl + xlab("Leto") + ylab("Vrednost") + ggtitle("Slovenski BDP")
  
germany <- bdp.evropa %>% filter(Drzava == 'Germany (until 1990 former territory of the FRG)', Leto != 2018)
germany <- as.data.frame(germany)

ger <- ggplot(germany) + aes(x=germany[,2], y=germany[,3]) + geom_line()













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
