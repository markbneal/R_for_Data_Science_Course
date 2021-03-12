# test workshop 4

library(tidyverse)

mtcars

df <- data.frame(abc = 1, xyz = "a")
a <- df$x
class(a)

b <- df[ , "xyz"]
class(b)

c <- df[ , c("abc", "xyz")]
class(c)

var <- "abc"

df$var #doesn't work

df[[var]]


#q4

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying

annoying$`1`
annoying$1
annoying[ ,1]
annoying[ ,`1`]

ggplot(annoying) +
  geom_point(aes(x = `1`, y = `2`))

annoying2 <- annoying %>% 
  mutate(`3` = `1` * `2`)

annoying2b <- annoying %>% 
  mutate(`3` = 1 * 2)

annoying2 %>% 
  rename(one = `1`,
         two = `2`,
         three = `3`)

?enframe

a <- 1
a
class(a)
enframe(a)

??tibble.print

# Data import ####

dir.create("data")

download.file("https://raw.githubusercontent.com/hadley/r4ds/master/data/heights.csv", "data/heights.csv")

heights <- read_csv("data/heights.csv")


read_csv("a,b\n1,2\na,b")

str(parse_logical(c("TRUE", "FALSE", "NA")))
