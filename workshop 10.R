# workshop 10

#reducing code duplication 3 benefits
#1 easier to see intent of your code
#2 easier to respond to changes in requirements
#3 likely to have fewer bugs

# Two iteration paradigms
#1 imperative (e.g. for loops)
#2 functional programming 

library(tidyverse)

#For loops

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df

median(df$a)
median(df$b)
median(df$c)
median(df$d)


#loop has three components
#1 output
#2 sequence
#3 body

#output
output <- vector("double", ncol(df))
#sequence
for(i in seq_along(df)) {
  #body
  output[[i]] <- median(df[[i]])
}
output

#for(i in length(df)) #not as safe as seq_along()

#Ex 21.2.1
#q1.1
# compute mean of every column
mtcars

#output
output <- vector("double", ncol(mtcars))
#sequence
for(i in seq_along(mtcars)) {
  #body
  output[[i]] <- mean(mtcars[[i]], na.rm = TRUE)
}
output


#q1.2
#Determine the type of each column in nycflights13::flights.

#output
#get the output with number of columns

#sequence
#run for every column

#body
# median()
?type

#output
library(nycflights13)
output <- vector("character", ncol(flights))
#sequence
for(i in seq_along(flights)) {
  #body
  output[[i]] <- typeof(flights[[i]])
}
output

?vector
#q1.3
#Compute the number of unique values in each column of iris.
iris
output <- vector("double", ncol(iris))
#sequence
# unique(iris[[1]])
for(i in seq_along(iris)) {
  #body
  output[[i]] <- length(unique(iris[[i]]))
}
output

#Package tictoc for timing how long sonething takes

#for loop variations

#Four variations on the theme
#1 modify an existing object (instead of cretaing a new object)
#2 loop over names or values (instead of indices)
#3 handling output of unknown length
#4 handling sequences of unknown length

#modify existing object

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

#output
# same as input!
#sequence
for(i in seq_along(df)) {
  #body
  df[[i]] <- rescale01(df[[i]])
}
df

#unknown output length
means <- c(0, 1, 2)
means


out <- vector("list", length(means))

for (i in seq_along(means)) {
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)
#
str(unlist(out))
unlist(out)

#Ex21.3.5


a <- tribble(
  ~colA, ~colB,
  "a",   1,
  "b",   2,
  "c",   3
)

write_csv(a, "a.csv")

  
b <- tribble(
  ~colA, ~colB,
  "a",   1,
  "b",   2,
  "c",   3
)


write_csv(b, "b.csv")


files <- dir(path = "csvdata/", pattern = "\\.csv$", full.names = TRUE)
files

#output
out <- vector("list", length(files))
#sequence
for (i in seq_along(files)) {
  #body
  out[[i]] <- read_csv(files[[i]])
}
out

new_output <- rbind(out[[1]], out[[2]])
new_output

#for loops vs functionals
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df

# mean of every column with a for loop

#output
output <- vector("double", ncol(df))
#sequence
for(i in seq_along(df)) {
  #body
  output[[i]] <- mean(df[[i]])
}
output

col_mean <- function(dataframe) {
  #output
  output <- vector("double", ncol(dataframe))
  #sequence
  for(i in seq_along(dataframe)) {
    #body
    output[[i]] <- mean(dataframe[[i]])
  } 
  output
}

col_mean(df)
output

col_median <- function(dataframe) {
  #output
  output <- vector("double", ncol(dataframe))
  #sequence
  for(i in seq_along(dataframe)) {
    #body
    output[[i]] <- median(dataframe[[i]])
  } 
  output
}

col_sd <- function(dataframe) {
  #output
  output <- vector("double", ncol(dataframe))
  #sequence
  for(i in seq_along(dataframe)) {
    #body
    output[[i]] <- sd(dataframe[[i]])
  } 
  output
}

