# Workshop 2

# Intro stuff ####----------------------------------------

library(tidyverse)
#install.packages("nycflights13")
library(nycflights13)

1 / 200 * 30

(59 + 73 + 2) / 3

sin(pi / 2)
?sin

x <- 3 * 4
x

y <- 5
z <- 3

# i_use_snake_case
# otherPeopleUseCamelCase
# some.people.use.periods
# And_janE_kaY_RENOUNCES.Convention

this_is_a_really_long_name <- 2.5

this_is_a_really_long_name

r_rocks <- 2 ^ 3

r_rock

R_rocks



# function_name(argument1 = val1, argument2 = val2, ...)

seq(1,10)

x <- "Hello world"
#x

my_variable <- 10
my_varlable




ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)

filter(diamonds, carat > 3)

diamonds

# three variable ggplot
# www.link.i.used.com/answer


# Data transformation ####--------------------------------------

flights

?flights

view(flights)

flights <- flights

# dplyr

filter()

arrange()

select()

mutate()

summarise()

group_by()

jan_1 <- filter(flights, month == 1, day == 1)

dec_25 <- filter(flights, month == 12, day == 25)
dec_25


filter(flights, month == 1)


sqrt(2) ^ 2 == 2

near(sqrt(2) ^ 2, 2)


#  & AND
# | OR
# ! NOT


filter(flights, month == 11 | month == 12)

#filter(flights, month == (11 | 12)) #not what we expected (or hoped for)

filter(flights, month %in% c(11,12))

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter_1 <- filter(flights, arr_delay <= 120 & dep_delay <= 120)
filter_2 <- filter(flights, arr_delay <= 120, dep_delay <= 120)

identical(filter_1, filter_2)


NA > 5

10 == NA

NA + 10
NA / 2

NA == NA

x <- NA

y <- NA

x == y

is.na(x)


df <- tibble(x = c(1, NA, 3))
df

filter(df, x > 1)

filter(df, is.na(x) | x > 1)

#ex 5.2.4

#1
filter(flights, arr_delay >= 120)

#2
filter(flights, dest == "IAH" | dest == "HOU")

#3
unique(flights$carrier)
filter(flights, carrier %in% c("UA", "AA", "DL"))

#4
filter(flights, month %in% c(7,8,9))
filter(flights, month %in% c(7:9))

?between()

filter(flights, between(month, 7,9))

# arrange

arrange(flights, year, month, day)

arrange(flights, desc(dep_delay))


# Ex 5.3.1
# q1
df <- tibble(x = c(1, NA, 3))
df
arrange(df, x)

arrange(df, desc(x))

arrange(df, desc(is.na(x)))

#q2
arrange(flights, desc(arr_delay))

#earlist in the day
arrange(flights, dep_time)

#earliest compared to planned departure
arrange(flights, dep_delay)


#Select
select(flights, year, month, day)

select(flights, year:day)

select(flights, -(year:day))

# starts_with("test")
# ends_with("xyz")
# contains("blah")
# matches("(.)\\1") #Regular expression

flights <- rename(flights, tail_num = tailnum)

select(flights, tail_num, everything())

# ex 5.4.1
#q2
select(flights, month, year, month)

#q4
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
vars

select(flights, any_of(vars))

#select(other_dataset,  any_of(vars))

select(flights, contains("TIME"))
flights

?select

select

#mutate

flights_sml <- select(flights, 
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60,
       hours = air_time / 60,
       gain_per_hour = gain / hours)


x <- 1:10
x  

lag(x)  
dplyr::lead(x)  

cumsum(x)

# grouped summaries

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


#copy from text

#grouping
by_dest <- group_by(flights, dest)

#summarising
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
#> `summarise()` ungrouping output (override with `.groups` argument)

# filtering
delay <- filter(delay, count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'


delays <- flights %>% 
  group_by(dest) %>% 
  summarise(count = n()
            ) %>% 
  filter(count >20, dest != "HNL")


