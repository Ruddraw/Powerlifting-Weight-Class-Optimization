# Powerlifting Performance Analysis: Age Group and Weight Class Insights

## Project Overview
This project aims to analyze powerlifting performance data to uncover insights into how various factors such as age, weight class, and gender influence competitive outcomes. The analysis involves exploring the dataset for trends, comparisons, and significant differences in lifting performance across different categories.

## Data Acquisition
The data used in this project is sourced from the [Open Powerlifting dataset](https://www.kaggle.com/datasets/ashley93/openpowerlifting), which is accessible via the Kaggle API. The API provides an automated way to download datasets, and the `kaggler` R package was used to facilitate this process.

## Data Preparation

1. **Data Loading:**
   - The dataset is downloaded using the Kaggle API and read into R using the `read.csv` function.

2. **Data Cleaning:**
   - Selected columns: `Name`, `Sex`, `Age`, `Division`, `BodyweightKg`, `WeightClassKg`, `BestSquatKg`, `BestBenchKg`, `BestDeadliftKg`, `TotalKg`, and `Place`.
   - NA values are filtered out to ensure the accuracy of the analysis.

3. **Age Group Classification:**
   - Lifters are categorized into age groups: Teen, Open, Master 40-59, and Master 60+.

## Analysis

1. **Competitor Distribution:**
   - **Weight Class Counts:** Visualized using bar charts to show the number of competitors in each weight class, separated by gender.
     
![Number of Competitors per Weight Class by Gender](plots/competitor_count.png) 

   - **Highest and Lowest Competitor Counts:** Identified the weight classes with the highest and lowest number of competitors for both males and females.
     
     ```
     Weight Class Statistics

       Male
      
      | Metric             | WeightClassKg | Count |
      |--------------------|---------------|-------|
      | Highest Count      | 100           | 8142  |
      | Lowest Count       | 63            | 1     |
      
       Female
      
      | Metric             | WeightClassKg | Count |
      |--------------------|---------------|-------|
      | Highest Count      | 67.5          | 4357  |
      | Lowest Count       | 100+          | 1     |
     
     ```
2. **Performance Comparison by Age Group:**
   - **Box Plots:** Show the total weight distribution lifted across different age groups, with mean values annotated.
<div style="display: flex; justify-content: space-between;">
  <img src="plots/Distribution%20of%20Total%20Weight%20Lifted%20by%20Male%20Age%20Group.png" alt="Distribution of Total Weight Lifted by Male Age Group" width="45%" />
  <img src="plots/Distribution%20of%20Total%20Weight%20Lifted%20by%20Female%20Age%20Group.png" alt="Distribution of Total Weight Lifted by Female Age Group" width="45%" />
</div>



## Results

   - - **ANOVA Analysis for Male Data:**
     
     ```r
     anova_result <- aov(TotalKg ~ AgeGroup, data = male_data)
     summary(anova_result)
     ```
     
     The ANOVA test evaluates whether there are significant differences in the total weight lifted (`TotalKg`) among different age groups. The summary output is as follows:
     
     ```
                   Df    Sum Sq  Mean Sq F value Pr(>F)    
     AgeGroup        3 2.093e+08 69779255    4003 <2e-16 ***
     Residuals   72570 1.265e+09    17432                   
     ---
     Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
     ```

   - **Post-Hoc Test for Male Data:**
     
     ```r
     tukey_result <- TukeyHSD(anova_result)
     print(tukey_result)
     ```
     
     The Tukey's Honest Significant Difference (HSD) test provides pairwise comparisons between age groups:
     
     ```
       Tukey multiple comparisons of means
         95% family-wise confidence level

     Fit: aov(formula = TotalKg ~ AgeGroup, data = male_data)

     $AgeGroup
                               diff        lwr        upr p adj
     Master 60+-Master 40-59 -160.30725 -168.22775 -152.38675     0
     Open-Master 40-59         22.91864   19.24661   26.59067     0
     Teen-Master 40-59       -104.94334 -109.50744 -100.37924     0
     Open-Master 60+          183.22589  175.87547  190.57630     0
     Teen-Master 60+           55.36391   47.52964   63.19818     0
     Teen-Open               -127.86198 -131.34411 -124.37984     0
     ```

   - **ANOVA Analysis for Female Data:**
     
     ```r
     anova_result_female <- aov(TotalKg ~ AgeGroup, data = female_data)
     summary(anova_result_female)
     ```
     
     The ANOVA test results for females are:
     
     ```
                   Df    Sum Sq Mean Sq F value Pr(>F)    
     AgeGroup        3  10613187 3537729   550.4 <2e-16 ***
     Residuals   34826 223854760    6428                   
     ---
     Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
     ```

   - **Post-Hoc Test for Female Data:**
     
     ```r
     tukey_result_female <- TukeyHSD(anova_result_female)
     print(tukey_result_female)
     ```
     
     The Tukey's HSD results for females are:
     
     ```
       Tukey multiple comparisons of means
         95% family-wise confidence level

     Fit: aov(formula = TotalKg ~ AgeGroup, data = female_data)

     $AgeGroup
                           diff       lwr       upr p adj
     Master 60+-Master 40-59 -76.26574 -84.34580 -68.18568     0
     Open-Master 40-59        14.04575  11.15674  16.93476     0
     Teen-Master 40-59       -22.39066 -26.21663 -18.56470     0
     Open-Master 60+          90.31149  82.51807  98.10490     0
     Teen-Master 60+          53.87507  45.68795  62.06219     0
     Teen-Open               -36.43641 -39.61256 -33.26027     0
     ```

     ## Summary

The analysis reveals that:

- **Older Age Groups:**
  - Lifters in the Master 60+ category tend to lift more weight compared to younger groups (Teen and Open) for both males and females.

- **Significant Differences:**
  - There are significant differences in the total weight lifted between age groups. Older lifters generally outperform their younger counterparts.

- **Impact of Age:**
  - The observed differences in performance emphasize the impact of age on powerlifting capabilities. Older lifters, particularly those in the Master 60+ category, lift more weight compared to their younger counterparts.



