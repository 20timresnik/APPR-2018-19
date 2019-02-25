library(readr)
library(reshape2)
library(dplyr)

# 2. faza : Uvoz podatkov

# Funkcija, ki uvozi podatke za Slovenijo iz csv dokumenta
podatki.slovenija <- read_delim("PodatkiSlovenija.csv",
                                ";",
                                col_names=TRUE,
                                skip=4,
                                na="-",
                                n_max = 11,
                                locale=locale(encoding="Windows-1250", decimal_mark="."))

# Prvemu stolpcu nastavimo novO ime
colnames(podatki.slovenija)[1] <- "Dejavnosti"

# Tabelo preoblikujem s funkcijo melt
podatki.slovenija <- melt(podatki.slovenija, id.vars="Dejavnosti", measure.vars=names(podatki.slovenija)[-1],
                          variable.name="Leto",value.name="Stalne cene, referenčno leto 2010, v mio €", na.rm=TRUE)

# Stolpec namenjen kvartalom
podatki.slovenija$Kvartal <- substr(podatki.slovenija$Leto,nchar(as.character(podatki.slovenija$Leto))-2+1,nchar(as.character(podatki.slovenija$Leto)))

# Urejen stolpec za leta 
podatki.slovenija$Leto <- substr(podatki.slovenija$Leto,1,4)

# Stolpce tabele postavimo v željen vrsti red
podatki.slovenija <- podatki.slovenija[,c("Dejavnosti", "Leto", "Kvartal", "Stalne cene, referenčno leto 2010, v mio €" )]

# Nastavljanje parse-ov za prve tri stolpce
podatki.slovenija$Dejavnosti <- parse_factor(podatki.slovenija$Dejavnosti)
podatki.slovenija$Leto <- parse_number(podatki.slovenija$Leto)
podatki.slovenija$Kvartal <- parse_factor(podatki.slovenija$Kvartal)

#Funkcija, ki uvozi podatke za evropo iz dokumenta csv
podatki.evropa <- read_csv("PodatkiEvropa.csv", skip=1, col_names=c('Leto', 'Drzava', 'Enota', 'Sezona', 'Dejavnost', 'Merilo',
                                                                    'Stalne cene, referenčno leto 2010, v mio €','Dodatno'), na=":",locale=locale(encoding="Windows-1250"))

# Brisanje stolpcev, ki nas ne zanimajo/jih ne potrebujemo
podatki.evropa$Enota <- NULL
podatki.evropa$Sezona <- NULL
podatki.evropa$Merilo <- NULL
podatki.evropa$Dodatno <- NULL

# Stolpec namenjen kvartalom
podatki.evropa$Kvartal <- substr(podatki.evropa$Leto,nchar(as.character(podatki.evropa$Leto))-2+1,nchar(as.character(podatki.evropa$Leto)))

# Urejen stolpec za leta 
podatki.evropa$Leto <- substr(podatki.evropa$Leto,1,4)

# Stolpce tabele postavimo v željen vrsti red
podatki.evropa <- podatki.evropa[,c("Drzava","Dejavnost","Leto","Kvartal", "Stalne cene, referenčno leto 2010, v mio €")]

# Nastavljanje parse-ov za prve štiri stolpce
podatki.evropa$Drzava <- parse_factor(podatki.evropa$Drzava)
podatki.evropa$Dejavnost <- parse_factor(podatki.evropa$Dejavnost)
podatki.evropa$Leto <- parse_number(podatki.evropa$Leto)
podatki.evropa$Kvartal <- parse_factor(podatki.evropa$Kvartal)
