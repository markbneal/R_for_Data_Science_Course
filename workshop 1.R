# Workshop 1, R for data science 2021


#install.packages("tidyverse") #once only, if required

library(tidyverse)

# Slides
#https://rpubs.com/markbneal/732217

## Instructor only!
# s <- livecode::serve_file(bitly=FALSE) 
# system(paste0("c:\\ngrok http ", s$url), wait = FALSE, invisible = FALSE,
#        show.output.on.console = FALSE, minimized = FALSE)
# http://f2373f871a9c.ngrok.io 

mpg

?mpg

# We are going to make an awesome plot for you
ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(mpg) +
  geom_point(aes(displ,hwy))

# ggplot(data = <DATA>) +
#    <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

#questions 3.2.4

#1.

ggplot(data = mpg)

#2.
mpg

#3
?mpg

#4
ggplot(data =  mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

#5
ggplot(data =  mpg) +
  geom_point(mapping = aes(x = class, y = drv))


# Adding a third variable
ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class))

ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# specify manually the aes
ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), colour = "blue")


mpg
?mpg
# Questions 3.3.1
# 3
ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl, colour = cyl ))

ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, stroke = cyl, size = cyl ))

?geom_point

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)

ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, stroke = cyl, size = cyl), 
             shape = 21, colour = "black", fill = "white")

vignette("ggplot2-specs")

ggplot()

mpg


?mpg


ggplot(data =  mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, stroke = cyl, size = cyl ))

# facets
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap( ~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( . ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap( ~ cyl, nrow = 1)

# questions
#1

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap( ~ hwy, nrow = 2)

# 2
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

# 3
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( . ~ cyl)

#geometries
geom_point()
  
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))


ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, colour = drv), show.legend = FALSE)

# multiple geometries
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy)) 

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth() +
  geom_point() 

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth() +
  geom_point(mapping = aes(colour = class)) 

# stat transformations

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds

?geom_bar

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut, y = stat(prop), group = 1))

# overplotting

ggplot(data = mpg) +
  geom_point(mapping = aes( x = displ, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes( x = displ, y = hwy), position = "jitter")

ggplot(data = mpg) +
  geom_jitter(mapping = aes( x = displ, y = hwy))

ggsave("my_plot.png", width = 8, height = 5)

