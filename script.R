#load required packages
library(tidyr)
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
         BestBenchKg, BestDeadliftKg, TotalKg, Place) %>% 
  filter(!is.na(Name) & !is.na(Sex) & !is.na(Age) & !is.na(Division) & 
           !is.na(BodyweightKg) & !is.na(WeightClassKg) & !is.na(BestSquatKg) &
           !is.na(BestBenchKg) & !is.na(BestDeadliftKg) & !is.na(TotalKg) & 
           !is.na(Place))

# Define age groups
final_df <- final_df %>%
  mutate(AgeGroup = case_when(
    Age < 20 ~ "Teen",
    Age >= 20 & Age < 40 ~ "Open",
    Age >= 40 & Age < 60 ~ "Master 40-59",
    Age >= 60 ~ "Master 60+",
    TRUE ~ "Unknown"
  ))

View(final_df)


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






#wining weight to body weight class ratio 
# Define the function
get_top_places <- function(df, division_input, weight_class_input) {
  df %>%
    filter(Division == division_input, WeightClassKg == weight_class_input) %>%
    arrange(desc(TotalKg)) %>%
    slice(1:3) %>%
    mutate(Place = row_number()) %>%  # Add place column
    select(WeightClassKg, BestBenchKg, BestSquatKg, BestDeadliftKg, TotalKg, Place) %>%
    arrange(Place)  # Arrange by Place for a cleaner output
}

# Example usage
result <- get_top_places(male_data, "Amateur Junior (20-23)", 67.5)
print(result)




# Box plot for total weight lifted by male age group 
ggplot(male_data, aes(x = AgeGroup, y = TotalKg, fill = AgeGroup)) +
  geom_boxplot(outlier.colour = "black", outlier.size = 2) +  # Box plot with outliers
  stat_summary(
    fun = mean,  # Function to calculate mean
    geom = "point",  # Geometric object to use for mean values
    color = "black",  # Color of the mean points
    size = 3,  # Size of the mean points
    shape = 18  # Shape of the mean points
  ) +
  stat_summary(
    fun = mean,  # Function to calculate mean
    geom = "text",  # Geometric object to use for mean values
    color = "black",  # Color of the text labels
    size = 3,  # Size of the text labels
    vjust = -1,  # Vertical adjustment of the text labels
    aes(label = round(..y.., 1))  # Label with rounded mean values
  ) +
  labs(x = "Age Group", y = "Total Weight Lifted (kg)", 
       title = "Distribution of Total Weight Lifted by Male Age Group") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)  # Center the plot title
  )


# box plot for total weight lifted my female age group 
ggplot(female_data, aes(x = AgeGroup, y = TotalKg, fill = AgeGroup)) +
  geom_boxplot(outlier.colour = "black", outlier.size = 2) +  # Box plot with outliers
  stat_summary(
    fun = mean,  # Function to calculate mean
    geom = "point",  # Geometric object to use for mean values
    color = "black",  # Color of the mean points
    size = 3,  # Size of the mean points
    shape = 18  # Shape of the mean points
  ) +
  stat_summary(
    fun = mean,  # Function to calculate mean
    geom = "text",  # Geometric object to use for mean values
    color = "black",  # Color of the text labels
    size = 3,  # Size of the text labels
    vjust = -1,  # Vertical adjustment of the text labels
    aes(label = round(..y.., 1))  # Label with rounded mean values
  ) +
  labs(x = "Age Group", y = "Total Weight Lifted (kg)", 
       title = "Distribution of Total Weight Lifted by Feale Age Group") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)  # Center the plot title
  )

# ANOVA to test if there are significant differences in performance between age groups
anova_result <- aov(TotalKg ~ AgeGroup, data = male_data)
summary(anova_result)

# post-hoc test
tukey_result <- TukeyHSD(anova_result)
print(tukey_result)



