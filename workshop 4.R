# Workshop 4

library(tidyverse)
library(nycflights13)

iris

as_tibble(iris)

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)


tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
  )
tb

tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
  )

flights <- flights

as.data.frame(flights)

#subsetting

df <- tibble(
  x = runif(5),
  y = rnorm(5)
  )
df

# extrat by name

df$x
set.seed(123)

df[["x"]]

df[[1]]


df %>% .$x
df %>% .[["x"]]

df$z

z1
z2
df$z

class(df)

df_as_dataframe <- as.data.frame(df)
class(df_as_dataframe)


#ex 10.5

#q1
mtcars
class(mtcars)
as_tibble(mtcars)

#q2
df <- data.frame(abc = 1, xyz = "a")
df
df$x

df_tibble <- as_tibble(df)
df_tibble$x

result <- df[ , "xyz"]
class(result)

df[ , c("abc","xyz")]
class(df[ , c("abc","xyz")])

#q3
var <- "xyz"

df_tibble

df_tibble$var
df_tibble[[var]]

#q4
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying$`1`

ggplot(data = annoying) +
  geom_point(aes(x = 1, y = 2))

annoying_2 <- annoying %>% 
  mutate(`3` = `2` / `1`)
annoying_2

?enframe

1:3
enframe(1:3)

rnorm(10000)

#Data import

read_csv()
?read_csv2
?read_fwf

dir.create("data")

#"https://raw.githubusercontent.com/hadley/r4ds/master/data/heights.csv"

download.file("https://raw.githubusercontent.com/hadley/r4ds/master/data/heights.csv",
              "data/heights.csv")

heights <- read_csv("data/heights.csv") 


read.csv()

data.table::fread()

#Ex 11.2.2
#q1
read_delim("file.psv","|")

#q2
?read_csv

#q3
?read_fwf

#q5
read_csv("a,b\n1,2,3\n4,5,6")

read_csv("a,b,c\n1,2\n1,2,3,4")

read_csv("a,b\n\"1")

read_csv("a,b\n1,2\na,b")

read_csv("a;b\n1;3")


#parse

# numbers
parse_double("1.23")
parse_double("1,23")
parse_double("1,23", locale = locale(decimal_mark = ","))


parse_number("$100")
parse_number("This cost $123.45")


parse_number("$123,456,789")
parse_number("123.456.789")
parse_number("123.456.789", locale = locale(grouping_mark = "."))

#characters
parse_character("donkey")

#factors

fruit <- c("apple", "banana")

parse_factor( c("apple", "banana", "bananana"), levels = fruit)


# dates
parse_datetime("2010-10-01T2010")


# 2-2-19

#parse a file

flights

write_csv(flights, "flights.csv")

write_rds(flights, "flights.rds")

my_flights <- read_rds("flights.rds")

#Homework

library(tidyverse)
distributions <- tibble(x = rnorm(10000), y = rnorm(10000))
distributions_plot <-  distributions %>% 
  mutate(z = x * y) %>% 
  ggplot() +
    geom_density(aes(x = z, y = ..density.. ))+
    coord_cartesian(xlim = c(-2,2))
distributions_plot 
