# Loading packages
library(tidyverse)
library(jsonlite)

# creating initial playlist
query <- "https://itunes.apple.com/search?term=party&media=music&limit=200&genre=Hip+Hop"
response <- fromJSON(query)
initial_playlist <- response$results

# Selecting variables
initial_playlist <- initial_playlist %>%
  select(trackName, artistName, collectionName, collectionPrice, trackPrice, trackTimeMillis, primaryGenreName, releaseDate) %>%
  rename(song_name = trackName,
         artist = artistName,
         album = collectionName,
         album_price = collectionPrice,
         song_price = trackPrice,
         duration_ms = trackTimeMillis,
         genre = primaryGenreName,
         dateReleased = releaseDate)

# Arranging data frame based on duration
initial_playlist <- initial_playlist %>%
  arrange(duration_ms)

# Using mutate to create 3 New Variables
my_playlist <- initial_playlist %>%
  mutate(duration_min = duration_ms/60000,
         album_name_length = nchar(album),
         song_name_length = nchar(song_name))

# Using filter to select only 20 songs
my_playlist <-  filter(my_playlist, !duplicated(artist)) %>%
  slice(1:20)

# Saving my_playlist as a CSV file
write_csv(my_playlist, "my_playlist.csv")

# Summary values 
personal_songs <- my_playlist %>%
  mutate(personal_name = ifelse(str_detect(str_to_lower(song_name),
                                           "you|me|they|he|she|we|us"),
                                "yes",
                                "no"))
personal_songs %>%
  group_by(personal_name) %>%
  summarise(num_songs = n())

# Creating a bar chart
artist_data <- my_playlist %>%
  mutate(num_artists = str_count(artist, "&") + 1) %>%
  mutate(multiple_artists = ifelse(num_artists >= 2, "yes", "no"))
artist_data %>%
  ggplot() +
  geom_bar(aes(x = multiple_artists)) +
  labs(title = "Songs that have more than ONE artist")

# Tidyverse vs SQL
"
SELECT duration_ms, COUNT(*)
FROM tbl_songs
GROUP BY duration_ms;

SELECT DISTINCT artist
FROM tbl_songs
LIMIT 20;
"
  