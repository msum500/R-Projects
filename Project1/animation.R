#Loading magick package
library(magick)

# creating a vector for the counts
counts <- c("M", "ME", "MEO", "MEOW")

# Loading cat image
cat <- image_read("https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1280px-Cat03.jpg") %>%
  image_scale(300)

# creating each frame, where it is rotated and each letter of "MEOW" is added

frame1 <- image_rotate(cat, 90) %>% 
  image_annotate(text = counts[1], size = 80, gravity = "center") %>%
  image_scale(200) %>%
  image_extent("500x500")

frame2 <- image_rotate(cat, 180) %>% 
  image_annotate(text = counts[2], size = 80, gravity = "center") %>%
  image_scale(250) %>%
  image_extent("500x500")

frame3 <- image_rotate(cat, 270) %>%
  image_annotate(text = counts[3], size = 80, gravity = "center") %>%
  image_scale(300) %>%
  image_extent("500x500")
  
frame4 <- image_rotate(cat, 360) %>% 
  image_annotate(text = counts[4], size = 80, gravity = "center") %>%
  image_scale(350) %>%
  image_extent("500x500")

# putting the frames in order using a vector
frames <- c(frame1, frame2, frame3, frame4)

# creating an animation
animation <- image_animate(frames, fps = 1)
animation

# Saving gif as an image file
animation %>% image_write("my_animation.gif")