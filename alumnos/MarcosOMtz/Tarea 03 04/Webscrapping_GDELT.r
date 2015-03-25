library(rvest)


base_url <- "http://data.gdeltproject.org/events/"
gdelt_files <- html(paste0(base_url,"index.html"))

GDELT_nombres <- gdelt_files %>%
                 html_nodes("a") %>%
                 html_text()

write.table(GDELT_nombres,"/Users/Marcos/Bases-BigData/GDELT_nombres.txt",col.names=FALSE,row.names=FALSE)


# Descargando los archivos de GDALT
for (i in GDELT_nombres[4:801]){
    url <- paste0(base_url,i)
    destfile <- paste0("/Users/Marcos/Bases-BigData/gdelt_file/",i)
    download.file(url,destfile)
}
