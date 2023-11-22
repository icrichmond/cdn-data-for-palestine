# === Targets -------------------------------------------------------------


# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)



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
    articles,
    search_articles('www.cbc.ca', exact_phrase = 'Israeli', date_from = '2023-10-07', date_to = '2023-11-19',
                    pages = 10)
  ),
  
  tar_target(
    scan,
    scan_articles(articles)
  )
  
)

# Quarto ------------------------------------------------------------------
targets_quarto <- c(
  tar_quarto(site, path = '.')
)



# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)