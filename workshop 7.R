# workshop 7

#Factors ####----------------------

library(tidyverse)

#creating factors

x1 <- c("Dec", "Apr", "Jan", "Mar" )

x1b <- c("Dec", "Apr", "Jam", "Mar" )

sort(x1)

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

y1 <- factor(x1, levels = month_levels)

sort(y1)

y2 <- factor(x1b, levels = month_levels)
y2

y2 <- parse_factor(x1b, levels = month_levels)

factor(x1)

x1

f1 <- factor(x1, levels = unique(x1))
f1

f2 <- x1 %>% 
  factor() %>% 
  fct_inorder()
f2

levels(f2)

#General social survey

gss_cat

?gss_cat

gss_cat %>% 
  count(race)

ggplot(gss_cat, aes(x = race)) +
  geom_bar()

ggplot(gss_cat, aes(x = race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)


#Ex 15.3.1

#q1
ggplot(gss_cat, aes(x = rincome)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE) +
  coord_flip()

#q2
ggplot(gss_cat, aes(x = relig)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE) +
  coord_flip()

ggplot(gss_cat, aes(x = partyid)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE) +
  coord_flip()

#q3
gss_cat %>% 
  count(relig, denom) %>% 
  arrange(desc(n))


# changing (modifying) factor order

relig_summary <-  gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
relig_summary

ggplot(relig_summary, aes(x = tvhours, y = relig)) +
  geom_point()

#fct_reorder
# factor you want to reorder
# x numeric vector as a basis for reordering
# optional function, default is median

ggplot(relig_summary, aes(x = tvhours, y = fct_reorder(relig, tvhours))) +
  geom_point()

relig_summary %>% 
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(aes(x = tvhours, y = relig)) +
    geom_point()


#do older people have more income?
rincome_summary <- gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
rincome_summary

ggplot(rincome_summary, aes(x=age, y = fct_reorder(rincome, age)))+
  geom_point()

ggplot(rincome_summary, aes(x=age, y = rincome))+
  geom_point()

#reorder for line plots
by_age <- gss_cat %>% 
  filter(!is.na(age)) %>% 
  count(age, marital) %>% 
  group_by(age) %>% 
  mutate(prop = n / sum(n))
by_age

ggplot(by_age, aes(x = age, y = prop, colour = marital))+
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(x = age, y = prop, 
                   colour = fct_reorder2(marital, age, prop)))+
  geom_line(na.rm = TRUE) +
  labs(colour = "marital")
?fct_reorder2

#reorder with bar plots

gss_cat %>% 
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>% 
  ggplot(aes(x = marital)) +
    geom_bar()

#Ex 15.4.1
#q1

gss_cat %>% 
  ggplot(aes(x = relig, y = tvhours)) +
    geom_jitter() +
    coord_flip()

#use median instead
relig_summary <-  gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = median(tvhours, na.rm = TRUE),
    n = n()
  )
relig_summary

ggplot(relig_summary, aes(x = tvhours, y = relig)) +
  geom_point()

#q2

?gss_cat

levels(gss_cat$rincome)
levels(gss_cat$marital)


#modifying factor levels

gss_cat %>% count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

#lump some groups together

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid)


# lump together all small groups

gss_cat %>% 
  mutate(relig = fct_lump(relig)) %>% 
  count(relig)

gss_cat %>% 
  mutate(relig = fct_lump(relig, n = 5)) %>% 
  count(relig)


#Ex 15.5.1
#q1

party_time <- gss_cat %>%
  group_by(year) %>% 
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid) %>% 
  mutate(prop = n / sum(n))
party_time

ggplot(party_time, aes(x = year, y = prop, colour = partyid)) +
  geom_line()


# Dates and times ####--------------------------------------

library(tidyverse)
library(lubridate)
library(nycflights13)

# three types of date time data
# date
# time
# date-time (R, POSIXct)

#hms package for just times

today()

now()

# 3 ways to create a date/time
# string
# from individual components
# from existing date/time

# from strings

ymd("2017-01-31")

mdy("January 31st, 2017")

dmy("31-Jan-2017")

ymd(20170131)

#error?
ymd("2017-02-01")
ydm("2017-02-20")

#now date times

ymd_hms("2017-01-31 20:11:59")

mdy_hm("01/31/2017 08:01")

mdy_hm("01/31/2017 08:01", tz = "Pacific/Auckland")

# for individual components

flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

make_datetime_100(2013, 03, 05, 517)

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))
flights_dt  

#Flights per day
flights_dt %>% 
  ggplot(aes(x = dep_time)) +
  geom_freqpoly(binwidth = (24*60*60)) # binwitdh is one day of seconds

#flights within day
flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(x = dep_time)) +
  geom_freqpoly(binwidth = (10*60)) # 10 minute binwidth

today()

as_datetime(today())

now()
as_date(now())

#Ex 16.2.4
#q1
ymd(c("2010-10-10", "bananas"))

#q2
?today

# date time components

datetime <- ymd_hms("2016-07-08 12:34:56")
datetime

year(datetime)
month(datetime)
mday(datetime)

yday(datetime)
wday(datetime)
?wday

month(datetime, label = TRUE)
month(datetime, label = TRUE, abbr = FALSE)

wday(datetime, label = TRUE)


flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
    geom_bar()

# time spans

# three classes
# duration (exact number of seconds)
# periods (human units, weeks and months)
#intervals (represnt start and end point)

#durations

h_age <- today() - ymd(19791014)
h_age
class(h_age)

as.duration(h_age)

dseconds(15)

dminutes(10)

dhours(c(12,24))

dweeks(3)


2 * dyears(1)

tomorrow <- today() + ddays(1)
tomorrow


one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")
one_pm

one_pm + ddays(1)

#periods

one_pm + days(1)

flights_dt %>% 
  filter(arr_time < dep_time)

flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(1 * overnight),
    sched_arr_time = sched_arr_time + days(1 * overnight)
  )

flights_dt %>% 
  filter(arr_time < dep_time)

#intervals

dyears(1)/ddays(365)

years(1)

#Ex 16.4.5
#q2
# Create a vector of dates giving the first day of every month in 2015. 
# Create a vector of dates giving the first day of every month in the 
# current year.

ymd("2015-01-01") + months(0:11)

#time zones

Sys.timezone()

OlsonNames()

(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))
#> [1] "2015-06-01 12:00:00 EDT"
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen"))
#> [1] "2015-06-01 18:00:00 CEST"
(x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland"))
#> [1] "2015-06-02 04:00:00 NZST"

x1-x2

x2-x3


x4 <- c(x1, x2, x3)
x4

x4a <- with_tz(x4, tzone = "Pacific/Auckland")
x4a

x4b <- force_tz(x4, tzone = "Pacific/Auckland")
x4b

x4a - x4b
