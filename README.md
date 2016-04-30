# Getting and Cleaning Data - Course project
### This repository holds the full solution for the CourseraGetting and Cleaning Data Course Project.
#### Files in this repository
1. .gitignore - a gitignore file, to remove local IDE files (RStudio) from the repository
2. README.md - This file
3. avg_tidy_df.csv - the csv with the aggregated avraged dataset for all variables (see 'process' section for more details)
4. avg_tidy_df_codebook.txt - the codebook to list and explain each variable in the avg_tidy_df.csv file
5. run_analysis.R - the R script used to create the tidy_df.csv and avg_tidy_df.csv from the raw data (see 'process' section for more details)
6. tidy_df.csv - the cleaned and tidy dataset (see 'process' section for more details)
7. tidy_df_codebook.txt - the codebook to list and explain each variable in the tidy_df.csv file
8. uci-har-data (folder) - contains the entire orginal data as downloded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (source and full description of the original dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

#### Requirments
Given the original dataset, the requirment for this solution is to mrege the training and test data sets, enrich with activity names and subject ids, extract only mean and std measurments and make the dataset tidy.

#### Process
For this task, the given R script does as follows:
  * The main datasets (uci-har-data/train/X_train.txt & uci-har-data/test/X_test.txt) using a fixed-width format.
  * The features names were read from the uci-har-data/features.txt file and matched as variable names
  * For each dataset, added columns that corrsponds to activity_id (from uci-har-data/train/Y_train.txt & uci-har-data/test/y_test.txt files) and the subject_id (uci-har-data/train/subject_train.txt & uci-har-data/test/subject_test.txt)
  * Joined the 2 datasets together (union operation) and added the activity names from the uci-har-data/activity_labels.txt file
  * Projected only the columns that intrest us for this assignment
  * Multiple variables were gathered to a single measurement variable to keep to the "tidy dataset" guidlines. Every variable that measures diffrent sensors, were gathered to a 4 concised variables ("measure_name", "axis", "aggregate", "value") where each of the first 3 variables are factorial to describe to value in the 4th variable
  * Some string cleaning and manipulation were done to the factorial values to make them more human readable, and then the tidy dataset is produced and saved
  * a second dataset is produced and saved, which describes the avreage for each of the variable in the tidy data set (subject_id, activity_id, measure, axis, aggregate)
