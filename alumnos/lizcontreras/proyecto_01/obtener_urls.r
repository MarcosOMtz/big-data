
#Se obtiene la base
base_url <- "http://www.nuforc.org/webreports/"

#Se obtiene el indice
ufo_reports_index <- html(paste0(base_url, "ndxevent.html"))

#Se obtienen las urls por dia
daily_urls <- paste0(base_url, ufo_reports_index %>%
   html_nodes(xpath = "//*/td[1]/*/a[contains(@href, 'ndxe')]") %>%
   html_attr("href"))

#Se guardan las urls en un .txt
write.table(daily_urls, "urls_ufo.txt)