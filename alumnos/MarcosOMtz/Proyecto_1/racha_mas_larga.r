library(dplyr)
library(tidyr)

#cat UFO_Proyecto.txt | cut -d$'\t' -f2,4 > fecha_edo.txt

#serie.csv


# leyendo. archivo
df <- read.delim("/Users/Marcos/big-data-test/fecha_edo.txt", na.strings = "")

# solo nos quedamos con los que tienen registro de ciudad.
df <- df[complete.cases(df),]

# preparando datos (registro con fecha y ciudad de avistamiento)
df <- df %>%
  separate(col=City, into=c("month","day","year","time"),
           regex=" ",remove=F,extra="drop") %>%
  mutate(date = paste(month, day, year, sep = '/'),
         city = Shape,
         date = as.Date(date,format='%m/%d/%y'))%>%
  select(date,city)


# Data aplicando window function lag (columna con dato previo)
data.lag <- df                       %>%
            group_by(city,date)      %>%
            arrange(city, date)      %>%
            summarise(reportes =n()) %>%
            mutate(freq = reportes/sum(reportes),
            prev = lag(date),
            dif = (date -prev))


# obtenemos el acumulado. Nos interesa cuantos con 1 en dif consecutivos existen.
# significa el mayor plazo consecutivo de reportes de avistamiento.
data.lag$acum <- sequence(rle(as.character(data.lag$dif))$lengths)


#ordenamos por acumulado
data <-data.lag[with(data.lag, order(-acum)), ]
data

# mayor racha de avistamiento por estado
result <- data           %>%
          group_by(city) %>%
          top_n(n=1)


result


