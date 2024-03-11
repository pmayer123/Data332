library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(lubridate)
library(ggplot2)

setwd("~/Data332/Patient Billing/Data")

df_billing <- read_excel("Billing.xlsx")
df_patient <- read_excel("Patient.xlsx")
df_visit <- read_excel("Visit.xlsx")

visit_patient_left <- df_visit %>%
  left_join(df_patient, by = c("PatientID"))

df_all <- visit_patient_left %>%
  left_join(df_billing, by = c("VisitID"))


#Reason for visit segmented by month of year
df_all$VisitMonth <- factor(month(df_all$VisitDate), levels = 1:12,
                            labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

df_reasons <- df_all %>%
  group_by(Reason, VisitMonth) %>%
  summarize(count = n(), .groups = "drop")

ggplot(df_reasons, aes(x = Reason, y = count, fill = df_reasons$VisitMonth))+
  geom_bar(stat = "identity", position = "stack") +
  labs(x = "Reason", y = "Count",fill = df_reasons$VisitMonth) +
  scale_fill_manual(values = c("blue", "red", "green", "yellow", "purple", "cyan", "orange"), labels = c("Jan", "Feb", "Mar", "Apr","Oct", "Nov", "Dec")) +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1))

#Reason for visit based on walk in or not
df_reasons_walk_in <- df_all %>%
  group_by(Reason, WalkIn) %>%
  summarize(count = n(), .groups = "drop")

ggplot(df_reasons_walk_in, aes(x = Reason, y = count, fill = df_reasons_walk_in$WalkIn))+
  geom_bar(stat = "identity", position = "stack") +
  labs(x = "Reason", y = "Count", fill = df_reasons_walk_in$WalkIn) +
  scale_fill_manual(values = c("blue", "red"), labels = c("TRUE", "FALSE")) +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1))

#Reason for visit based on City/State or zipcode
df_reasons_city <- df_all %>%
  group_by(Reason, City, State) %>%
  summarize(count = n(), .groups = "drop")

df_reasons_zip <- df_all %>%
  group_by(Reason, Zip) %>%
  summarize(count = n(), .groups = "drop")

ggplot(df_reasons_city, aes(x = Reason, y = count, fill = City)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~State, scales = "free", ncol = 3) +
  labs(x = "Reason for Visit", y = "Count", fill = "City") +
  theme(axis.text = element_text(angle = 45, vjust = 0.5, hjust = 1))

ggplot(df_reasons_zip, aes(x = Reason, y = count, fill = Zip)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(x = "Reason for Visit", y = "Count", fill = "ZipCode") +
  theme(axis.text = element_text(angle = 45, vjust = 0.5, hjust = 1))

#Total invoice amount based on reason for visit segmented by with it was paid
df_reasons_invoice <- df_all %>%
  group_by(Reason, InvoicePaid) %>%
  summarize(count = n(), 
            total_invoice = sum(InvoiceAmt, na.rm = TRUE), .groups = "drop")

ggplot(df_reasons_invoice, aes(x = Reason, y = total_invoice, fill = InvoicePaid))+
  geom_bar(stat = "identity", position = "stack") +
  labs(x = "Reason", y = "Invoice Due", fill = "Invoice Paid") +
  scale_fill_manual(values = c("blue", "red"), labels = c("TRUE", "FALSE")) +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1))

#Find an interesting insight. In a chart

df_all$BirthYear <- year(df_all$BirthDate)

df_year <- df_all %>%
  group_by(BirthYear) %>%
  summarize(count = n())

ggplot(df_year, aes(x = BirthYear, y = count))+
  geom_col()