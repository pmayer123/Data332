library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(lubridate)
library(ggplot2)

 setwd("~/Data332/Student/Data")
 df_student <- read_excel('Student.xlsx')
df_course <- read_excel('Course.xlsx') 
df_reg <- read_excel('Registration.xlsx')

merged_data <- left_join(df_student, df_reg, by = "Student ID")
merged_data_final <- left_join(merged_data, df_course, by = "Instance ID")

#Chart on the number of Majors

df_majors <- merged_data_final %>%
  group_by(Title) %>%
  summarize(count = n())

ggplot(df_majors, aes(x = Title, y = count)) +
  geom_col() +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1))

#Chart on Birth year of Students

merged_data_final$Birth_year <- year(merged_data_final$`Birth Date`)

df_year <- merged_data_final %>%
  group_by(Birth_year) %>%
  summarize(count = n())

ggplot(df_year, aes(x = Birth_year, y = count))+
  geom_col()

#Total Cost by Major, segmented by Payment Plan

total_cost_per_major <- merged_data_final %>%
  group_by(Title, `Payment Plan`) %>%
  summarize(count = n(),
            total_cost = sum(`Total Cost`, na.rm = TRUE), .groups = "drop")
            
ggplot(total_cost_per_major, aes(x = Title, y = total_cost, fill = total_cost_per_major$`Payment Plan`))+
  geom_bar(stat = "identity", position = "stack") +
  labs(x = "Major", y = "Cost", fill = total_cost_per_major$`Payment Plan`) +
  scale_fill_manual(values = c("blue", "red"), labels = c("False", "True")) +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1))

#Total Balance Due by Major, segmented by Payment Plan

total_balance_due_per_major <- merged_data_final %>%
  group_by(Title, `Payment Plan`) %>%
  summarize(count = n(),
            balance_due = sum(`Balance Due`, na.rm = TRUE), .groups = "drop")

ggplot(total_balance_due_per_major, aes(x = Title, y = balance_due, fill = total_balance_due_per_major$`Payment Plan`))+
  geom_bar(stat = "identity", position = "stack") +
  labs(x = "Major", y = "Balance Due", fill = total_balance_due_per_major$`Payment Plan`) +
  scale_fill_manual(values = c("blue", "red"), labels = c("False", "True")) +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1))
  
  
            