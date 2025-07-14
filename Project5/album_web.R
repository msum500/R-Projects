# Loading library packages
library(tidyverse)
library(rvest)

# Reading data created in Part A
song_data <- readRDS("song_data.rds")

# Extracting unique values
album_ids <- song_data$album_id %>% unique()

# Scrapping information
ccc <- function(i) {
  Sys.sleep(2)  
  url <- paste0("https://music.apple.com/us/album/", i) 
  page <- read_html(url)
  album_info <- page %>%
    html_elements(".footer-body") %>%
    html_elements(".description") %>%
    html_text() %>%
    str_split("\n") %>%
    unlist()
  
  album_genre <- page %>%
    html_elements(".footer-body") %>%
    html_elements(".genre") %>%
    html_text() %>%
    first()
    
  album_release_date <- album_info[1]
  
  tibble(album_id = i, album_release_date = album_release_date)
}
album_data <- map_df(album_ids, scrape_album)

# New data frame joining the other variables
playlist_data <- inner_join(song_data, album_data, by = "album_id")

# Saving joined data frame
saveRDS(playlist_data, "playlist_data.rds")
