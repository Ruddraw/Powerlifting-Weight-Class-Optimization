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
#View(female_data)


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
    axis.text.y = element_text(size = 10),  # Adjust y-axis text size for better readability
    plot.title = element_text(hjust = 0.5)  # Center the plot title
  )

# Create the side-by-side horizontal bar chart for comparing the male and female competitor
gender_weight_class_count <- final_df %>% 
  count(WeightClassKg, Sex)

ggplot(gender_weight_class_count, aes(x = reorder(WeightClassKg, n), y = n, fill = Sex)) +
  geom_bar(stat = "identity", position = "dodge") +  # Position bars side by side
  coord_flip() +  # Flip coordinates to make the bars horizontal
  labs(x = "Weight Class (kg)", y = "Number of Competitors", 
       title = "Number of Competitors per Weight Class by Gender") +
  theme_minimal() +  # Use a minimal theme for cleaner appearance
  theme(
    axis.text.y = element_text(size = 10),  # Adjust y-axis text size for better readability
    plot.title = element_text(hjust = 0.5)  # Center the plot title
  )




#highest and lowest number of competitor for each weight class
# male
# Count the number of competitors for each weight class for males
male_weight_class_count <- male_data %>%
  count(WeightClassKg) %>%
  arrange(desc(n))

# Highest weight class for males
highest_male_weight_class <- male_weight_class_count %>%
  arrange(desc(n)) %>%
  slice(1)

# Lowest weight class for males
lowest_male_weight_class <- male_weight_class_count %>%
  arrange(n) %>%
  slice(1)

# View results
print(highest_male_weight_class)
print(lowest_male_weight_class)

# female
female_weight_class_count <- female_data %>% 
  count(WeightClassKg) %>% 
  arrange(desc(n))

# Highest weight class for males
highest_female_weight_class <- female_weight_class_count %>% 
  arrange(desc(n)) %>% 
  slice(1)
# Lowest weight class for males
lowest_female_weight_class <- female_weight_class_count %>%
  arrange(n) %>%
  slice(1)

# View results
print(highest_female_weight_class)
print(lowest_female_weight_class)

#do we need a trend??!!!!!




#wining weight to body weight class ration

