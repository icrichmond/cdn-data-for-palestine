# i run greylitsearcher::rungreylitsearcher() at the start to source functions used for shiny app

t <- buildGoogleLinksAdv(site = 'www.cbc.ca', exact_phrase = 'Israeli', date_from = '2023-10-07',
                         date_to = '2023-11-19', pages = 10)

t$link <- cbind(t$link, link_num=paste0('link', seq(1, nrow(t$link), 1)))

htmls <- list()

for(i in 1:length(t$link[,3])){
  html <- save_html((t$link[,3])[i], pause = 0.5, backoff = FALSE)
  htmls <- c(htmls, html)
}


t$htmls <- htmls

df <- data.frame()

for(i in 1:length(t$htmls)){
  data <- get_info(unlist(t$htmls[i]))
  print(data)
  df <- dplyr::bind_rows(df, data)
}

df <- df[!duplicated(df), ]


