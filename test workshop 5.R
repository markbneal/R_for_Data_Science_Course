#test workshop 5

library(tidyverse)

table1 <- tribble(
~country,      ~year, ~cases, ~population,
#---------------------------------------
"Afghanistan",  1999,    745,   19987071,
"Afghanistan",  2000,   2666,   20595360,
"Brazil",       1999,  37737,  172006362,
"Brazil",       2000,  80488,  174504898,
"China",        1999, 212258, 1272915272,
"China",        2000, 213766, 1280428583
)

write_csv(table1, "table1.csv")

table2 <- tribble(
  ~country,      ~year,  ~type,          ~count,
  #---------------------------------------------
  "Afghanistan",  1999,  "cases",             745,
  "Afghanistan",  1999,  "population",   19987071,
  "Afghanistan",  2000,  "cases",            2666,
  "Afghanistan",  2000,  "population",   20595360,
  "Brazil",       1999,  "cases",           37737,
  "Brazil",       1999,  "population",  172006362,
  "Brazil",       2000,  "cases",           80488,
  "Brazil",       2000,  "population",  174504898,
  "China",        1999,  "cases",          212258,
  "China",        1999,  "population", 1272915272,
  "China",        2000,  "cases",          213766,
  "China",        2000,  "population", 1280428583
)

write_csv(table2, "table2.csv")

table3 <- tribble(
  ~country,      ~year, ~rate,
  #---------------------------------------
  "Afghanistan",  1999,    "745/19987071",
  "Afghanistan",  2000,   "2666/20595360",
  "Brazil",       1999,  "37737/172006362",
  "Brazil",       2000,  "80488/174504898",
  "China",        1999, "212258/1272915272",
  "China",        2000, "213766/1280428583"
)
write_csv(table3, "table3.csv")


table4a <- tribble( #cases
  ~country,      ~`1999`, ~`2000`,
  #---------------------------------------
  "Afghanistan",    745,   2666,
  "Brazil",       37737,  80488,
  "China",       212258, 213766
)
write_csv(table4a, "table4a.csv")

table4b <- tribble( #population
  ~country,      ~`1999`, ~`2000`,
  #---------------------------------------
  "Afghanistan",    19987071,   20595360,
  "Brazil",        172006362,  174504898,
  "China",        1272915272, 1280428583
)
write_csv(table4b, "table4b.csv")


stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

??names_ptypes
?pivot_longer


people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
people %>% pivot_wider(names_from = names, values_from = values)


preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

preg %>% pivot_longer(cols = c("male", "female"), names_to = "gender", values_to = "values") %>% 
  pivot_wider(names_from = pregnant, values_from = values)


tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))

?unite
?extract
