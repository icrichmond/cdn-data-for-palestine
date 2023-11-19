t <- buildGoogleLinkAdv(site = 'www.cbc.ca', exact_phrase = 'Israeli', pages = 1)

tt <- save_html(t$link$link)

get_info(tt)
