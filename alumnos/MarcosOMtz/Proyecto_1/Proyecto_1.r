rm(list = ls())
gc()


library(rvest)
base_url <- "http://www.nuforc.org/webreports/"
ufo_reports_index <- html(paste0(base_url, "ndxevent.html"))
ufo_reports_index %>%
  html_nodes(xpath = "//*/td[2]")


# Obtenemos las páginas por día
daily_urls <- paste0(base_url, ufo_reports_index %>%
                                html_nodes(xpath = "//*/td[1]/*/a[contains(@href, 'ndxe')]")  %>%
                                html_attr("href")
                    )

#names(daily_urls) <- 'URL'
#head(daily_urls)


table <- data.frame(html_table(html(daily_urls[1]), fill = TRUE))


table <- NULL
a <- NULL
for (i in 1:10) {
  a <- data.frame(html_table(html(daily_urls[i]), fill = TRUE))
  table <- rbind(table, a)
  # smartbind(df1, df2) cuando las tablas pueden tener distintas columnas
}


# Crear una tabla "TSV" para el análisis en la Terminal
write.table(table, file='/Users/Marcos/big-data-test/UFO_Proyecto_2.tsv', quote=FALSE,
            sep="\t", row.names=FALSE, col.names=c('Date / Time', 'City', 'State', 'Shape',
                                                   'Duration', 'Summary', 'Posted'))


table_url1 <- data.frame(html_table(html(daily_urls[1]), fill = TRUE))
table_url2 <- data.frame(html_table(html(daily_urls[2]), fill = TRUE))
table_url3 <- data.frame(html_table(html(daily_urls[3]), fill = TRUE))
table_url4 <- data.frame(html_table(html(daily_urls[4]), fill = TRUE))
table_url <- rbind(table_url1, table_url2, table_url3, table_url4)


table_url1 <- NULL
table_url2 <- NULL
table_url3 <- NULL
table_url4 <- NULL
table_url  <- NULL




# Validar cuantas filas tienen los archivos UFO
b <- NULL
filas <- NULL
for (i in 1:(length(daily_urls)-1)) {
  b<- nrow(data.frame(html_table(html(daily_urls[i]), fill = TRUE)))
  filas <- rbind(filas, b)
}
sum(filas)
write.table(filas, file='/Users/Marcos/big-data-test/UFO_Proyecto_Filas.txt', quote=FALSE,
            row.names=FALSE, col.names='Filas')



# Validar cuantas columnas tienen los archivos UFO
c <- NULL
columnas <- NULL
for (i in 1:(length(daily_urls)-1)) {
  c<- length(data.frame(html_table(html(daily_urls[i]), fill = TRUE)))
  columnas <- rbind(columnas, c)
}
sum(columnas)
write.table(columnas, file='/Users/Marcos/big-data-test/UFO_Proyecto_Columnas.txt', quote=FALSE,
            row.names=FALSE, col.names='Columnas')







