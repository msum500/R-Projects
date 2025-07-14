library(tidyverse)
library(gganimate)
library(stringr)
library(ggplot2)

# reading data
email_data <- read.csv("my_emails.csv")

# Looking at what columns the data contains
email_data %>% glimpse()

# Manipulating data to find number of emails on each day
day_count <- email_data %>% 
  group_by(email_day) %>%
  summarise(no_emails = n()) %>%
  arrange(match(email_day, c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))) %>%
  slice(1:(n() - 1))

# Finding emails per months
month_count <- email_data %>% 
  group_by(email_month) %>%
  summarise(count = n()) %>%
  slice(1:(n() - 1))

# Creating visualisaitons using ggplot2
day_count %>% 
  ggplot() +
  geom_bar(aes(x = email_day, y = no_emails, fill = email_day)) # Realising geom_bar doesn't work with this data.

# Adding color palette to the plot and using geom_col instead.
count_plot <- day_count %>% 
  ggplot() +
  geom_col(aes(x = email_day, y = no_emails, fill = email_day)) + 
  scale_fill_manual(values = c("red", "orange", "yellow", "green", "blue", "purple", "violet")) + 
  labs(title = "Number of emails received per day of the week", x = "Day of the Week", y = "count", fill = "Day of the week")

# Re-ordering the plot and removing the legend
ordered_plot <- day_count %>% 
  ggplot() +
  geom_col(aes(x = reorder(email_day, -no_emails), y = no_emails, fill = email_day)) + 
  scale_fill_manual(values = c("red", "orange", "yellow", "green", "blue", "purple", "violet")) + 
  theme(legend.position = "none") +
  labs(title = "Number of emails received per day of the week", x = "Day of the Week", y = "count", 
       fill = "Day of the week", subtitle = "Descending order in number of emails")

# Creating a month plot
month_plot <- month_count %>% 
  ggplot() +
  geom_col(aes(x = reorder(email_month, -count), y = count, fill = email_month)) + 
  scale_fill_manual(values = c("red", "orange", "yellow", "green", "blue", "purple", "violet")) + 
  theme(legend.position = "none") +
  labs(title = "Number of emails received per month", x = "Month", y = "count", 
       fill = "Month", subtitle = "Descending order in number of emails")

# Saving the plots
ggsave("count_plot.png", count_plot)
ggsave("ordered_plot.png", ordered_plot)
ggsave("month_plot.png", month_plot)

# Finding what subject my emails are from (stats or not) and the hour it was sent
subject <- email_data %>% 
  mutate(email_subject = case_when(
    str_detect(email_subject, "STATS") ~ "Stats",
    TRUE ~ "Other"
  )) %>%
  group_by(email_subject, email_hour) %>%
  summarise(count=n()) %>%
  arrange(email_subject) 

# Removing the last row that had NA as the subject
subject %>% slice(1:(n() - 1))

# Creating a static plot
subject_trend <- subject %>%
  ggplot() +
  geom_line(aes(x = email_hour, y = count, color = email_subject)) + 
  labs(title = "Number of emails that were the subject stats or other by the hour", x = "Hour", y = "count", color = "Subject")

# Animating the plot
animated_plot <- subject_trend + 
  transition_reveal(email_hour)

# Trying to create an animated dot plot
subject_trend2 <- subject %>%
  ggplot() +
  geom_dotplot(aes(x = email_hour, y = count, color = email_subject), size = 3) +
  labs(title = "Number of emails that were the subject stats or other by the hour",
       x = "Hour", y = "Count", color = "Subject") +
  theme_bw()

animated_plot2 <- subject_trend2 +
  transition_reveal(email_hour)

# Saving the GIF
anim_save("animated_plot.gif", animated_plot)
anim_save("animated_dot.gif", animated_plot2)
