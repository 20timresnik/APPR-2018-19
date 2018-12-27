library(readr)
library(reshape2)

delezi1 <- read_delim("delezi.csv", ";", col_names=TRUE, skip=4, na="-", 
                     locale=locale(encoding="Windows-1250", decimal_mark="."))
delezi1 <- delezi1[-c(15:23),]
colnames(delezi1)[1] <- "Dejavnosti"

delezi.tidy <- melt(delezi1, id.vars="Dejavnosti", measure.vars=names(delezi1)[-1],
                    variable.name="Kvartali",value.name="Stalne cene, referenčno leto 2010, v mio €", na.rm=TRUE)

#delezi.tidy$Kvartali <- parse_integer(delezi.tidy$Kvartali)

evropaA <- read_csv("evropaA.csv", skip=1, col_names=c('Kvartal', 'Drzava', 'Enota', 'Sezona', 'Dejavnost', 'Merilo',
                                               'Stalne cene, referenčno leto 2010, v mio €','Dodatno'), na=":",locale=locale(encoding="Windows-1250"))

evropaA$Enota <- NULL
evropaA$Sezona <- NULL
evropaA$Merilo <- NULL
evropaA$Dodatno <- NULL

evropaB <- evropaA[,c("Drzava","Dejavnost","Kvartal","Stalne cene, referenčno leto 2010, v mio €")]

