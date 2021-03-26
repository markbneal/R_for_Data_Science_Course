# Workshop 8

#pipes ####----------------------------------------

# %>% 
library(magrittr)

# Little bunny Foo Foo
# Went hopping through the forest
# Scooping up the field mice
# And bopping them on the head

foo_foo <- little_bunny()

hop()
scoop()
bop()

# 4 ways to code
#1 save each intermediate step as new object
#2 overwrite original object many times
#3 compose functions
#4 ues the pipe

#1 save intermediate
foo_foo_1 <- hop(foo_foo, through = forest)
foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
foo_foo_3 <- bop(foo_foo_2, on = head)


#2 overwrite
foo_foo <- hop(foo_foo, through = forest)
foo_foo <- scoop(foo_foo, up = field_mice)
foo_foo <- bop(foo_foo, on = head)

#3 function
bop(
  scoop(
    hop(foo_foo, through = forest),
    up = field_mice
  ), 
  on = head
)

#4 pipe

foo_foo %>% 
  hop(through = forest) %>% 
  scoop(up = field_mice) %>% 
  bop(on = head)

# Functions ####------------------------------------------


df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df


df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

x <- df$a

(x - min(x, na.rm = TRUE)) / 
  (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

rng <- range(x, na.rm = TRUE)
rng
rng[1] #min
rng[2] #max

(x - rng[1]) / (rng[2] - rng[1])

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(df$a)
rescale01(df$b)

# 3 key steps to making a function
#1 name for the function
#2 arguments (data, other arguments)
#3 code that you stick inside the function

rescale01(c(-10, 0, 10))
rescale01(c(-10, 0, 10, NA))
rescale01(c(-10, 0, 10, NA, Inf))


#Ex19.2.1
#q2
x

mean(is.na(x))

prop_na <- function(x) {
  mean(is.na(x))
}

prop_na(x)

y <- c(3,5,NA)

prop_na(y)



x / sum(x, na.rm = TRUE)

sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)

?sd


# function names
f()
my_awesome_function()
impute_missing()
imp_mis()

input_select()
input_checkbox()
input_text()

select_input()
checkbox_input()

library(tidyverse)
str_

#don't do this 
# T <- FALSE
# mean <- function(x) {sum(x)}

# Ex 19.3.1
#q1
check_prefix <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}
?substr

check_prefix("testing_this", "test")
check_prefix("testing_this", "bollocks")

# Conditional execution

if(condition) {
  # code to execute if true
} else {
  # code to execute when condition is false
}

# conditions
if (c(TRUE, FALSE)) {}
if (NA) {}

# if with Floating points not exactly equal, use near()

#multiple conditions

if (this) {
  #do that
} else if (that) {
  #do seomething else
} else {
  #third remaining alternative
}

switch()

cut()
?cut

#Ex 19.4.4
#q1
?`if`
?ifelse
?if_else

#q2
# Write a greeting function that says “good morning”, 
# “good afternoon”, or “good evening”, depending on the time of day. 
# (Hint: use a time argument that defaults to lubridate::now(). That will make it easier to test your function.)


# name is greeting
# Argument is time (date_time)
# code
library(lubridate)

morning_example <- ymd_hms("20200201 10:30:00")
morning_example

afternoon_example <- ymd_hms("20200201 12:01:00")
afternoon_example

evening_example <- ymd_hms("20200201 20:01:00")
evening_example

date_times <- as_tibble(c(morning_example, afternoon_example, evening_example))
date_times  
  
hour(morning_example) < 12
"good morning"
# hour(morning_example) < 17
# "good afternoon"
# else
# "good evening"

greeting <- function(x) {
  if (hour(x) < 12) {
    return("good morning")
  } else if (hour(x) < 17) {
    return("good afternoon")
  } else {
    return("good evening")
  }
}

?if_else

greeting(morning_example)
greeting(afternoon_example)
greeting(evening_example)
greeting(NA)


#Function arguments

log() #data x, detail base 2, n , e?
mean() #data x, detail na.rm True or false
str_c() # data multiple strings, detail sep
conf_int <- function(x, conf = 0.05)
  
  
hollys_function <- function(x, na.rm = TRUE) {}

aes(x = mpg, y = eff)

#checking values
wt_mean <- function(x, w) {
  if ( length(x) != length(w)) {
    stop("x is different length - you dum dum, give me gum gum")
  }
  sum(x * w) / sum(w)
}

data <- 1:6
data

weights <- 1:3
weights

wt_mean(data, weights)

#stopifnot # check multiple conditions all at once

# dot dot dot

sum(1, 2, 3, 45, 678, 1)
#...
x <- c(1,2)
x
sum(x, na.mr = TRUE)
sum(x, na.rm = TRUE)


# return values

# pipeable functions


show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, sep = "")
  
  invisible(df)
}

mtcars %>% 
  show_missings()

library(nycflights13)

flights %>% 
  show_missings() 

#environment

toy_function <- function(x) {
  x + y
}

# lexical scoping

toy_function(10)

df

toy_function(df$a)

# Stacey's question, is "greeting" function going to calculate ####---------------
# for each value in the vector provided?
# i.e., if vector supplied has 3 objects, will output have 3 outputs?

library(tidyverse)
library(lubridate)

morning_example <- ymd_hms("20200201 10:30:00")
morning_example

afternoon_example <- ymd_hms("20200201 12:01:00")
afternoon_example

evening_example <- ymd_hms("20200201 20:01:00")
evening_example

date_times <- as_tibble(c(morning_example, afternoon_example, evening_example))
date_times  

#greeting function
greeting <- function(x) {
  if (hour(x) < 12) {
    return("good morning")
  } else if (hour(x) < 17) {
    return("good afternoon")
  } else {
    return("good evening")
  }
}

#does it work?

greeting(date_times$value) # this is not vectorised, uses only first value

greeting_vectorised <- function(x) {
  if_else( (hour(x) < 12), "good morning", 
           if_else( (hour(x) < 17), "good afternoon", "good evening") 
          )
}

?if_else

greeting_vectorised(date_times$value) #three outputs
