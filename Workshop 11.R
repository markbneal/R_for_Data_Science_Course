#Workshop 11

# Interested in: Signal (pattern)
# Ignore: noise (random variation)

# Doing: Prediction (Supervised)
# Not Doing: data discovery (Unsupervised)

# Hypothesis generation, not Hypothesis confirmation

#1 Can use an observation for exploration, or confirmation, but not both

#2 Can use an observation as many times as you like for exploration, but
# can only use once for confirmation 
# (if you use it twice, you've switched to exploration)

#If serious about confirmation:
#with your data
#60% training data set
#20% query data set
#20% test (use once only)


#Model Basics ####

#Two parts to a model
#1 family of models y = a1 + a2*x
#   y and x are variables, a1 and a2 are parameters
#2 fitted model (best fit from the family)
#   y = 3 + 1.5*x

# fitted model is best by some criteria
# Is it a good model? Not necessarily
# Is it true?

# All models are wrong, but some are useful

#Prereqs

library(tidyverse)
library(modelr)
options(na.action = na.warn)

#Simple model

sim1

ggplot(sim1, aes(x = x, y = y))+
  geom_point()

#geom_abline()

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)
models

ggplot(sim1, aes(x = x, y = y))+
  geom_point()+
  geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 0.25)


model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

model1(c(2, 2), sim1)

# To get a summary of the distance, one option:
# Root mean square error

measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}

#helper function
sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>% 
  mutate(dist = map2_dbl(a1, a2, sim1_dist)) %>% 
  arrange(dist)
models

#view lines over data
ggplot(sim1, aes(x = x, y = y))+
  geom_point(size = 2, colour = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
              data = filter(models, rank(dist) <= 10)
  )

#view parameter space
ggplot(models, aes(x = a1, y = a2)) +
  geom_point(data = filter(models, rank(dist) <= 10), 
             size = 4, colour = "red") +
  geom_point(aes(colour = -dist))
  
#grid search to finetune
grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
  ) %>% 
  mutate(dist = map2_dbl(a1, a2, sim1_dist))
grid

grid %>% 
  ggplot(aes(x = a1, y = a2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), 
             size = 4, colour = "red") +
  geom_point(aes(colour = -dist))

ggplot(sim1, aes(x = x, y = y))+
  geom_point(size = 2, colour = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
    data = filter(grid, rank(dist) <= 10)
  )


best <- optim(c(0, 0), measure_distance, data = sim1)
best$par


ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])


#lm() does all the work for you (for linear models)
sim1_model <- lm(y ~ x, data = sim1)
coef(sim1_model)

#Ex 23.2.1
#q1
sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)
sim1a
ggplot(sim1a, aes(x = x, y = y))+
  geom_point()

sim1a_model <- lm(y ~ x, data = sim1a)
coef(sim1a_model)


#Visualising models ####

#Predictions

grid <- sim1 %>%
  data_grid(x)
grid

grid <- grid %>% 
  add_predictions(sim1_model)
grid


