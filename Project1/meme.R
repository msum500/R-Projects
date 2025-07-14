# Loading the magick package
library(magick)

# Creating the upper text
text1 <- image_blank(width = 325,
                     height = 305,
                     color = "#000000") %>%
  image_annotate(text = "Me: Is this a Pigeon?",
                 color = "#FFFFFF",
                 size = 30,
                 font = "Impact",
                 gravity = "center")

# Creating the lower text
text2 <- image_blank(width = 325,
                     height = 305,
                     color = "#000000") %>%
  image_annotate(text = "My last two brain cells: \nNo, it's a chicken",
                 color = "#FFFFFF",
                 size = 30,
                 font = "Impact",
                 gravity = "center")

# Loading meme image
url <- image_read("https://i.imgflip.com/2cjr7j.jpg?a466224") %>%
  image_scale(340)

# Combining text with meme image - upper row
upper <- c(url, text1)
top_row <- image_append(upper)

# Combining text with meme image - lower row
lower <- c(image_flop(url), text2)
bottom_row <- image_append(lower)

# Combining upper with lower
meme <- c(top_row, bottom_row) %>%
  image_append(stack = TRUE) %>%
  image_scale(300)
meme

# Saving meme as PNG
meme %>% image_write("my_meme.png")
