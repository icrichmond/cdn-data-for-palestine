scan_articles <- function(articles){
  
  t <- articles %>%
    mutate(html = map(link, function(x){read_html(x[[1]])}),
           content = map(html, ~ .x %>% 
                           html_nodes("p") %>% 
                          html_text2() %>% 
                          paste(collapse = ",")))
  
}