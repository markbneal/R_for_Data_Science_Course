# Workshop 6

library(tidyverse)
library(nycflights13)

#5 related tables
flights

airlines
?airlines

airports

weather

planes

#keys

planes %>% 
  count(tailnum) %>% 
  filter(n > 1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

flights

flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)

flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)

#Ex 13.3.1
#q1
flights %>% 
  mutate(row_number = row_number()) %>% 
  select(row_number, everything())

#q2
#install.packages("Lahman")
library(Lahman)

install.packages("babynames")

# Mark fixing a specific issue on my computer
# tempdir()
# # [1] "C:\Users\XYZ~1\AppData\Local\Temp\Rtmp86bEoJ\Rtxt32dcef24de2"
# dir.create(tempdir())

library(babynames)
?babynames
babynames

diamonds
?diamonds

# mutating join

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

# understanding joins

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)
x
y

x %>% inner_join(y, by = "key")


x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
x
y

x %>% left_join(y, by = "key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~Key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)

x %>% left_join(y)

#defining key columns
flights2 %>% left_join(weather)

planes

flights2 %>% left_join(planes, by = "tailnum")

#eg if same variable is called differently
# flights2 %>% left_join(planes, by = c("Days in milk", "DIM")


flights2 %>% 
  left_join(airports, by  = c("dest" = "faa"))

flights2 %>% 
  left_join(airports, by  = c("origin" = "faa"))

#Ex 13.4.6
#q1
# install.packages("maps")

airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

delays <- flights %>%
  group_by(dest) %>% 
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))
delays

airports_with_delay <- airports %>% 
  left_join(delays, by = c("faa" = "dest"))
airports_with_delay

airports_with_delay %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(x = lon, y = lat, colour = avg_delay, size = avg_delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

#q3
planes

delays_by_plane <- flights %>%
  group_by(tailnum) %>% 
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))
delays_by_plane

delays_by_plane %>% 
  left_join(planes, by = "tailnum") %>% 
  ggplot(aes(x = year, y = avg_delay))+
  geom_jitter(alpha = 0.2)+
  geom_smooth()+
  coord_cartesian(xlim = c(1970,2013), ylim = c(-80, 100))

#filtering joins

top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

flights %>% filter(dest %in% top_dest$dest)

flights %>% semi_join(top_dest)


flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(tailnum, sort = TRUE)

flights %>% 
  left_join(planes, by = "tailnum") %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(carrier, sort = TRUE)
?flights


#Ex 13.5.1

worst_delay <- flights %>% 
  group_by(year, month, day) %>% 
  summarise(avg_delay = mean(arr_delay, na.rm= TRUE)) %>% 
  mutate(two_day_delay = avg_delay + lead(avg_delay)) %>% 
  arrange(desc(two_day_delay)) %>% 
  head(1)
worst_delay

worst_weather_maybe <- weather %>% semi_join(worst_delay)


airports %>% count(alt, lon) %>% filter(n > 1)

## Strings

string1 <- "this is a string"
string2 <- 'this is also a string'
string3 <- 'i need a "quote" in this string'
string4 <- 'i need a "quote" in this string'
string5 <- "i need a 'quot' in this string"
# string6 <- "no closing

#"*"

double_quote <- "\""
single_quote <- '\''
back_slash <- "\\"
two_back_slashes <- "\\\\"
two_back_slashes

writeLines(two_back_slashes)

# \n #new line in text
# \t #tab

x <- "\u00b5"
x

# string length
str_length(c("a", "R for data science", NA))


str_c("x","y")

str_c("x", ",", "y")

str_c("x","y", sep = ",")

str_c("prefix-", 1:3, "-suffix")

#subset
x <- c("Apple", "Banana", "Pear")

str_sub(x, 1, 3)
