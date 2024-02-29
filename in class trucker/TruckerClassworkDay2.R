library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(stringr)

rm(list = ls())
# setting up working directory
setwd("~/Data332/in class trucker/Data")

df_truck_0001 <- read_excel('truck data 0001.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_0369 <- read_excel('truck data 0369.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1226 <- read_excel('truck data 1226.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1442 <- read_excel('truck data 1442.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1478 <- read_excel('truck data 1478.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1539 <- read_excel('truck data 1539.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1769 <- read_excel('truck data 1769.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')

df_pay <- read_excel('Driver Pay Sheet.xlsx', .name_repair = 'universal')

df <- rbind(df_truck_0001, df_truck_0369, df_truck_1226, df_truck_1442, df_truck_1478
            , df_truck_1539, df_truck_1769)

df_starting_pivot <- df%>%
  group_by(Truck.ID) %>%
  summarize(count = n())
df <- left_join(df, df_pay, by = c('Truck.ID'))
df$total_lpm <- (df$Odometer.Ending - df$Odometer.Beginning) * df$labor_per_mil

df$Name <- df_pay$first + df_pay$last

df_labor_pivot <- df%>%
  group_by(first) %>%
  summarize(count = n(), pay = sum(total_lpm))

ggplot(df_labor_pivot, aes(x = first, y = pay, fill = first)) +
  geom_col() +
  labs(x = 'Driver', y = '$$$$')+
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1))

            