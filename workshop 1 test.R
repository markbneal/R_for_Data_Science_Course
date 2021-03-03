# Workshop 1 (week 1)
# R4DS, Ch1, Data Visualisation with ggplot


#and it works! test
s <- livecode::serve_file(bitly=FALSE) 
system(paste0("c:\\ngrok http ", s$url), wait = FALSE, invisible = FALSE,
       show.output.on.console = FALSE, minimized = FALSE)
#http://74eb97179e14.ngrok.io

#https://rpubs.com/markbneal/732217


library(tidyverse)

mpg

?mpg

ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy))


ggplot(data = mpg) +
  geom_point(mapping = aes(x=cyl, y = hwy, colour = displ))

ggplot(data = mpg) +
  geom_point(mapping = aes(x=drv, y = class, colour = class))

?geom_point()

vignette("ggplot2-specs")
?diamonds
diamonds

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop), group =1))