# f1 <- function(x) abs(x - mean(x)) ^ 1
# f2 <- function(x) abs(x - mean(x)) ^ 2
# f3 <- function(x) abs(x - mean(x)) ^ 3
# 
# f <- function(x, k) abs(x - mean(x)) ^ k

col_summary <- function(dataframe, fun) {
  #output
  output <- vector("double", ncol(dataframe))
  #sequence
  for(i in seq_along(dataframe)) {
    #body
    output[[i]] <- fun(dataframe[[i]])
  } 
  output
  
}

col_summary(df, mean)
col_summary(df, sd)

col_summary(flights, mean)

#purrr package

# The map functions

map() #gives you a list
map_lgl() #gives you a logical vecotr
map_int() #integer
map_dbl() #double precision number
map_chr() #character

map_dbl(df, mean)
map_dbl(df, sd)



df %>% map_dbl(mean)

col_summary()
map_*
# key differences
#1 speed (purrr functions in c)
#2 second argument (.f, the function) is flexible function, fomrula, etc
#3 Uses dotdotdot (...) to take abritrary number of arguments for the function

map_dbl(df, mean, na.rm = TRUE, trim = 0.5)

#4 map preserves names

z <- list(x = 1:3, y = 4:5)
z
map_int(z, length)

#shortcuts with .f
mtcars
unique(mtcars$cyl)

models <- mtcars %>% 
  split(.$cyl) %>% 
  map(function(df) lm(mpg ~ wt, data = df))
models

#one-sided formulas
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(~lm(mpg ~ wt, data = .))
models

models %>% 
  map(summary) %>% 
  map_dbl(~.$r.squared)

#Ex 21.5.3
#q1
#Compute the mean of every column in mtcars.
map_dbl(mtcars, mean)
#Determine the type of each column in nycflights13::flights.
map_chr(flights, typeof)
#Compute the number of unique values in each column of iris.
map(iris, unique) %>% 
  map(length)

iris %>% map_dbl(~ length(unique(.x)))

map_int(iris, n_distinct)

#dealing with failure

safely()
#returns two things
#1 result if it works (otherwise NULL)
#2 error if there was an error (otherwise NULL)

safe_log <- safely(log)
str(safe_log(10))
safe_log("a")

x <- list(1, 10, "a")
y <- x %>% map(safely(log))
str(y)

transpose(y)

#variations on the theme
# possibly() #safely with a default
# quietly() #captures printed output, messages and warnings

#mapping over multiple arguments
map2()
pmap()

mu <- list(5, 10, -3)
mu %>% 
  map(rnorm, n = 5) %>% 
  str()

sigma <- list(1, 5, 10)

map2(mu, sigma, rnorm, n = 5) %>% 
  str()

n <- list(1, 3, 5)

args1 <- list(n, mu, sigma)

args1 %>% 
  pmap(rnorm) %>% 
  str()

args2 <- list(mean = mu, sd = sigma, n = n)

args2 %>% 
  pmap(rnorm) %>% 
  str()

args3 <- tibble(mean = mu, sd = sigma, n = n)


params <- tribble(
  ~mean, ~sd, ~n,
  5,     1,  1,
  10,     5,  3,
  -3,    10,  5
)

# we looked above at changing arguments to the same function
# invoke_map allows you to change function as well

# Walk, allows you to capture "side-effects" in the middle of a pipeline.


#predicate functions
iris %>% 
  keep(is.factor) %>% 
  str()
iris

#reduce and accumulate

#applies dplyr acrosn n>2 objects
dfs <- list(
  age = tibble(name = "John", age = 30),
  sex = tibble(name = c("John", "Mary"), sex = c("M", "F")),
  trt = tibble(name = "Mary", treatment = "A")
)
dfs

dfs %>% reduce(full_join)

#intersection - what is in common?

vs <- list(
  c(1, 3, 5, 6, 10),
  c(1, 2, 3, 7, 8, 10),
  c(1, 2, 3, 4, 8, 9, 10)
)
vs

vs %>% reduce(intersect)
?reduce
