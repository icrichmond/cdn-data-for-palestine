search_articles <- function(sites = '', and_terms = '', exact_phrase = '', or_terms = '',
                            not_terms = '', date_from = '', date_to = '',
                            pages = 1){
  
  
  t <- buildGoogleLinksAdv(sites = sites,
                           and_terms = and_terms,
                           exact_phrase = exact_phrase,
                           or_terms = or_terms,
                           not_terms = not_terms,
                           date_from = date_from,
                           date_to = date_to,
                           pages = pages)

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
  
  
  
}