ggplot(sim1, aes(x = x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, 
            colour = "red", size = 1)

#residuals

sim1 <- sim1 %>% 
  add_residuals(sim1_model)
sim1

#plot freq polygon
ggplot(sim1, aes(x = resid)) +
  geom_freqpoly(binwidth = 0.5)

#plot residuals by x
ggplot(sim1, aes(x = x, y = resid)) +
  geom_ref_line(h = 0) +
  geom_point()

#Ex 23.3.3

ggplot(sim1, aes(x = x, y = y))+
  geom_point() +
  geom_smooth()

?geom_smooth


# Formulas and model families

#you type: y ~ x
# R thinks: y = a1 + a2 * x

#What does R assume model_matrix()

df <- tribble(
  ~y, ~x1, ~x2,
  4,    2,  5,
  5,    1,  6
)

#assumes intercept
model_matrix(df, y ~ x1)

#me no want intercept
model_matrix(df, y ~ x1 - 1)
model_matrix(df, y ~ x1 + 0)

#categorical variables

y ~ sex
y = a1 + a2 * sex # no worky, sex is a character
y = a1 + a2 * sex_male # now a binary variable

df <- tribble(
  ~ sex, ~ response,
  "male",    1,
  "female",  2,
  "male",    1
)
model_matrix(df, response ~ sex)

sim2

ggplot(sim2) +
  geom_point(aes(x = x, y = y))

mod2 <- lm(y~ x, data = sim2)

grid <- sim2 %>% 
  data_grid(x) %>% 
  add_predictions(mod2)
grid

ggplot(sim2, aes(x)) +
  geom_point(aes(y = y)) +
  geom_point(data = grid, aes(y = pred), 
             colour = "red", size = 4)

#continuous and categorical

sim3

ggplot(sim3, aes(x = x1, y = y))+
  geom_point(aes(colour = x2))

#two possible models
mod1 <- lm(y ~ x1 + x2, data = sim3) #independent effects
# y = a1 + a2 * x1 + a3 *x2
mod2 <- lm(y ~ x1 * x2, data = sim3) # Interaction terms
# y = a1 + a2 * x1 + a3 *x2 + a4 * x1 * x2

#two tricks to visualise these models
#1 two predictors, so give both to data_grid()
#2 to generate predictions from both models, 
#   use gather_predictons(_) (one prediction per row)

grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid


#both models visualised wit facetting
ggplot(sim3, aes(x = x1, y = y, colour = x2))+
  geom_point() +
  geom_line(data = grid, aes(y = pred)) +
  facet_wrap(~ model)


sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)


# two continuous variables
sim4
mod1 <- lm(y ~ x1 + x2, data = sim4) 
mod2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>% 
  data_grid(
    x1 = seq_range(x1, 5),
    x2 = seq_range(x2, 5)) %>% 
  gather_predictions(mod1, mod2)
grid

#seq_range() gives 5 equal poits over the range

# pretty = true
seq_range(c(0.0123, 0.923423), n = 5)
seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)

#trim = 0.1 # if you dont want tail extremes
#expand = 0.1 # if you want to look further out


ggplot(grid, aes(x = x1, y = x2)) +
  geom_tile(aes(fill = pred)) +
  facet_wrap(~ model)
# I learnt nothing from that

#visualise by slices
ggplot(grid, aes(x = x1, y = pred, colour = x2, group = x2)) +
  geom_line() +
  facet_wrap(~ model)

ggplot(grid, aes(x = x2, y = pred, colour = x1, group = x1)) +
  geom_line() +
  facet_wrap(~ model)

#missing values

# other model family

##Generalised linear models
#    allows for non-continuous responses (binary, count)

##Generalised additive models
#    can incorporate arbitrary smooth functions

##Penalised linear models
#    adds a penalty term to the differences, 
#    penalise complex models

##Robust linear models
#    tweaks the distance function for large outliers 
#   (to reduce their impact) 

##Trees
#    very different, piecewise constant model
#    Used in aggregate Random forests, 
#    gradient boosting machines


#transformations

# log(y) ~ sqrt(x1) + x2
# log(y) = a1 + a2*sqrt(x1) + a3* x2

# certain math operations require the use of I()

df <- tribble(
  ~y, ~x,
  1,  1,
  2,  2, 
  3,  3
)

model_matrix(df, y ~ x^2 + x)

model_matrix(df, y ~ I(x^2) + x)


# y ~ x + I(x^2) + I(x^3) +.... #tedious

model_matrix(df, y ~ poly(x,2))

library(splines)
model_matrix(df, y ~ ns(x,2))

sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50 ),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x = x, y = y)) +
  geom_point()

mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)

grid <- sim5 %>% 
  data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>% 
  gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred = "y")

str_c("mod", 1:5)
mod1:mod5

ggplot(sim5, aes(x = x, y = y)) +
  geom_point() +
  geom_line(data = grid, colour = "red") +
  facet_wrap(~ model)
