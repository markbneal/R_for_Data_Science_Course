library(nycflights13)
library(tidyverse)

filter(flights, arr_delay <= 120 & dep_delay <= 120)

#filter(flights, arr_delay <= 120 | dep_delay <= 120)

identical (filter(flights, arr_delay <= 120, dep_delay <= 120),  filter(flights, arr_delay <= 120 & dep_delay <= 120))



(11|12)+1
NA^0
1^0

NA | TRUE
NA | NA
NA | FALSE

FALSE & NA
TRUE & NA
NA * 0

df <- tibble(x=c(5,2,NA))

arrange(df)

arrange(df, desc(is.na(x)))

# df %>% 
#   select(x) %>% 
#   is.na() %>% 
#   arrange(desc(.))
  
select(flights, dep_delay)
select(flights, dep_delay, dep_delay)


vars <- c('year', 'month', 'day')
select(flights, any_of(vars))

select(flights, contains("TIME"))

select(flights, dep_time)

1:3
1:10

?count
