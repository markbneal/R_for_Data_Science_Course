#Workshop 13

# Three powerful ideas for easily working with large numbers of models
#1 Use many simple models for complex datasets
#2 Use list-columns to store arbitrary data 
#3 Use Broom to turn models into tidy data

# Demonstrate workflow with life expectancy data

# Then examine compnents of workflow
# list-columns
# creating list-columns
# simplifying list columns
# making tidy (model) data with broom

#Prereqs
library(tidyverse)
library(modelr)

#Gapminder
install.packages("gapminder")
library(gapminder)
gapminder
?gapminder

# This is to rebase to year 1982 (which is close to middle of data)
# for q1 of Exercises 
# gapminder <- gapminder %>% 
#   mutate(year = year - 1982)

ggplot(gapminder, aes(x = year, y = lifeExp, group = country))+
  geom_line(alpha = 1/3)

nz <- gapminder %>% 
  filter(country == "New Zealand")
nz

#Plot raw data
ggplot(nz, aes(x = year, y = lifeExp))+
  geom_line()

nz_mod <- lm(lifeExp ~ year, data = nz)

#plot trend
nz %>% add_predictions(nz_mod) %>% 
  ggplot(aes(x = year, y = pred)) +
    geom_line() +
    ggtitle("linear trend")

#plot residuals (remaingn pattern?)
nz %>% add_residuals(nz_mod) %>% 
  ggplot(aes(x = year, y = resid))+
    geom_line() +
    ggtitle("remaining pattern")

#nested data

by_country <- gapminder %>% 
  group_by(country, continent) %>% 
  nest()
by_country

#Afghanistan's data
by_country$data[[1]]

#list columns

#base code as per book
country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}

#code to do quadratic as per q1 in exercises
# country_model <- function(df) {
#   lm(lifeExp ~ year + I(year^2), data = df)
# }

models <- map(by_country$data, country_model)
models
#This was a shitty idea, models are a separate object to our data

#better idea, keep data and models together

by_country <- by_country %>% 
  mutate(model = map(data, country_model))
by_country

by_country %>% 
  filter(continent == "Europe")

#Unnesting
#add residuals
by_country <- by_country %>% 
  mutate(resids = map2(data, model, add_residuals))
by_country

resids <- unnest(by_country, resids)
resids

#plot now we have a "normal" dataframe/tibble
resids %>% 
  ggplot(aes(x = year, y = resid))+
    geom_line(aes(group = country), alpha = 1/3) +
    geom_smooth(se = FALSE)

#show by continent
resids %>% 
  ggplot(aes(x = year, y = resid))+
    geom_line(aes(group = country), alpha = 1/3) +
    facet_wrap( ~ continent)

# model quality
library(broom)
glance(nz_mod)

#Show me for all the models!
glance <- by_country %>% 
  mutate(glance = map(model, glance)) %>% 
  unnest(glance) %>% 
  select(-c(data, model, resids)) #optional extra to remove list columns if we want

glance %>% 
  arrange(r.squared)

glance %>% 
  ggplot(aes(x = continent, y = r.squared))+
    geom_jitter(width = 0.5)

bad_fit <- filter(glance, r.squared < 0.25)
bad_fit

gapminder %>% 
  semi_join(bad_fit, by = "country") %>% 
  ggplot(aes(x = year, y = lifeExp, colour = country))+
    geom_line()

#Ex 25.2.5
#q1
median(gapminder$year)

#25.3 list columns

tribble(
  ~x, ~y,
#----#-----
1:3, "1, 2",
3:5, "3, 4, 5"
  )

# List-columns are most useful as intermediate data structures 

# Three parts to an effective list-column pieplien (or workflow)
#1 create the list-column (1. nest(), 2. Summarise, 3. Mutate)
#2 create other intermediate list-columns, 
#     (using existing list columns + map, map2, pmap)
#3 Simplify back to a vector or data frame

#25.4 Creating list-columns
#1 nesting (we did this already above)
gapminder %>% 
  group_by(country, continent) %>% 
  nest()

#without grouping (Why?)
gapminder %>% 
  nest(data = c(year:gdpPercap))

#2 from vectorised functions

#i.e. some function that takes a atomic vector and returns a list
# e.g. string operations

df <- tribble(
  ~x1,
  #----
  "a,b,c",
  "d,e,f,g"
)
df

library(stringr)

df %>% 
  mutate(x2 = str_split(x1, ",")) %>% 
  unnest()

# look up tidyr::separate_rows()

#use map to create a list-column

sim <- tribble(
  ~f,        ~params,
  #---------#--------
  "runif",   list(min = -1, max = 1),
  "rnorm",   list(sd = 5)
)
sim

sim %>% mutate(simulated_data = invoke_map(f, params, n = 10))


#3 from multivalued summary

?quantile

mtcars %>% 
  group_by(cyl) %>%
  summarise(q = quantile(mpg))
#works, but not super-helpful

#let's store in a list
mtcars %>% 
  group_by(cyl) %>%
  summarise(q = list(quantile(mpg)))

probs <- c(0.01, 0.25, 0.5, 0.75, 0.99)
mtcars %>% 
  group_by(cyl) %>%
  summarise(p = list(probs), 
            q = list(quantile(mpg, probs))) %>% 
  unnest(c(p,q))

#From a named list

#to make a data frame, one column can contain the elements, 
# and one column can contain the list.
# useful because we want to iterate over combinations of 
# element and list

# Use tibble::enframe to make a dataframe like this

x <- list(
  a = 1:5,
  b = 3:4,
  c = 5:6
)
x

df <- enframe(x)
df

df %>% 
  mutate(smry = map2_chr(name, value, 
                         ~ str_c(.x, ": ", .y[1]))
   
              )

#Ex 25.4.5


# 25.5 Simplifying list columns

# two approaches
#1 get single value with mutate and map
#2 use unnest, repeat if necessary

# list to vector (approach 1)
df <- tribble(
  ~x,
  #----
  letters[1:5],
  1:3,
  runif(5)
)
df

df %>% mutate(
  type = map_chr(x, typeof),
  length = map_int(x, length)
)

# unnesting (approach 2)

tibble(x = 1:2, y = list(1:4, 1)) %>% 
  unnest()

#Ex 25.5.3

#25.6 Tidy data with broom

#Three tools for turning models into tidy dataframes
#1 broom::glance(model) returns row for each model,
#                          column is model summary value
#                          e.g model quality metric like r2
#2 broom::tidy(model) returns row for each coefficient,
#                          column is info about estimate or var
#3 broom::augment(model, data) returns a row for each obs in data
#                          column is info like residuals and 
#                          influence statistics

glance(nz_mod)
tidy(nz_mod)
augment(nz_mod, nz) %>% 
  arrange(.cooksd)
