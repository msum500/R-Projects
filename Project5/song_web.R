# Loading library packages
library(tidyverse)
library(rvest)

# Three different country playlists
playlists <- c(
  "https://music.apple.com/us/playlist/top-100-new-zealand/pl.d8742df90f43402ba5e708eefd6d949a",
  "https://music.apple.com/us/playlist/top-100-united-states/pl.d8742df90f43402ba5e708eefd6d949a",
  "https://music.apple.com/us/playlist/top-100-united-kingdom/pl.d8742df90f43402ba5e708eefd6d949a")

# Scrapping information
scrape_playlist <- function(i) {
  webpage <- read_html(i)
  
  track_id <- webpage %>%
    html_elements(".songs-list") %>%
    html_elements("a") %>%
    html_attr("href") %>%
    .[str_detect(., "/song/")] %>%
    str_remove_all("https://(.*)/song/(.*)/")
  
  album_id <- webpage %>%
    html_elements(".songs-list__col.songs-list__col--tertiary") %>%
    html_elements(".songs-list__song-link-wrapper") %>%
    html_elements("a") %>%
    html_attr("href") %>%
    str_remove_all("https://(.*)/album/(.*)/")
  
  song_duration <- webpage %>%
    html_elements(".songs-list-row__controls") %>%
    html_text2() %>%
    str_remove_all("PREVIEW") %>%
    str_remove_all("\n")
  
  playlist_name <- webpage %>%
    html_elements(".songs-list-row__song-name") %>%
    html_text2()
  
  tibble(track_id = track_id, album_id = album_id, 
         song_duration = song_duration, playlist_name = playlist_name)
}

# 2 second break with map_df()
song_data <- map_df(playlists, function(url) {
  Sys.sleep(2)
  scrape_playlist(url)
})

# Adding ranking in top 100
song_data <- song_data %>%
  mutate(ranking = row_number())

# Save the combined data frame as an rds file
saveRDS(song_data, "song_data.rds")