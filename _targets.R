# === Targets -------------------------------------------------------------


# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)

# TODO:
# - add date column in scanning step

# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')


# Renv --------------------------------------------------------------------
activate()
snapshot()
restore()



# Data --------------------------------------------------------------------

targets_data <- c(
  tar_target(
    articles_israeli,
    search_articles(c('www.cbc.ca', 'www.theglobeandmail.com', 'www.ctvnews.ca',
                      'www.globalnews.ca', 'www.nationalpost.com'), 
                    exact_phrase = 'Israeli', 
                    date_from = '2023-10-07', date_to = '2023-12-06',
                    pages = 10)
  ),
  
  tar_target(
    scan_israeli,
    scan_articles(articles_israeli)
  ),
  
  tar_target(
    articles_palestinian,
    search_articles(c('www.cbc.ca', 'www.theglobeandmail.com', 'www.ctvnews.ca',
                      'www.globalnews.ca', 'www.nationalpost.com'), 
                    exact_phrase = 'Palestinian', 
                    date_from = '2023-10-07', date_to = '2023-12-06',
                    pages = 10)
  ),
  
  tar_target(
    scan_palestinian,
    scan_articles(articles_palestinian)
  ),
  
  tar_target(
    articles_israelihostages,
    search_articles(c('www.cbc.ca', 'www.theglobeandmail.com', 'www.ctvnews.ca',
                      'www.globalnews.ca', 'www.nationalpost.com'), 
                    exact_phrase = 'Israeli hostages', not_terms = 'Palestinian hostages', 
                    date_from = '2023-10-07', date_to = '2023-12-06',
                    pages = 10)
  ),
  
  tar_target(
    scan_israelihostages,
    scan_articles(articles_israelihostages)
  )
  
  
)

# Quarto ------------------------------------------------------------------
targets_quarto <- c(
  tar_quarto(site, path = '.')
)



# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)