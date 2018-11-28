# Analiza podatkov s programom R, 2018/19

Avtor: Tim Resnik

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2018/19

* [![Shiny](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/jaanos/APPR-2018-19/master?urlpath=shiny/APPR-2018-19/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/jaanos/APPR-2018-19/master?urlpath=rstudio) RStudio

## Spreminanje bruto domačega proizvoda po državah Evropske Unije in Slovenija

## Osnovna ideja:
V svojem projektu bom preučeval dinamiko spreminjanja BDP po različnih državah EU. Za študente Finančne matematike ter moje malenkosti nadvse zanimiva tema, s katero se bomo po zaključku šolanja pogosto srečevali, jo analizirali in rezultate interpretirali za različne namene.

## Plan dela
Največ časa bom porabil za analiziranje situacije v Sloveniji, ter kako se je spreminjala skozi leta(na voljo je za več kot 20 let podatkov). Pozoren bom tudi na to, kako je pri državah z različnimi stopnjami razvitosti, BDP naraščal/padal s spreminjajočo stopnjo. Glede na gospodarkso krizo v letih 2008/09 bo zagotovo zanimivo dogajanje v tistih letih in okrevanje po le tem. Poglaviten podatek bo seveda BDP na prebivalca, ki posredno izraža tudi gospodarsko moč vsake članice EU.

## Zasnova podatkovnega modela
Zbrane podatke bom poizkusil predstaviti na čimbolj jasen in bralcu zanimiv način, z dobro urejenimi tabelami, ter kjer bo možno, tudi z grafi in podobnimi oblikami predstavljanja. Tabele bom najprej predstavil za Slovenijo, nato pa jih primerjal z drugimi državami in ugotovitve poizkušal strniti v kratkih komentarjih. 

## Opis podatkovnih virov
Glavna vira za raziskovanje bosta bazi SURS(Satistični Urad Republike Slovenije) ter EUROSTAT(Evropski kazalci/številke za številna področja zanimanja). Podatki na teh straneh so v oblikah tabel, grafov.

SURS:
https://www.stat.si/StatWeb/Field/Index/1

Eurostat:
https://ec.europa.eu/eurostat/data/database



## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem.zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
