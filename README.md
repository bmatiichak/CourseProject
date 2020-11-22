## Getting and Cleaning Data - Course Project

## This is the course project for the Getting and Cleaning Data Coursera course.

## The included R script, run_analysis.R, conducts the following:

* Getting data from the web, creates files and directories if they're not existing already.

* Reading and merging datasets into x(measurements), y(activity) and subject.

* Load the data(x's) feature, activity info and extract columns named 'mean'(-mean) and 'standard'(-std). Also, modify column names to descriptive. (-mean to Mean, -std to Std, and remove symbols like -, (, ))

* Extract data by selected columns(from step 3), and merge x, y(activity) and subject data. Also, replace y(activity) column to it's name by refering activity label (loaded step 3).

* Generate 'Tidy Dataset' that consists of the average (mean) of each variable for each subject and each activity. The result is shown in the file tidy_dataset.txt.