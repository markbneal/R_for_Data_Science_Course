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
  ~country,      ~year, ~`1999`, ~`2000`,
  #---------------------------------------
  "Afghanistan",  1999,    745,   2666,
  "Brazil",       1999,  37737,  80488,
  "China",        1999, 212258, 213766
)
write_csv(table4a, "table4a.csv")

table4b <- tribble( #population
  ~country,      ~year, ~`1999`, ~`2000`,
  #---------------------------------------
  "Afghanistan",  2000,   19987071,   20595360,
  "Brazil",       2000,  172006362,  174504898,
  "China",        2000, 1272915272, 1280428583
)
write_csv(table4b, "table4b.csv")
