#load required packages
library(readr)
library(kaggler)
library(dplyr)
library(ggplot2)

#set the API
response <- kgl_datasets_download_all(owner_dataset = "ashley93/openpowerlifting")
download.file(response[["url"]], "data/temp.zip", mode="wb")
unzip_result <- unzip("data/temp.zip", exdir = "data/", overwrite = TRUE)
powerlift_data <- read.csv("data/openpowerlifting.csv")

colnames(powerlift_data)

final_df <- powerlift_data %>% 
  select(Name, Sex, Age, Division, BodyweightKg, WeightClassKg, BestSquatKg, 
         BestBenchKg, BestDeadliftKg, TotalKg, Place)

head(final_df)

#separate the male and female
#male
male_data <- final_df %>% 
  filter(final_df$Sex == "M")

#female
female_data <- final_df %>% 
  filter(final_df$Sex == "F")
View(female_data)


#number of weight classes
weight_class_count <- final_df %>% 
  count(WeightClassKg)

# Horizontal Bar chart
ggplot(weight_class_count, aes(x = reorder(WeightClassKg, n), y = n)) +
  geom_bar(stat = "identity", fill = "steelblue") +  
  coord_flip() +  # Flip coordinates to make the bars horizontal
  labs(x = "Weight Class (kg)", y = "Number of Competitors", 
       title = "Number of Competitors per Weight Class") +
  theme_minimal() +  # Use a minimal theme for cleaner appearance
  theme(
    #axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis text for readability
    axis.text.y = element_text(size = 10),  # Adjust y-axis text size for better readability
    plot.title = element_text(hjust = 0.5)  # Center the plot title
  )

