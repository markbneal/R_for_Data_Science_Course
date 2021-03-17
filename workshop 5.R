# Workshop 5

library(tidyverse)

download.file("https://raw.githubusercontent.com/markbneal/R_for_Data_Science_Course/master/table1.csv",
              "table1.csv")
download.file("https://raw.githubusercontent.com/markbneal/R_for_Data_Science_Course/master/table2.csv",
              "table2.csv")
download.file("https://raw.githubusercontent.com/markbneal/R_for_Data_Science_Course/master/table3.csv",
              "table3.csv")
#4a and 4b fixed on github 18/3 - removed redundant column that shouldn't have been there
download.file("https://raw.githubusercontent.com/markbneal/R_for_Data_Science_Course/master/table4a.csv",
              "table4a.csv")
download.file("https://raw.githubusercontent.com/markbneal/R_for_Data_Science_Course/master/table4b.csv",
              "table4b.csv")

table1 <- read_csv("table1.csv")
table1
table2 <- read_csv("table2.csv")
table2
table3 <- read_csv("table3.csv")
table3
table4a <- read_csv("table4a.csv") #cases 
table4a
table4b <- read_csv("table4b.csv") #population
table4b

# calculate rate
table1 %>% mutate(rate = (cases / population) * 10000)

#count cases
table1 %>% count(year, wt = cases)
?count

# visualise changes over time
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), colour = "grey50") +
  geom_point(aes(colour = country))

table1

#longer
# table4a <- table4a %>% select(-year) # i fixed this in the github files
# table4a

#three parameters to pivot longer
#1. set of columns whose names are values (1999, 2000)
#2. variable to move column values to (year)
#3. name of variable to put column values in (cases)

tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), 
               names_to = "year",
               values_to = "cases")

# table4b <- table4b %>% select(-year) # i fixed this in the github files
# table4b

tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), 
               names_to = "year",
               values_to = "population")

left_join(tidy4a,tidy4b)

#wider
table2

#two parameters to pivot wider
#1. column to take the variable names from (type)
#2. column to take values from (count)

table2 %>% pivot_wider(names_from = type, 
                       values_from = count)

#Ex 12.3.3.
#q1
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

?pivot_longer

#q2

#q3
people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

#q4
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)


preg_longer <- preg %>% pivot_longer(cols = c("male", "female"), 
                      names_to = "gender", 
                      values_to = "values") 

preg_tidy <- preg_longer %>% 
  pivot_wider(names_from = pregnant, 
              values_from = values)
preg_tidy


# gender  yes(preg)  no(not preg)
#-------------------------------
# male
# females

# separate
table3

table3 %>% separate(col = rate, 
                    into = c("cases", "population"),
                    sep = "/",
                    convert = TRUE)

table5 <- table3 %>% separate(col = year, 
                    into = c("century", "year"),
                    sep = 2)

table5 %>% unite(col = new, century, year, sep = "")


#ex 12.4.3
#q1
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))


#missing values

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks
stocks %>% pivot_wider(names_from = year, 
                       values_from = return)

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment
treatment %>% fill(person, .direction = "up")
?fill


#who case study
who

who <- who

who1 <- who %>% 
  pivot_longer(
  cols = new_sp_m014:newrel_f65,
  names_to = "key",
  values_to = "cases",
  values_drop_na = TRUE
)
who1

who1 %>% count(key)

who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2

who3 <- who2 %>% 
  separate(col = key,
           into = c("new", "type", "sexage"), 
           sep = "_")
who3

who3 %>% count(new)

who4 <- who3 %>% 
  select(-new, -iso2, -iso3)
who4 <- who3 %>% 
  select(-c("new", "iso2", "iso3")) #alternative, still works
who4

who5 <- who4 %>% 
  separate(col = sexage, 
           into = c("sex", "age"),
           sep = 1)
who5
?who

who3 %>% count(country, iso2)


# For each country, year, and sex compute the total number of cases 
# of TB. Make an informative visualisation of the data.

who5 %>% filter(year == 2013) %>% 
  count(country, wt = cases )

tb_country_desc <- who5 %>% filter(year == 2013) %>% 
 group_by(country) %>%   
 summarise(sum_cases = sum(cases, na.rm=TRUE)) %>% 
 arrange(desc(sum_cases))

top_10 <- tb_country_desc$country[1:10]
top_10
  
who5_top_10 <- who5 %>% 
  filter( country %in% top_10) %>% 
  group_by(country, year, sex) %>% 
  summarise(sum_cases = sum(cases, na.rm = TRUE))
who5_top_10

ggplot(data = who5_top_10) +
  geom_line(aes(x = year, y = sum_cases, colour = sex)) +
  facet_wrap(~country)
