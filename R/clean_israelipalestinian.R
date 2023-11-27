clean_israelipalestinian <- function(scan_israeli, scan_palestinian){
  
  # combine datasets 
  bound <- rbind(scan_israeli, scan_palestinian)
  
  filt <- bound %>% 
    # remove articles that have warning that were published a while ago
    filter(!grepl('This article was published more than', content)) %>% 
    # remove rows that are identical in content
    distinct(content, .keep_all = T) %>% 
    rowwise() %>% 
    mutate(count_isr = sum(str_count(content, "Israel")),
           count_pal = sum(str_count(content, "Palestin")),
           media_source = sub(".*www.", "", link),
           media_source = sub(c(".ca.*|.com.*"), "", media_source),
           media_source = case_when(media_source == "cbc" ~ "CBC",
                                    media_source == "globalnews" ~ "Global News",
                                    media_source == "nationalpost" ~ "National Post",
                                    media_source == "theglobeandmail" ~ "Globe and Mail",
                                    media_source == "ctvnews" ~ "CTV"))
  
  
  
}