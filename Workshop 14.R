#Workshop 14

library(tidyverse)

#install.packages("ggrepel") #once only if you don't already have it
library(ggrepel)

#install.packages("viridis")
library(viridis)

#labels

#example with title
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size")

#example with subtitle and caption added
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size",
       subtitle = "Two seaters (sports cars) are an exception because of their light weight",
       caption = "Source: fueleconomy.gov")

#example with better x, y and colour labels
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(x = "Engine displacement (L)",
       y = "Highway fuel economy (mpg)",
       colour = "Car Type")

#Example with scientic notation
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(x = quote(sum(x[i]^2, i==1, n)),
       y = quote(alpha + beta + frac(delta, theta)),
       colour = "Car Type")
?plotmath

#28.3 Annotations

#geom_text(), with label = ...
#where do labels come from?
#1 tibble
#2 

best_in_class <- mpg %>% 
  group_by(class) %>% 
  filter(row_number(desc(hwy)) == 1)

#example with labels on points
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)
#we don't like the overlapping

#switch to geom_label and use nudge to move away from data point
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_label(aes(label = model), data = best_in_class, 
             nudge_y = 2, alpha = 0.5)
#still not happy with overlap, and difficult to identify point

#use ggrepel with identifier for the point
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)

#How could we direct label to remove legend (Mark dislikes legends)
#create tibble to locate the class averages to position on plot
class_avg <- mpg %>% 
  group_by(class) %>% 
  summarise(displ = median(displ),
            hwy = median(hwy))
class_avg

ggplot(mpg, aes(x = displ, y = hwy, colour = class))+
  ggrepel::geom_label_repel(aes(label = class),
                            data = class_avg,
                            size = 6,
                            label.size = NA,
                            segment.colour = NA)+
  geom_point()+
  theme(legend.position = "none")


# single label (still requires data frame)
#lets put it in the top right corner where there is space (used data)
label_df <- mpg %>% 
  summarise(displ = max(displ),
            hwy = max(hwy),
            label = "Increasing engine size is \nrelated to decreasing fuel economy")
label_df

ggplot(mpg, aes(x = displ, y = hwy))+
  geom_point() +
  geom_text(aes(label = label), data = label_df, 
            vjust = "top", hjust = "right")

#Put it right on the border
label_df <- tibble(displ = Inf,
                hwy = Inf,
                label = "Increasing engine size is \nrelated to decreasing fuel economy"
)

ggplot(mpg, aes(x = displ, y = hwy))+
  geom_point() +
  geom_text(aes(label = label), data = label_df, 
            vjust = "top", hjust = "right")

#above we manually did the line break (/n)
#alternative with stringr
"Increasing engine size is related to decreasing fuel economy" %>% 
  stringr::str_wrap(width = 40) %>% 
  writeLines()

#ggpmisc #package for putting equations (of regression lines) on the plot

#Other geoms to improve your plot

#Ex 28.3.1
#q2
?annotate
p <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
p
p + annotate("text", x = 4, y = 25, label = "Some text")
p + annotate("text", x = 4, y = 25,
             label = "paste(italic(R) ^ 2, \" = .75\")", parse = TRUE)

#q3
#example with labels on points, and facet
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)+
  facet_wrap(~cyl)

#q4
?geom_label

#q5
?arrow

#28.4 Scales
#What you type
ggplot(mpg, aes(x = displ, y = hwy))+
  geom_point(aes(colour = class))

#The scales ggplot adds automoatically
ggplot(mpg, aes(x = displ, y = hwy))+
  geom_point(aes(colour = class)) +
  scale_x_continuous()+
  scale_y_continuous()+
  scale_colour_discrete()

# Why override defaults?
#1 tweak parameter of default scale (eg change breaks) 
#2 replace scale altogether (eg log)

#28.4.1 Axis ticks and legends

#breaks controls position of ticks
ggplot(mpg, aes(x= displ, y = hwy)) +
  geom_point()+
  scale_y_continuous(breaks = seq(15, 40, by = 5))

ggplot(mpg, aes(x= displ, y = hwy)) +
  geom_point()+
  scale_y_continuous(breaks = seq(15, 40, by = 5),
                     labels = letters[1:6])

ggplot(mpg, aes(x= displ, y = hwy)) +
  geom_point()+
  scale_y_continuous(labels = NULL)

# can use breaks and labels to control legends
# Together, Axes and legends are called guides


#use case of few observations, make scale match observations
presidential %>% 
  mutate(id = 33 + row_number()) %>% 
  ggplot(aes(x = start, y = id)) +
    geom_point()+
    geom_segment(aes(xend = end, yend = id)) +
    scale_x_date(NULL, breaks = presidential$start, 
                 date_labels = "'%y")
#date_breaks takes a string like "2 days"


#28.4.2 Legend layout

base <- ggplot(mpg, aes(x = displ, y = hwy))+
          geom_point(aes(colour = class))
base

base + theme(legend.position = "top") # bottom, left or right also options
base + theme(legend.position = "none")

#to control individual legends, use guides
# here we made the legend on one row, 
# and override the alpha and size to improve legend
ggplot(mpg, aes(x = displ, y = hwy))+
  geom_point(aes(colour = class), alpha = 0.2)+
  geom_smooth(se = FALSE)+
  theme(legend.position = "bottom") +
  guides(colour = guide_legend(nrow = 1, 
                               override.aes = list(size = 4, alpha = 0.5)))


#28.4.3 Replacing a scale

ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d()

#log transform
ggplot(diamonds, aes(x = log10(carat), y = log10(price))) +
  geom_bin2d()
#this sucks because i have to think in log terms

#log transform on scales instead
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d() +
  scale_x_log10()+
  scale_y_log10()

#custom colour

ggplot(mpg, aes(x = displ, y = hwy))+
  geom_point(aes(colour = drv))

#colour blind friendly
ggplot(mpg, aes(x = displ, y = hwy))+
  geom_point(aes(colour = drv)) +
  scale_colour_brewer(palette = "Set1")

#add redundant sahpe aes (eg for B&W - I'm looking at you JDS)
ggplot(mpg, aes(x = displ, y = hwy))+
  geom_point(aes(colour = drv, shape = drv)) +
  scale_colour_brewer(palette = "Set1")

#make custom colours for presidential parties
presidential %>% 
  mutate(id = 33 + row_number()) %>% 
  ggplot(aes(x = start, y = id, colour = party)) +
  geom_point()+
  geom_segment(aes(xend = end, yend = id)) +
  scale_colour_manual(values = c(Republican = "red", Democratic = "blue"))

?scale_fill_gradient #note, aes needs to match the object (or part of the object)
?scale_colour_gradient


#example with viridis

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)
ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed()

ggplot(df, aes(x, y)) +
  geom_hex() +
  viridis::scale_fill_viridis() +
  coord_fixed()


#ex xxx.xx.xx
#q1
ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_fill_gradient(low = "white", high = "red") +
  coord_fixed()

#q4
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(colour = cut), alpha = 1/20)
#use override.aes as above

