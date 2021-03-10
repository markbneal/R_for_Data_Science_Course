# Workshop 3 Exploratory data analysis 

library(tidyverse) 


ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut))

diamonds %>% 
  count(cut)


ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x=carat), binwidth = 0.5)

diamonds %>% 
  count(cut_width(carat, 0.5))


smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

?diamonds

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)


ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

?faithful


ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
?diamonds

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,50))

# xlim() # by itself will cut out data

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>% 
  arrange(y)
unusual

# Ex 7.3.4

#q1
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = x), binwidth = 0.5)
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = z), binwidth = 0.5)

#q2
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 50) +
  coord_cartesian(xlim = c(0,2000))
?geom_histogram

#q3 

diamonds %>% 
  filter(carat == 0.99) %>%  
  count(carat)


diamonds %>% 
  filter(carat == 1.00) %>%  
  count(carat)


#missing values

diamonds_filtered <- diamonds %>% 
  filter(between(y, 3, 20))

diamonds_missing <- diamonds %>% 
  mutate(y = ifelse( y < 3 | y > 20, NA, y ))


# show case_when example
diamonds_category <- diamonds %>% 
  mutate(size_category = case_when( y < 7  ~ "small",
                                    y > 14 ~ "large",
                                    TRUE ~ "medium" ))

diamonds_category

ggplot(data = diamonds_missing, mapping = aes(x = x, y = y)) +
  geom_point()

ggplot(data = diamonds_missing, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)


library(nycflights13)

flights %>% 
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100,
         sched_min  = sched_dep_time %% 100,
         sched_dep_time = sched_hour + sched_min / 60) %>% 
  ggplot(mapping = aes(sched_dep_time)) +
    geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

# covariation

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)


ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))


ggplot(data = diamonds, mapping = aes(x = price, y = ..density.. )) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()


# reorder

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()


ggplot(data = mpg, mapping = aes(x = reorder(class, hwy, FUN = median),
                                 y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = reorder(class, hwy, FUN = median),
                                 y = hwy)) +
  geom_boxplot() +
  coord_flip()

# Ex 7.5.1.1

#q1

flights %>% 
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100,
         sched_min  = sched_dep_time %% 100,
         sched_dep_time = sched_hour + sched_min / 60) %>% 
  ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

#q2
?diamonds

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point()
 
ggplot(data = diamonds, mapping = aes(x = clarity, y = price)) +
  geom_jitter() 

ggplot(data = diamonds, mapping = aes(x = cut, y = carat)) +
  geom_boxplot()


#q4

#install.packages("lvplot")
library(lvplot)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_violin()


# two categorical

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color)) +
  coord_flip()

diamonds %>% 
  count(color, cut) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
    geom_tile(mapping = aes(fill = n))

# two continuous

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point()

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point(alpha = 1/100)

ggplot(smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data=smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

ggplot(data=smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 4)))

# patterns
ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))

# ggplot2 calls

ggplot(faithful) +
  geom_point(aes(x = eruptions, y = waiting))

ggsave("my_plot.png")


getwd()

setwd("c:/my data/blah")


