library(shiny)
library(ggplot2)
library(DT)
library(dbplyr)
library(tidyverse)
library(leaflet)
library(leaflet.extras)

# #Loading Data in
# april_data <- read.csv("uber-raw-data-apr14.csv")
# may_data <- read.csv("uber-raw-data-may14.csv")
# june_data <- read.csv("uber-raw-data-jun14.csv")
# july_data <- read.csv("uber-raw-data-jul14.csv")
# august_data <- read.csv("uber-raw-data-aug14.csv")
# sept_data <- read.csv("uber-raw-data-sep14.csv")
# 
# 
# #Step 1 Binding all the data together
# all <- full_join(april_data, may_data, by = c("Date.Time", "Lat", "Lon", "Base"))%>%
#   full_join(june_data, by = c("Date.Time", "Lat", "Lon", "Base"))%>%
#   full_join(july_data, by = c("Date.Time", "Lat", "Lon", "Base"))%>%
#   full_join(august_data, by = c("Date.Time", "Lat", "Lon", "Base"))%>%
#   full_join(sept_data, by = c("Date.Time", "Lat", "Lon", "Base"))
#Load in all data
load("all.rda")
# Step 2: Changing the date column to a date schema
all$Date <- as.Date(all$Date.Time, format = "%m/%d/%Y")


# Convert Date.Time to POSIXct format with the appropriate format
all$Date.Time <- as.POSIXct(all$Date.Time, format = "%m/%d/%Y %H:%M:%S")


# Extract hour from Date.Time column
all$Hour <- as.POSIXlt(all$Date.Time)$hour


