# run_analysis.R
# script is reproducible, hence everyone can run it and it will be working
#1. activate packages
library(tidyverse)
library(reshape2)


#2. downloading dataset and preparing variables
raw_dt_dir <- "./dtraw"
raw_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
raw_dt_file <- "raw_dt.zip"
raw_dt_route <- paste(raw_dt_dir, "/", "raw_dt.zip", sep = "")
proj_dir <- "./projdata"

if (!file.exists(raw_dt_dir)) {
     dir.create(raw_dt_dir)
     download.file(url = raw_url, destfile = raw_dt_route)
}
if (!file.exists(proj_dir)) {
     dir.create(proj_dir)
     unzip(zipfile = raw_dt_route, exdir = proj_dir)
}


#3. loading data into R regarding needed variables:
# data about train(trn shortcut)
x_trn <- read.table(paste(sep = "", proj_dir, "/UCI HAR Dataset/train/X_train.txt"))
y_trn <- read.table(paste(sep = "", proj_dir, "/UCI HAR Dataset/train/Y_train.txt"))
s_trn <- read.table(paste(sep = "", proj_dir, "/UCI HAR Dataset/train/subject_train.txt"))

# data about test(tst shortcut)
x_tst <- read.table(paste(sep = "", proj_dir, "/UCI HAR Dataset/test/X_test.txt"))
y_tst <- read.table(paste(sep = "", proj_dir, "/UCI HAR Dataset/test/Y_test.txt"))
s_tst <- read.table(paste(sep = "", proj_dir, "/UCI HAR Dataset/test/subject_test.txt"))

# merge {train, test} data(dt shorcut)
x_dt <- rbind(x_trn, x_tst)
y_dt <- rbind(y_trn, y_tst)
s_dt <- rbind(s_trn, s_tst)


#4. loading data regarding feature & activity:
# getting data bout feature(ftr)
ftr <- read.table(paste(sep = "", proj_dir, "/UCI HAR Dataset/features.txt"))

# calling labels on activities
a_lbl <- read.table(paste(sep = "", proj_dir, "/UCI HAR Dataset/activity_labels.txt"))
a_lbl[,2] <- as.character(a_lbl[,2])

# selecting and tidying features and its names
sel_cols <- grep("-(mean|std).*", as.character(ftr[,2]))
sel_cn <- ftr[sel_cols, 2]
sel_cn <- gsub("-mean", "Mean", sel_cn)
sel_cn <- gsub("-std", "Std", sel_cn)
sel_cn <- gsub("[-()]", "", sel_cn)


#4. calling descriptors and selecting necessary cols
x_dt <- x_dt[sel_cols]
full_dt <- cbind(s_dt, y_dt, x_dt)
colnames(full_dt) <- c("subject", "activity", sel_cn)

full_dt$activity <- factor(full_dt$activity, levels = a_lbl[,1], labels = a_lbl[,2])
full_dt$subject <- as.factor(full_dt$subject)


#5. melting data and generating final data set
mlt_dt <- melt(full_dt, id = c("subject", "activity"))
final_dt <- dcast(mlt_dt, subject + activity ~ variable, mean)

write.table(final_dt, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
