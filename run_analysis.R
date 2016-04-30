library(dplyr)
library(tidyr)

# check to see if the data sets have been read already or not (reading this is expensive)
if(!(exists("unioned_df"))) {
  # we'll read both of the datasets (X_test.txt & X_train.txt), and remember that each row starts with a space character, but after that, every number takes 16 characters, including a space between them.
  # since some numbers are negative and som positive, a space is a reserved character when there is no minus sign, which makes whis dataset a fixed-width data files.
  # and since the first column as an extra space at the start, we'll express the width parameter as 17 and 16 X 560 times.
  train_df <- tbl_df(read.fwf("./uci-har-data/train/X_train.txt",widths = c(17, rep(16, 560)), header = FALSE))
  test_df <- tbl_df(read.fwf("./uci-har-data/test/X_test.txt",widths = c(17, rep(16, 560)), header = FALSE))
  
  # we'll extract all the features names
  features <- tbl_df(read.csv("./uci-har-data/features.txt", header = FALSE, sep = ' '))
  names(features) <- c("feature_id", "feature_name")
  
  # each dataset will receive the column names as extracted from the features file
  names(train_df) <- features$feature_name
  names(test_df) <- features$feature_name
  
  # we will bind the activity id from each dataset (Y_test.txt & Y_train.txt)
  train_df <- bind_cols(read.csv("./uci-har-data/train/y_train.txt", header = FALSE, col.names = c("activity_id")), train_df)
  test_df <- bind_cols(read.csv("./uci-har-data/test/y_test.txt", header = FALSE, col.names = c("activity_id")), test_df)
  
  # we will bind the subject id from each dataset (subject_train.txt & subject_test.txt)
  train_df <- bind_cols(read.csv("./uci-har-data/train/subject_train.txt", header = FALSE, col.names = c("subject_id")), train_df)
  test_df <- bind_cols(read.csv("./uci-har-data/test/subject_test.txt", header = FALSE, col.names = c("subject_id")), test_df)
  
  # time to union the two datasets
  unioned_df <- bind_rows(train_df, test_df)
  
  # we'll read the activities files to match activity_id to activity_name and join back to the full dataframe
  activities <- tbl_df(read.csv("./uci-har-data/activity_labels.txt", header = FALSE, sep = ' ', col.names = c("activity_id", "activity_name")))
  unioned_df <- inner_join(unioned_df, activities, by = "activity_id")
}

# select only columns with intresting information (subject_id, actvity_name and features with mean() or str())
unioned_df_selected_cols <- select(unioned_df, subject_id, activity_name, contains("mean()"), contains("std()"))

# break all columns which are not variables into observations
gathered <- gather(unioned_df_selected_cols, key = measure, value = value, -subject_id, -activity_name)

# spread each measure to variable_name, aggreagte and axis variables - This will generate NA for axis variable where no axis is specified
tidy_df <- separate(data = gathered, col = measure, into = c("variable_name", "aggregate", "axis"), sep = '-', remove = TRUE, fill = "right")

# some values cleanup (remove parenthasis, convert to factors where appropriate)
tidy_df$aggregate <- gsub(x = tidy_df$aggregate, pattern = "[^a-zA-Z]", replacement = "")
tidy_df$variable_name <- as.factor(tidy_df$variable_name)
tidy_df$aggregate <- as.factor(tidy_df$aggregate)
tidy_df$axis <- as.factor(tidy_df$axis)

# write out the tidy dataset
if(file.exists("./tidy_df.csv")) { file.remove("./tidy_df.csv") }
write.csv(x = tidy_df, file = "./tidy_df.csv", row.names = F)

# summarize the dataset with avrages
avg_df <- tidy_df %>% group_by(subject_id, activity_name, variable_name, aggregate, axis) %>% summarise(mean(value))

# write out the avrage tidy dataset
if(file.exists("./avg_tidy_df.csv")) { file.remove("./avg_tidy_df.csv") }
write.csv(x = avg_df, file = "./avg_tidy_df.csv", row.names = F)