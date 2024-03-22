library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(lubridate)
library(ggplot2)
library(tidytext)
library(textdata)
library(stringr)
library(wordcloud)
library(reshape2)

#Reading in Data
df_complaints <- read_csv('Consumer_Complaints.csv')

#Cleaning/Filtering Data
complaints <- df_complaints %>%
  select(`Date received`, Product, Issue, `Consumer complaint narrative`, Company, State, `Complaint ID`) %>%
  filter(!is.na(`Consumer complaint narrative`) & `Consumer complaint narrative` != "") %>%
  unnest_tokens(word, `Consumer complaint narrative`) %>%
  mutate(row_id = row_number())

#Getting Sentiments
get_sentiments("bing")
get_sentiments("nrc")

#Getting the number of complaints per product
product <- df_complaints %>%
  group_by(Product) %>%
  summarize(count = n())

ggplot(product, aes(x = Product, y = count))+
  geom_col()+
  labs(y = "Number of Complaints")+
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1))

#Text Analysis on top 10 words with companies with most complaints
top_companies <- complaints %>%
  group_by(Company) %>%
  summarize(num_complaints = n()) %>%
  arrange(desc(num_complaints)) %>%
  top_n(5)

filtered_complaints <- complaints %>%
  filter(Company %in% top_companies$Company)

bing_word_counts <- filtered_complaints %>%
  group_by(Company) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

top_words_per_company <- bing_word_counts %>%
  group_by(Company) %>%
  slice_max(order_by = n, n = 10)

ggplot(top_words_per_company, aes(x = reorder(word, n), y = n, fill = sentiment)) +
  geom_col(position = "stack", color = "black", size = 0.3) +
  facet_wrap(~ Company, scales = "free", ncol = 2) +
  labs(title = "Top 10 Words for Companies with Most Complaints",
       x = "Word",
       y = "Count",
       fill = "Sentiment") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10, color = "black"),
        axis.text.y = element_text(size = 10, color = "black"),
        axis.title = element_text(size = 12, color = "black"),
        legend.title = element_text(size = 12, color = "black"),
        legend.text = element_text(size = 10, color = "black"),
        
        panel.background = element_rect(fill = "white", color = "black", size = 0.5),
        strip.text = element_text(size = 12, color = "black", face = "bold"),
        strip.background = element_rect(fill = "lightgray", color = "black", size = 0.5),
        plot.title = element_text(size = 16, color = "black", hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(size = 14, color = "black", hjust = 0.5),
        plot.caption = element_text(size = 10, color = "black", hjust = 1)) +
  scale_fill_manual(values = c("positive" = "#2ca02c", "negative" = "#d62728")) +
  coord_flip()

#WordCloud of the Company with the most complaints

equifax <- bing_word_counts %>%
  filter(Company == "Equifax")

complaints %>%
  inner_join(equifax) %>%
  count(word) %>%
  with(wordcloud(word, n, , scale = c(3, 0.5), max.words = 80, width = 800, height = 500))



  