# Define UI
ui <- fluidPage(
  titlePanel("Uber Data Visualization"),
    mainPanel(
      tabsetPanel(
        tabPanel("Trips by Hour",
                 plotOutput("plot_trips_hour"),
                 p("Analysis for Trips by Hour: 
                   The number of trips per hour first spikes around 6, 7, and 8, and then spikes again at 15 reaching its max at 17 before dropping back down")),
        tabPanel("Trips by Hour and Month",
                 plotOutput("plot_trips_hour_month"),
                 p("Analysis for Trips by Hour and Month:
                   Displays the number of trips per hour for each month, with the months represented as different lines. September is the leader of trips through every hourmark with April at the bottom")),
        tabPanel("Trips by Day of Month",
                 plotOutput("plot_trips_day_month"),
                 p("Analysis for Trips by Day and Month:
                   The number of trips by day is relatively consistant with most days around the 150,000 area. Except for the 31st which could be because some months lack that day.")),
        tabPanel("Trips by Month and Day of Week",
                 plotOutput("plot_trips_month_day_week"),
                 p("Analysis for Trips by Month and Day of Week:
                   Displays the month and each day of the week of that month and how many trips there were. September had the highest while the lowest were in April.")),
        tabPanel("Trips by Base and Month",
                 plotOutput("plot_trips_base_month"),
                 p("Analysis for Trips by Base and Month:
                   Displays the number of trips from each base for each month. BO2617 had the highest values in August and September. While the lowest were in BO2764 in April, July, June and May")),
        tabPanel("Heatmap Hour and Day",
                 plotOutput("plot_heatmap_hour_day"),
                 p("Analysis for Heatmap of Hour and Day:
                   Shows the number of trips for each hour of a day. With the darker color meaning more trips and the opposite for the lighter. This heatmap shows that the most trips occur inbetween hour 15 and 20")),
        tabPanel("Heatmap Month and Day",
                 plotOutput("plot_heatmap_month_day"),
                 p("Analysis for Heatmap of Month and Day:
                   This heatmap shows the number of trips for each day in a month. It shows that September has the most trips out of the months and 30th of the days")),
        tabPanel("Heatmap Month and Week",
                 plotOutput("plot_heatmap_month_week"),
                 p("Analysis for Heatmap of Month and Week:
                   This heatmap shows the number of trips for each month and day of the week. It shows that September leads the months and Friday for days of the week")),
        tabPanel("Heatmap Base and Day of Week",
                 plotOutput("plot_heatmap_base_day_week"),
                 p("Analysis for Heatmap of Base and Day of Week:
                   This heatmap shows the number of trips for each base and day of the week. It shows that both BO2512 and BO2764 account for very little of the overall trips. With the max being in BO2617 on Thursday."))
      )
    )
  )



# Create pivot table to display trips by hour
pivot_table_hour <- all %>%
  group_by(Hour) %>%
  summarise(Trips = n())

# Extract month from Date.Time column
all$Month <- as.numeric(format(all$Date.Time, "%m"))

# Extract day from Date.Time column
all$Day <- as.numeric(format(all$Date.Time, "%d"))

# Extract month and day of the week from Date.Time column
all$Month <- format(all$Date.Time, "%B")
all$DayOfWeek <- factor(weekdays(all$Date.Time), levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))


# Create pivot table to display trips by hour and month
pivot_table_month_hour <- all %>%
  group_by(Month, Hour) %>%
  summarise(Trips = n())

# Create pivot table to display trips by day of the month
pivot_table_day <- all %>%
  group_by(Day) %>%
  summarise(Trips = n())

# Create pivot table to display trips by month and day of the week
pivot_table_month_day <- all %>%
  group_by(Month, DayOfWeek) %>%
  summarise(Trips = n())

# Create pivot table to display trips by base and month
pivot_table_base_month <- all %>%
  group_by(Base, Month) %>%
  summarise(Trips = n())

# Create pivot table to display trips by hour and day
pivot_table_hour_day <- all %>%
  group_by(Hour, Day) %>%
  summarise(Trips = n())

# Create pivot table to display trips by month and day(number)
pivot_table_month_day_number <- all %>%
  group_by(Month, Day) %>%
  summarise(Trips = n())

# Create pivot table to display trips by base and day of week
pivot_table_base_dayOfWeek <- all %>%
  group_by(Base, DayOfWeek) %>%
  summarise(Trips = n())


# Define server
server <- function(input, output) {
  # Your data processing code remains the same
  
  # Chart that displays Trips Every Hour
  output$plot_trips_hour <- renderPlot({
    ggplot(pivot_table_hour, aes(x = Hour, y = Trips)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Hour", y = "Number of Trips") +
      theme_minimal()
  })
  
  # Chart that shows Trips by Hour and Month
  output$plot_trips_hour_month <- renderPlot({
    ggplot(pivot_table_month_hour, aes(x = Hour, y = Trips, group = Month, color = factor(Month))) +
      geom_line() +
      labs(x = "Hour", y = "Number of Trips", color = "Month") +
      scale_color_discrete(name = "Month", labels = c("Apr", "May", "Jun", "Jul", "Aug", "Sep")) +
      theme_minimal()
  })
  
  # Chart that displays Trips by Day of the Month
  output$plot_trips_day_month <- renderPlot({
    ggplot(pivot_table_day, aes(x = Day, y = Trips)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Day of the Month", y = "Number of Trips") +
      theme_minimal()
  })
  
  # Chart that displays Trips by Month and Day of the Week
  output$plot_trips_month_day_week <- renderPlot({
    ggplot(pivot_table_month_day, aes(x = Month, y = Trips, fill = DayOfWeek)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Month", y = "Number of Trips", fill = "Day of the Week") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Chart that displays Trips by Base and Month
  output$plot_trips_base_month <- renderPlot({
    ggplot(pivot_table_base_month, aes(x = Base, y = Trips, fill = Month)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Base", y = "Number of Trips", fill = "Month") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Heatmap that displays by hour and day
  output$plot_heatmap_hour_day <- renderPlot({
    ggplot(pivot_table_hour_day, aes(x = Hour, y = Day, fill = Trips)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "blue") +
      theme_minimal() +
      labs(title = "Heatmap Hour and Day")
  })
  
  # Heatmap by month and day
  output$plot_heatmap_month_day <- renderPlot({
    ggplot(pivot_table_month_day_number, aes(x = Month, y = Day, fill = Trips)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "green") +
      theme_minimal() +
      labs(title = "Heatmap Month and Day")
  })
  
  # Heatmap by month and week
  output$plot_heatmap_month_week <- renderPlot({
    ggplot(pivot_table_month_day, aes(x = Month, y = DayOfWeek, fill = Trips)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "red") +
      theme_minimal() +
      labs(title = "Heatmap Month and Week")
  })
  
  # Heatmap by bases and day of week
  output$plot_heatmap_base_day_week <- renderPlot({
    ggplot(pivot_table_base_dayOfWeek, aes(x = Base, y = DayOfWeek, fill = Trips)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "purple") +
      theme_minimal() +
      labs(title = "Heatmap Base and Day of Week")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
           
           
           
           
           
           