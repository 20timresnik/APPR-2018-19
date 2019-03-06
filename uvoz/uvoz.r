library(readr)
library(reshape2)
library(dplyr)

# 2. faza : Uvoz podatkov

# Funkcija, ki uvozi podatke za Slovenijo iz csv dokumenta
podatki.slovenija <- read_delim("podatki/PodatkiSlovenija.csv",
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
                          variable.name="Leto",value.name="Vrednost", na.rm=TRUE)

# Stolpec namenjen kvartalom
podatki.slovenija$Kvartal <- substr(podatki.slovenija$Leto,nchar(as.character(podatki.slovenija$Leto))-1+1,nchar(as.character(podatki.slovenija$Leto)))

# Urejen stolpec za leta 
podatki.slovenija$Leto <- substr(podatki.slovenija$Leto,1,4)

# Odstranim C dejavnost, saj je že uporabljena v skupini dejavnosti BCDE
podatki.slovenija <- podatki.slovenija %>% filter(podatki.slovenija$Dejavnosti != '..od tega: C Predelovalne dejavnosti')

# Stolpce tabele postavimo v željen vrsti red
podatki.slovenija <- podatki.slovenija[,c("Dejavnosti", "Leto", "Kvartal", "Vrednost" )]

# Nastavljanje parse-ov
podatki.slovenija$Leto <- parse_number(podatki.slovenija$Leto)
podatki.slovenija$Kvartal <- parse_number(podatki.slovenija$Kvartal)

# Dejavnosti spremenim v factorje
podatki.slovenija$Dejavnosti <- as.factor(podatki.slovenija$Dejavnosti)

# Funkcija, ki uvozi podatke za evropo iz dokumenta csv
podatki.evropa <- read_csv("podatki/PodatkiEvropa.csv", skip=1, col_names=c('Leto', 'Drzava', 'Enota', 'Sezona', 'Dejavnost', 'Merilo',
                                                                    'Vrednost','Dodatno'), na=":",locale=locale(encoding="Windows-1250"))

# Brisanje stolpcev, ki nas ne zanimajo/jih ne potrebujemo
podatki.evropa$Enota <- NULL
podatki.evropa$Sezona <- NULL
podatki.evropa$Merilo <- NULL
podatki.evropa$Dodatno <- NULL

# Stolpec namenjen kvartalom
podatki.evropa$Kvartal <- substr(podatki.evropa$Leto,nchar(as.character(podatki.evropa$Leto))-1+1,nchar(as.character(podatki.evropa$Leto)))

# Urejen stolpec za leta 
podatki.evropa$Leto <- substr(podatki.evropa$Leto,1,4)

# Odstranjen 'manufacturing'(sektor C), ker je že vključen v 'industry'
podatki.evropa <- podatki.evropa %>% filter(podatki.evropa$Dejavnost != 'Manufacturing')

# Stolpce tabele postavimo v željen vrsti red
podatki.evropa <- podatki.evropa[,c("Drzava","Dejavnost","Leto","Kvartal", "Vrednost")]

# Nastavljanje parse-ov
podatki.evropa$Leto <- parse_number(podatki.evropa$Leto)
podatki.evropa$Kvartal <- parse_number(podatki.evropa$Kvartal)

# Drzave in dejavnosti spremenim v factorje
podatki.evropa$Drzava <- as.factor(podatki.evropa$Drzava)
podatki.evropa$Dejavnost <- as.factor(podatki.evropa$Dejavnost)


populacija.evropa <- read_csv("podatki/PopulacijaEvropa.csv",skip=1, 
                              col_names=c('Starost', 'Drzava', 'Enota', 'Cas', 'Spol', 'Vrednost','Dodatno'))

populacija.evropa$Starost <- NULL
populacija.evropa$Enota <- NULL
populacija.evropa$Cas <- NULL
populacija.evropa$Spol <- NULL
populacija.evropa$Dodatno <- NULL

populacija.evropa$Drzava <- as.factor(populacija.evropa$Drzava)
