scan_articles <- function(){
  
  get_articles <- function(n_articles) {
    page <- paste0("https://www.theroot.com/news/criminal-justice",
                   "?startIndex=",
                   n_articles) %>%
      read_html()
    
    tibble(
      title = page %>%
        html_elements(".aoiLP .js_link") %>%
        html_text2(),
      date = page %>%
        html_elements(".js_meta-time") %>%
        html_text2(),
      url = page %>%
        html_elements(".aoiLP .js_link") %>%
        html_attr("href")
    )
  }
  
  #df <- map_dfr(seq(0, 200, by = 20), get_articles)
  df <- map_dfr(0, get_articles) #small example
  
  
  df %>%
    slice(1:10) %>% # subset 10 rows for example
    mutate(html = map(url, read_html),
           content = map(html, ~ .x %>%
                           html_elements(".bOfvBY") %>%
                           html_text2 %>% 
                           paste(collapse = ",")),
           author = map(html, ~ .x %>%
                          html_elements(".llHfhX .js_link , .permalink-bylineprop") %>%
                          html_text2() %>%
                          set_names(paste0('author', 1:length(.))) #name the elements, which will become column names
           )
    ) %>%
    unnest(content) %>%
    unnest_wider(author)
  
}