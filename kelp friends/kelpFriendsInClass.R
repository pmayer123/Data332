library(tidyverse)
library(readxl)
library(here)
library(skimr)
library(kableExtra)
library(dplyr)
library(stringr)

setwd("~/Data332/kelp friends/Data")
df_kelp <- read_excel('kelp_fronds.xlsx')
df_fish <- read.csv("fish.csv")

fish_garibaldi <- df_fish %>%
  filter(common_name == "garibaldi")

fish_mohk <- df_fish %>% 
  filter(site == "mohk")

fish_over50 <- df_fish %>% 
  filter(total_count >= 50)

fish_3sp <- df_fish %>% 
  filter(common_name == "garibaldi" | 
           common_name == "blacksmith" | 
           common_name == "black surfperch")

fish_3sp <- df_fish %>% 
  filter(common_name %in% c("garibaldi", "blacksmith", "black surfperch"))

fish_gar_2016 <- df_fish %>% 
  filter(year == 2016 | common_name == "garibaldi")

aque_2018 <- df_fish %>% 
  filter(year == 2018, site == "aque")
aque_2018 <- df_fish %>% 
  filter(year == 2018 & site == "aque")
aque_2018 <- df_fish %>% 
  filter(year == 2018) %>% 
  filter(site == "aque")

low_gb_wr <- df_fish %>% 
  filter(common_name %in% c("garibaldi", "rock wrasse"), 
         total_count <= 10)

fish_bl <- df_fish %>% 
  filter(str_detect(common_name, pattern = "black"))

fish_it <- df_fish %>% 
  filter(str_detect(common_name, pattern = "it"))

abur_kelp_fish <- df_kelp %>% 
  full_join(df_fish, by = c("year", "site"))

kelp_fish_left <- df_kelp %>% 
  left_join(df_fish, by = c("year","site"))
kelp_fish_injoin <- df_kelp %>% 
  inner_join(df_fish, by = c("year", "site"))

my_fish_join <- df_fish %>% 
  filter(year == 2017, site == "abur") %>% 
  left_join(df_kelp, by = c("year", "site")) %>% 
  mutate(fish_per_frond = total_count / total_fronds)

kable(my_fish_join)

my_fish_join %>% 
  kable() %>% 
  kable_styling(bootstrap_options = "striped", 
                full_width = FALSE)
