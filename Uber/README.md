# Uber Analysis

## Introduction
Analyizing Uber Data in a Shiny application

## Data Combination
1. Read in the csv files that contain all the data
```
# Loading Data in
 april_data <- read.csv("uber-raw-data-apr14.csv")
 may_data <- read.csv("uber-raw-data-may14.csv")
 june_data <- read.csv("uber-raw-data-jun14.csv")
 july_data <- read.csv("uber-raw-data-jul14.csv")
 august_data <- read.csv("uber-raw-data-aug14.csv")
 sept_data <- read.csv("uber-raw-data-sep14.csv")
```
2. Combine the data into 1 table
```
# Binding all the data together
 all <- full_join(april_data, may_data, by = c("Date.Time", "Lat", "Lon", "Base"))%>%
   full_join(june_data, by = c("Date.Time", "Lat", "Lon", "Base"))%>%
   full_join(july_data, by = c("Date.Time", "Lat", "Lon", "Base"))%>%
   full_join(august_data, by = c("Date.Time", "Lat", "Lon", "Base"))%>%
   full_join(sept_data, by = c("Date.Time", "Lat", "Lon", "Base"))
```

## Data Cleaning
1. Turning the date column into a date schema
```
#Changing the date column to a date schema
all$Date <- as.Date(all$Date.Time, format = "%m/%d/%Y")
# Convert Date.Time to POSIXct format with the appropriate format
all$Date.Time <- as.POSIXct(all$Date.Time, format = "%m/%d/%Y %H:%M:%S")
# Extract hour from Date.Time column
all$Hour <- as.POSIXlt(all$Date.Time)$hour
# Extract month from Date.Time column
all$Month <- as.numeric(format(all$Date.Time, "%m"))
# Extract day from Date.Time column
all$Day <- as.numeric(format(all$Date.Time, "%d"))
# Extract month and day of the week from Date.Time column
all$Month <- format(all$Date.Time, "%B")
all$DayOfWeek <- factor(weekdays(all$Date.Time), levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
```

## Data Preparation
Creating pivot tables for each of the visualizations

1. Create pivot table to display trips by hour and month
```
pivot_table_month_hour <- all %>%
  group_by(Month, Hour) %>%
  summarise(Trips = n())
```
2. Create pivot table to display trips by day of the month
```
pivot_table_day <- all %>%
  group_by(Day) %>%
  summarise(Trips = n())
```
3. Create pivot table to display trips by month and day of the week
```
pivot_table_month_day <- all %>%
  group_by(Month, DayOfWeek) %>%
  summarise(Trips = n())
```
4. Create pivot table to display trips by base and month
```
pivot_table_base_month <- all %>%
  group_by(Base, Month) %>%
  summarise(Trips = n())
```
5. Create pivot table to display trips by hour and day
```
pivot_table_hour_day <- all %>%
  group_by(Hour, Day) %>%
  summarise(Trips = n())
```
6. Create pivot table to display trips by month and day(number)
```
pivot_table_base_dayOfWeek <- all %>%
  group_by(Base, DayOfWeek) %>%
  summarise(Trips = n())
```

## Data Visualizations

1. Chart that displays Trips Every Hour
```
ggplot(pivot_table_hour, aes(x = Hour, y = Trips)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Hour", y = "Number of Trips") +
  theme_minimal()
```
2. Chart that shows Trips by Hour and Month
```
ggplot(pivot_table_month_hour, aes(x = Hour, y = Trips, group = Month, color = factor(Month))) +
  geom_line() +
  labs(x = "Hour", y = "Number of Trips", color = "Month") +
  scale_color_discrete(name = "Month", labels = c("Apr", "May", "Jun", "Jul", "Aug", "Sep")) +
  theme_minimal()
```
3. Chart that displays Trips by Day of the Month
```
ggplot(pivot_table_day, aes(x = Day, y = Trips)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Day of the Month", y = "Number of Trips") +
  theme_minimal()
```
4. Chart that displays Trips by Month and Day of the Week
```
ggplot(pivot_table_month_day, aes(x = Month, y = Trips, fill = DayOfWeek)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Month", y = "Number of Trips", fill = "Day of the Week") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```
5. Chart that displays Trips by Base and Month
```
ggplot(pivot_table_base_month, aes(x = Base, y = Trips, fill = Month)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Base", y = "Number of Trips", fill = "Month") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```
6. Heatmap that displays by hour and day
```
ggplot(pivot_table_hour_day, aes(x = Hour, y = Day, fill = Trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "blue") +
  theme_minimal() +
  labs(title = "Heatmap Hour and Day")
```
7. Heatmap by month and day
```
ggplot(pivot_table_month_day_number, aes(x = Month, y = Day, fill = Trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "green") +
  theme_minimal() +
  labs(title = "Heatmap Month and Day")
```
8. Heatmap by month and week
```
ggplot(pivot_table_month_day, aes(x = Month, y = DayOfWeek, fill = Trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  theme_minimal() +
  labs(title = "Heatmap Month and Week")
```
9. Heatmap by bases and day of week
```
ggplot(pivot_table_base_dayOfWeek, aes(x = Base, y = DayOfWeek, fill = Trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "purple") +
  theme_minimal() +
  labs(title = "Heatmap Base and Day of Week")
```
