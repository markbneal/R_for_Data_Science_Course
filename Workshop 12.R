# Workshop 12
# 

# Partitioning
#1 Patterns
#2 Residuals

#Prereqs

library(tidyverse)
library(modelr)
options(na.action = na.warn)

library(nycflights13)
library(lubridate)

# Low quality diamonds are more expensive?

?diamonds

ggplot(diamonds, aes(x = cut, y = price)) +
  geom_boxplot()
ggplot(diamonds, aes(x = color, y = price)) +
  geom_boxplot()
ggplot(diamonds, aes(x = clarity, y = price)) +
  geom_boxplot()


# Price and carat

# you may need to install this
#install.packages("hexbin")

ggplot(diamonds, aes(x = carat, y = price))+
  geom_hex(bins = 50)

#1 filter the data to get carats <=2.5
#2 log-transform carat and price

diamonds2 <- diamonds %>% 
  filter(carat <= 2.5) %>%
  mutate(lprice = log2(price),
         lcarat = log2(carat))
?log2  

log2(2) #1
log2(4) #2
log2(8) #3

ggplot(diamonds2, aes(x = lcarat, y = lprice))+
  geom_hex(bins = 50)

mod_diamond <- lm(lprice ~ lcarat, data = diamonds2)

grid <- diamonds2 %>% 
  data_grid(carat = seq_range(carat, 20)) %>% 
  mutate(lcarat = log2(carat)) %>% 
  add_predictions(mod_diamond, "lprice") %>% 
  mutate(price = 2 ^ lprice)  

ggplot(diamonds2, aes(x = carat, y = price)) +
  geom_hex(bins = 50) +
  geom_line(data = grid, colour = "red", size = 1)


#check is there a pattern left in the residuals after 
# removing our log effect?

diamonds2 <- diamonds2 %>% 
  add_residuals(mod_diamond, "lresid")

ggplot(diamonds2, aes(lcarat, lresid))+
  geom_hex(bins = 50)

ggplot(diamonds2, aes(x = cut, y = lresid)) +
  geom_boxplot()
ggplot(diamonds2, aes(x = color, y = lresid)) +
  geom_boxplot()
ggplot(diamonds2, aes(x = clarity, y = lresid)) +
  geom_boxplot()


# A more complicated model

mod_diamond2 <- lm(lprice ~ lcarat + cut + color + clarity,
                   data = diamonds2)

grid <- diamonds2 %>% 
  data_grid(cut, .model = mod_diamond2) %>% 
  add_predictions(mod_diamond2)
grid

ggplot(grid, aes(x = cut, y = pred))+
  geom_point()

#for variables not specified, will choose:
# most common (for categorical),
# median (for continuous)

#check outliers / interesting observations
#1 model is wrong
#2 errors in the data

# Ex 24.2.3


#What affects number of daily flights

flights

daily <- flights %>% 
  mutate(date = make_date(year, month, day)) %>% 
  group_by(date) %>% 
  summarise(n = n())

daily

ggplot(daily, aes(x = date, y = n)) +
  geom_line()

#day of week

daily <- daily %>% 
  mutate(weekday = wday(date, label = TRUE))
daily

ggplot(daily, aes(x = weekday, y = n))+
  geom_boxplot()

mod <- lm(n ~ weekday, data = daily)

grid <- daily %>% 
  data_grid(weekday) %>% 
  add_predictions(mod, "n")
grid

ggplot(daily, aes(x = weekday, y = n))+
  geom_boxplot() +
  geom_point(data = grid, colour = "red", size = 4)

# check residuals
daily <- daily %>% 
  add_residuals(mod)
daily

daily %>% 
  ggplot(aes(x = date, y = resid)) +
  geom_ref_line(h = 0)+
  geom_line()

ggplot(daily, aes(x = date, y = resid, colour = weekday))+
  geom_ref_line(h = 0)+
  geom_line()

#days with fewer flights
daily %>% 
  filter(resid < -100)


#days with more flights
daily %>% 
  filter(resid > 100)

# add smooth trend over year
daily %>% 
  ggplot(aes(x = date, y = resid)) +
  geom_ref_line(h = 0)+
  geom_line()+
  geom_smooth(se = FALSE, span = 0.20)

#seasonal staurday effect

daily %>% 
  filter(weekday == "Sat") %>% 
  ggplot(aes(x = date, y = n)) +
    geom_point()+
    geom_line()+
    scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")


#function to separate dates by term
term <- function(date) {
  cut(date, 
      breaks = ymd(20130101, 20130605, 20130825, 20140101),
      labels = c("spring", "summer", "fall"))
}

daily <- daily %>% 
  mutate(term = term(date))

daily

daily %>% 
  filter(weekday == "Sat") %>% 
  ggplot(aes(x = date, y = n, colour = term))+
  geom_point(alpha = 1/3)+
  geom_line() +
  scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")

daily %>% 
  ggplot(aes(x = weekday, y = n, colour = term))+
  geom_boxplot()

mod1 <- lm(n ~ weekday, data = daily)
mod2 <- lm(n ~ weekday * term, data = daily)

daily %>% 
  gather_residuals(without_term = mod1, with_term = mod2) %>% 
  ggplot(aes(x = date, y = resid, colour = model)) +
    geom_line()

#overlay predictions on data

grid <- daily %>% 
  data_grid(weekday, term) %>% 
  add_predictions(mod2, "n")

ggplot(daily, aes(x = weekday, y = n))+
  geom_boxplot()+
  geom_point(data = grid, colour = "red") +
  facet_wrap( ~ term)


#MASS::rlm() # use for robust lm (less affected by outliers)

mod3 <-  MASS::rlm(n ~ weekday * term, data = daily)

daily %>% 
  add_residuals(mod3, "resid") %>%
  ggplot(aes(x = date, y = resid)) +
    geom_line()

# below covered in the book, look up if interested

# computing variables in function or in model formula
# trying to avoid mistakes

#Time of year alternative approach
# using splines

#Ex 24.3.5



#Hurricanes and Himmicanes

#install.packages("DHARMa")
#install.packages("gdata")
library(gdata)
Data = read.xls("http://www.pnas.org/content/suppl/2014/05/30/1402786111.DCSupplemental/pnas.1402786111.sd01.xlsx", 
                nrows = 92, as.is = TRUE)

library(glmmTMB)
originalModelGAM = glmmTMB(alldeaths ~ scale(MasFem) * 
                             (scale(Minpressure_Updated.2014) + scale(NDAM)), 
                           data = Data, family = nbinom2)

# Residual checks with DHARMa
library(DHARMa)
res <- simulateResiduals(originalModelGAM)
plot(res)

# no significant deviation in the general plot, but try this
# which was highlighted by https://www.theguardian.com/science/grrlscientist/2014/jun/04/hurricane-gender-name-bias-sexism-statistics
plotResiduals(res, Data$NDAM)

# we also find temporal autocorrelation
res2 = recalculateResiduals(res, group = Data$Year)
testTemporalAutocorrelation(res2, time = unique(Data$Year))

