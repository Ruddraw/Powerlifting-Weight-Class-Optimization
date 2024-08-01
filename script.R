#load required packages
library(readr)
library(kaggler)
library(dplyr)

#set the API
response <- kgl_datasets_download_all(owner_dataset = "ashley93/openpowerlifting")
download.file(response[["url"]], "data/temp.zip", mode="wb")
unzip_result <- unzip("data/temp.zip", exdir = "data/", overwrite = TRUE)
powerlift_data <- read.csv("data/openpowerlifting.csv")

colnames(powerlift_data)

final_df <- powerlift_data %>% 
  select(Name, Sex, Age, Division, BodyweightKg, WeightClassKg, BestSquatKg, BestBenchKg, BestDeadliftKg, TotalKg, Place)

View(final_df)
