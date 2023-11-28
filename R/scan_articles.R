scan_articles <- function(articles){
  
  posshtml= possibly(.f = read_html, otherwise = 'error')
  
  t <- articles %>%
    mutate(html = map(link, ~posshtml(.x[[1]]))) %>%
    filter(html != 'error') %>%
    mutate(content = map(html, ~ .x %>% 
                          html_nodes("p") %>% 
                          html_text2() %>% 
                          paste(collapse = ",")))
  
}