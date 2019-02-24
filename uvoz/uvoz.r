library(readr)
library(reshape2)
library(dplyr)

podatki.slovenija <- read_delim("PodatkiSlovenija.csv",
                                ";",
                                col_names=TRUE,
                                skip=4,
                                na="-",
                                n_max = 11,
                                locale=locale(encoding="Windows-1250", decimal_mark="."))
colnames(podatki.slovenija)[1] <- "Dejavnosti"

podatki.slovenija <- melt(podatki.slovenija, id.vars="Dejavnosti", measure.vars=names(podatki.slovenija)[-1],
                          variable.name="Leto",value.name="Stalne cene, referenčno leto 2010, v mio €", na.rm=TRUE)

podatki.slovenija$Kvartal <- substr(podatki.slovenija$Leto,nchar(as.character(podatki.slovenija$Leto))-2+1,nchar(as.character(podatki.slovenija$Leto)))

podatki.slovenija$Leto <- substr(podatki.slovenija$Leto,1,4)

podatki.slovenija <- podatki.slovenija[,c("Dejavnosti", "Leto", "Kvartal", "Stalne cene, referenčno leto 2010, v mio €" )]

podatki.slovenija$Leto <- parse_number(podatki.slovenija$Leto)
podatki.slovenija$Dejavnosti <- parse_factor(podatki.slovenija$Dejavnosti)
podatki.slovenija$Kvartal <- parse_factor(podatki.slovenija$Kvartal)


podatki.evropa <- read_csv("PodatkiEvropa.csv", skip=1, col_names=c('Leto', 'Drzava', 'Enota', 'Sezona', 'Dejavnost', 'Merilo',
                                                                    'Stalne cene, referenčno leto 2010, v mio €','Dodatno'), na=":",locale=locale(encoding="Windows-1250"))

podatki.evropa$Enota <- NULL
podatki.evropa$Sezona <- NULL
podatki.evropa$Merilo <- NULL
podatki.evropa$Dodatno <- NULL

podatki.evropa$Kvartal <- substr(podatki.evropa$Leto,nchar(as.character(podatki.evropa$Leto))-2+1,nchar(as.character(podatki.evropa$Leto)))

podatki.evropa$Leto <- substr(podatki.evropa$Leto,1,4)

podatki.evropa <- podatki.evropa[,c("Drzava","Dejavnost","Leto","Kvartal", "Stalne cene, referenčno leto 2010, v mio €")]

podatki.evropa$Drzava <- parse_factor(podatki.evropa$Drzava)
podatki.evropa$Dejavnost <- parse_factor(podatki.evropa$Dejavnost)
podatki.evropa$Leto <- parse_number(podatki.evropa$Leto)
podatki.evropa$Kvartal <- parse_factor(podatki.evropa$Kvartal)
