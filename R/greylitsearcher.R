# All functions here are pulled directly from or heavily based on code written for the greylitsearcher shiny app
# https://github.com/nealhaddaway/greylitsearcher
# Thanks to Neil Haddaway


buildGoogleLinksAdv <- function(sites = '',
                                and_terms = '',
                                exact_phrase = '',
                                or_terms = '',
                                not_terms = '',
                                date_from = '',
                                date_to = '',
                                pages = 1) {
  
  #report
  report <- paste(
    'File generated: ',
    paste('Search date, time, timezone: ',
          Sys.time(),
          ' (',
          Sys.timezone(),
          ')',
          sep = ''),
    '\n',
    'Search parameters:',
    paste('Sites searched: ',
          paste0(sites, collapse = '; '),
          sep = ''),
    paste('All these words: ',
          paste(and_terms,
                collapse = '; '),
          sep = ''),
    paste('None of these words: ',
          paste(not_terms,
                collapse = '; '),
          sep = ''),
    paste('This exact word or phrase: ',
          paste('"',
                exact_phrase,
                '"',
                sep = ''),
          sep = ''),
    paste('Any these words: ',
          paste(or_terms,
                collapse = '; '),
          sep = ''),
    paste('Between these dates:',
          date_from,
          'and',
          date_to,
          sep = ' '),
    if(pages == ''){
      'Number of pages exported: 1'
    } else {
      paste('Number of pages exported: ',
            pages * length(trimws(unlist(strsplit(sites, "\n")))),
            sep = '')
    },
    sep = '\n')
  
  #prepare sites
  sites <- trimws(unlist(strsplit(sites, "\n")))
  
  #loop through sites to generate links
  df <- data.frame()
  for(i in 1:length(sites)){
    results <- buildGoogleLinkAdv(
      site = sites[i],
      and_terms = and_terms,
      exact_phrase = exact_phrase,
      or_terms = or_terms,
      not_terms = not_terms,
      date_from = date_from,
      date_to = date_to,
      pages = pages)
    resultsdf <- results$link
    resultsreport <- results$report
    df <- rbind(df, resultsdf)
  }
  
  report <- paste(report,
                  '\n',
                  'Google links generated:',
                  paste(df$link,
                        collapse = '\n'),
                  '\n',
                  sep = '\n')
  
  output <- list(link = df, report = report)
  
  return(output)
  
}

