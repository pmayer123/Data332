library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(stringr)

rm(list = ls())
# setting up working directory
setwd("~/Data332/in class trucker")

df_truck <- read_excel('NP_EX_1-2.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
#selecting columns
df <- df_truck[, c(4:15)]
#deselect columns
df <- subset(df, select = -c(...10))

#getting difference in days within a column
date_min <- min(df$Date)
date_max <- max(df$Date)

number_of_days_on_the_road <- date_max - date_min
print(number_of_days_on_the_road)

days <- difftime(max(df$Date), min(df$Date))
print(days)
number_of_days_recorded <- nrow(df)

total_hours <- sum(df$Hours)
avg_hrs_per_day_rec <- round(total_hours / number_of_days_recorded, digits = 3)

#adding column
df$fuel_cost <- df$Gallons * df$Price.per.Gallon
df$total_cost <- df$Tolls + df$Misc + df$fuel_cost

total_fuel_expenses <- sum(df$fuel_cost)
other_expenses <- sum(df$Misc) + sum(df$Tolls)
total_gallons_used <- sum(df$Gallons)
total_miles_driven <- sum(df$Odometer.Ending - df$Odometer.Beginning)
df$miles_per_gallon <- (df$Odometer.Ending - df$Odometer.Beginning) / df$Gallons
df$total_cost_per_mile <- (df$Odometer.Ending - df$Odometer.Beginning) / df$total_cost

df <- subset(df, select = -c(total_cost_per_mile))

df[c('warehouse', 'city_state')] <- str_split_fixed(df$Starting.Location, ",", 2)
