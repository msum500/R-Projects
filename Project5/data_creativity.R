# Loading library packages
library(tidyverse)
library(ggplot2)
library(stringr)
library(lubridate)

# Reading data from previous part
playlist_data <- readRDS("playlist_data.rds")

# Calculating count of songs by release year
year_count <- playlist_data %>%
  mutate(release_date = mdy(album_release_date)) %>%
  filter(!is.na(release_date)) %>%
  mutate(release_year = year(release_date)) %>%
  group_by(release_year) %>%
  summarise(song_count = n())

# Bar plot of song count by release year
ggplot(year_count, aes(x = release_year, y = song_count)) +
  geom_bar(stat = "identity", fill = "#5e1205") +
  labs(title = "Number of Songs Released per Year",
       subtitle = "Count of songs released based on year",
       x = "Release Year",
       y = "Count") +
  theme_bw() +
  theme(plot.title = element_text(size = 16, face = "bold"),
        axis.title = element_text(size = 14),
        axis.text.x = element_text(angle = 0, hjust = 1),  # Set angle = 0
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())


# Saving visualization as a PNG
ggsave("song_count.png", width = 8, height = 5, units = "in")

# Creating something from previous modules
# Compare album_release_date and ranking

album_date <- as.Date(playlist_data$album_release_date, format = "%B %d, %Y")
album_date2 <- format(album_date, "%Y")

ggplot(playlist_data, aes(y = album_date2, x = ranking)) +
  geom_bar(stat = "identity", fill = "#192fbf") +
  labs(title = "Song Ranking based on Album Release Year",
       y = "Album Release Date (Year)", x = "Ranking") +
  theme_minimal() +
  theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        plot.background = element_rect(fill = "#c3e3e1")) 

ggsave("year.png", width = 8, height = 5, units = "in")