buildGoogleLinkAdv <- function(site = '',
                               and_terms = '',
                               exact_phrase = '',
                               or_terms = '',
                               not_terms = '',
                               date_from = '',
                               date_to = '',
                               pages = 1) {
  #report
  report <- paste(
    'File generated: ',
    paste('Search date, time, timezone: ',
          Sys.time(),
          ' (',
          Sys.timezone(),
          ')',
          sep = ''),
    '\n',
    'Search parameters:',
    paste('Site searched: ',
          site,
          sep = ''),
    paste('All these words: ',
          paste(and_terms,
                collapse = '; '),
          sep = ''),
    paste('None of these words: ',
          paste(not_terms,
                collapse = '; '),
          sep = ''),
    paste('This exact word or phrase: ',
          paste('"',
                exact_phrase,
                '"',
                sep = ''),
          sep = ''),
    paste('Any these words: ',
          paste(or_terms,
                collapse = '; '),
          sep = ''),
    paste('Between these dates:',
          date_from,
          'and',
          date_to,
          sep = ' '),
    if(pages == ''){
      'Number of pages exported: 1'
    } else {
      paste('Number of pages exported: ',
            pages,
            sep = '')
    },
    sep = '\n')
  
  site_orig <- site
  site <- if(identical(site, '') == TRUE){
    site <- ''
  } else {
    site <- paste0('site%3A',
                   site)
  }
  
  
  and_terms <- if(any(and_terms == '') == TRUE) { #if and_terms is blank then leave it blank, otherwise combine terms with '+'
    and_terms <- ''
  } else {
    and_terms <- gsub(',', '', paste('+',
                                     gsub(' ',
                                          '+',
                                          paste(and_terms,
                                                collapse = '+')),
                                     sep = ''))
  }
  
  exact_phrase <- if(any(exact_phrase == '') == TRUE){ #if exact_phrase is blank then leave it blank, otherwise combine terms with '+' and top/tail with '+%22'/'%22'
    exact_phrase <- ''
  } else {
    exact_phrase <- paste('+"',
                          gsub(' ',
                               '+',
                               paste(exact_phrase,
                                     collapse = '+')),
                          '"',
                          sep = '')
  }
  
  or_terms <- if(any(or_terms == '') == TRUE){ #if or_terms is blank then leave it blank, otherwise combine terms with '+OR+'
    or_terms <- ''
  } else {
    or_terms <- gsub(',', '', paste('+OR+',
                                    gsub(' ',
                                         '+OR+',
                                         paste(or_terms,
                                               collapse = '+OR+')),
                                    sep = ''))
  }
  
  not_terms <- if(any(not_terms == '') == TRUE){ #if not_terms is blank then leave it blank, otherwise combine terms with '+OR+'
    not_terms <- ''
  } else {
    not_terms <- gsub(',', '', paste('+-',
                                     gsub(' ',
                                          '+-',
                                          paste(not_terms,
                                                collapse = '+-')),
                                     sep = ''))
  }
  
  if((date_from == '') == TRUE){ #specify the start year
    Fdate <- ''
  } else {
    Fyear <- format(as.Date(date_from, format="%Y-%m-%d"), "%Y")
    Fmonth <- format(as.Date(date_from, format="%Y-%m-%d"), "%m")
    Fday <- format(as.Date(date_from, format="%Y-%m-%d"), "%d")
    Fdate <- paste0('%2Ccd_min%3A', Fmonth, '%2F', Fday, '%2F', Fyear)
  }
  if((date_to == '') == TRUE){ #specify the stop year
    Tdate <- ''
  } else {
    Tyear <- format(as.Date(date_to, format="%Y-%m-%d"), "%Y")
    Tmonth <- format(as.Date(date_to, format="%Y-%m-%d"), "%m")
    Tday <- format(as.Date(date_to, format="%Y-%m-%d"), "%d")
    Tdate <- paste0('%2Ccd_max%3A', Tmonth, '%2F', Tday, '%2F', Tyear)
  }
  
  if(Fdate == '' && Tdate == ''){
    Drange <- ''
  } else {
    Drange <- paste0(
      '&tbs=cdr%3A1',
      Fdate,
      Tdate
    )
  }
  
  
  #build URL
  if (pages == 1){ #if pages = 1 then only a single link is generated
    link <- paste0('https://www.google.com/search?q=',
                   site,
                   and_terms,
                   or_terms,
                   exact_phrase,
                   not_terms,
                   Drange,
                   '&start=0')
  } else { #otherwise, one link is generated for each page
    link <- list()
    init <- seq(0, (pages*10-10), 10)
    for (i in init){
      x <- paste0('https://www.google.com/search?q=',
                  '&q=',
                  site,
                  and_terms,
                  or_terms,
                  exact_phrase,
                  not_terms,
                  Drange,
                  '&start=',
                  i)
      link <- append(link, x)
      link <- unlist(link)
    }
    
  }
  
  report <- paste(report,
                  '\n',
                  'Google links generated:',
                  paste(link,
                        collapse = '\n'),
                  '\n',
                  sep = '\n')
  
  linkdf <- data.frame(site = site_orig,
                       page = ((as.numeric(sub('.*&start=', '', link)))/10) + 1,
                       link = link,
                       row.names = NULL)
  
  output <- list(link = linkdf, report = report)
  
  return(output)
}



save_html <- function(url, path = '', pause = 0.5, backoff = TRUE){
  t0 <- Sys.time()
  
  pause <- pause * runif(1, 0.5, 1.5)
  
  #initiate scrape and detect redirect
  html <- RCurl::getURL(url, followlocation=TRUE)
  names(html) <- url
  
  t1 <- Sys.time()
  response_delay <- round(as.numeric(t1-t0), 3)
  if(backoff == TRUE){
    #message(paste('Request took',
    #              round(response_delay, 3),
    #            'seconds to perform. Waiting',
    #            round(pause*response_delay, 3),
    #            'seconds before next attempt.\n'))
    Sys.sleep(pause*response_delay)
  } else {
    #message(paste('Request took',
    #              round(response_delay, 3),
    #            'second(s) to perform. Waiting',
    #            round(pause, 3),
    #            'seconds before next attempt.\n'))
    Sys.sleep(pause)
  }
  
  return(html)
  
}



get_info <- function(html){
  code_lines <- unlist(strsplit(html, '\\<div', useBytes = TRUE))
  titles <- get_titles(code_lines)
  links <- get_links(code_lines)
  df <- tibble::tibble(title = titles, link = links)
  return(df)
}


# working
get_titles <- function(code_lines){
  y <- grep("BNeawe vvjwJb AP7Wnd", code_lines) #find location of lines containing 'result-title js-result-title' tag
  titles <- code_lines[y] #extract lines
  titles <- gsub('>', '', gsub('<', '', stringr::str_extract(titles, ">\\s*(.*?)\\s*<")))
  return(titles)
}


get_links <- function(code_lines){
  y <- grep("egMi0 kCrYT", code_lines) #find location of lines containing urls
  links <- code_lines[y] #extract lines
  links <- sub(".*q=", "", links)
  links <- sub("\".*", "", links)
  return(links)
}

get_dates <- function(code_lines){
  y <- grep("r0bn4c rQMQod", code_lines) #find location of lines containing date of article
  subpages <- code_lines[y] #extract lines
  subpages <- sub(".*class=\"BNeawe s3v9rd AP7Wnd\"><span class=\"r0bn4c rQMQod\">", "", subpages)
  subpages <- sub("<.*", "", subpages)
  return(subpages)
}