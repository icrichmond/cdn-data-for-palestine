scan_articles <- function(articles){
  
  t <- articles %>%
    mutate(html = map(link, function(x){read_html(x[[1]])}),
           content = map(html, ~ .x %>% 
                           html_nodes("p") %>% 
                          html_text2() %>% 
                          paste(collapse = ",")),
           date = map(html, ~ .x %>%
                           html_nodes("date") %>%
                           html_text2))#,
           #author = map(html, ~ .x %>%
   #        #               html_elements(".llHfhX .js_link , .permalink-bylineprop") %>%
   #        #               html_text2() %>%
  #         #               set_names(paste0('author', 1:length(.))))
  #  ) %>% #
  #  unnest(content) %>%
  #  unnest_wider(author)
  
}