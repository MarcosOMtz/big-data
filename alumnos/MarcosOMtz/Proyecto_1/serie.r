library(dplyr)
library(tidyr)
library(ggplot2)

# PREGUNTA 4

# se prepara archivo en basch/shell
# cat UFO_Proyecto.txt | cut -d$'\t' -f2,4 > fecha_edo.txt




# Se va a crear la tabla "serie.csv"

# leyendo. archivo
df <- read.delim("/Users/Marcos/Bases-BigData/UFO_fecha_edo.txt", na.strings = "") # --> filas=96110


# Solo nos quedamos con los que tienen registro de ciudad.
df <- df[complete.cases(df),] # --> filas=88383


# Preparando datos (registro con fecha y ciudad de avistamiento)
df <- df                                                         %>%
      separate(col=City, into=c("month","day","year","time"),
               regex=" ", remove=F, extra="drop")                %>%
      mutate(date = paste(month, day, year, sep = '/'),
             city = Shape, 
             date = as.Date(date, format='%m/%d/%y'))            %>%
      select(date,city)


# Filtramos las fechas que son mayores al 4 marzo 2015 (¿errores?)
# Se crea una tabla de frecuencias por "date" y graficamos
serie.date <- df                                    %>%
              filter( date < as.Date("2015-03-04")) %>%
              group_by(date)                        %>%
              summarise(count = n())


ggplot(serie.date, aes(x = date, y = count)) +
  geom_line() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  geom_point() +
  geom_point(colour = 'red', size = 2)




# Filtramos las fechas que son mayores al 4 marzo 2015 (¿errores?)
# Se crea una tabla de frecuencias por "city" y "date" y graficamos
serie.city <- df                                    %>%
              filter( date < as.Date("2015-03-04")) %>%
              group_by(city,date)                   %>%
              summarise(count = n())


top_estados <- names(head(sort(table(serie.city$city),decreasing=TRUE),10))
top_estados_obs <- serie.city[which(serie.city$city==c(top_estados)),]


ggplot(top_estados_obs, aes(x = date, y = count, group = city, color=city)) +
  facet_wrap(~ city, nrow = 3) +
  geom_line() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  geom_point()



# Agrupamos avistamientos por estado.
state.reports <- df %>%
                 group_by(city)%>%
                 summarise(reports = n()) %>%
                 select(city,reports)%>%
                 arrange(-reports)


ggplot(head(state.reports,10), aes(x = city, y = reports)) +
  geom_bar(stat = "identity", fill="lightgreen", colour="darkgreen")



# Graficamos por dia de la semana
library(lubridate)
dia <- aggregate(serie.date$count,
                 by=list(Category=wday(serie.date$date)),
                 FUN=sum)


ggplot(dia, aes(x = Category, y = x)) +
  geom_bar(stat = "identity", fill="lightblue", colour="darkblue") +
  labs(y = 'Avistamientos', x = 'Dia de la semana') +
  scale_x_continuous(breaks=seq(from=1, to=7, by=1))



# Graficamos por mes
mes <- aggregate(serie.date$count,
                 by=list(Category=month(serie.date$date)),
                 FUN=sum)


ggplot(mes, aes(x = Category, y = x)) +
  geom_bar(stat = "identity", fill="azure4", colour="black") +
  labs(y = 'Avistamientos', x = 'Mes del año') +
  scale_x_continuous(breaks=seq(from=1, to=12, by=1))






# agreamos totales de avistamiento por estado. Para quedarnos solo con los estados con mayor
# avistamiento.  ESTO PARA QUE SE VEA MEJOR EL GRAFO.
serie$total <- plyr::mapvalues(as.factor(serie$city),as.vector(state.reports$city),as.vector(state.reports$reports),warn_missing=T)
serie$total <- as.numeric(as.character(serie$total))


#solo nos quedamos con estadados con mas de 3000 avistamientos acumulados.
serie_300 <- serie %>%
             filter(total > 3000)


# guardamos.
write.table(serie_300[,c("city","date","count")],"/Users/Marcos/big-data-test/serie.csv",sep=",",row.names=F,col.names=F)

