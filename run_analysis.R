# This file contains analysis code to create a tidy view of some
# wearable computer data.  The goal of this code is to take some very
# denormalized data and clean it up.
#
# Copyright 2014 Coursera10062014.  All Rights Reserved.

library(reshape2)
library(xtable)

# The programming assignment says to write an analysis script that starts
# by assuming the data set is in the local directory.  I prefer to actually
# fetch the data.  The end result is the data in the local directory.
fetch <- function () {
  dataset_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  local_file = "dataset.zip"
  
  if (!file.exists(local_file)) {
    download.file(url = dataset_url, destfile = local_file, mode="wb")
  }
  
  if (!file.exists("UCI HAR Dataset")) {
    unzip(local_file)
  }
}
                     
# load loads one data file from the UCI dataset.  It prevents a bit of
# copy paste below.
load <- function(fn) {
  root = "UCI HAR Dataset"
  read.delim2(
    sprintf("%s\\%s", root, fn), header=FALSE, sep="",
    stringsAsFactors=FALSE)
}

# featureNames loads and cleans the names of the columns for
# featureValues().
featureNames <- function() {
  features <- load("features.txt")
  clean <- make.names(features$V2)
  # make.names turns all invalids into ".",  The "()-" in the input
  # names can turn into triple-dot.  That's ugly.  Here I convert any
  # runs of dots into  a single dot.
  gsub("\\.+", ".", clean)
}

# activityLabels constructs a clean factor label for the activities
# in each row of our data set.
activityLabels <- function() {
  y <- rbind(load("test\\y_test.txt"), load("\\train\\y_train.txt"))
  activityLabels <- load("activity_labels.txt")
  activities <- as.factor(sapply(y, function(i) { activityLabels$V2[i]}))  
}

# subjects loads the secondary data files identifying which subject
# each row of featureValues is associated with.
subjects <- function() {
  as.factor(rbind(load("test\\subject_test.txt"),
                  load("train\\subject_train.txt"))[,1])
}

# featureValues loads the main data table.
featureValues <- function() {
  x <- rbind(load("test\\X_test.txt"), load("\\train\\X_train.txt"))
  x <- as.data.frame(lapply(x, as.numeric))  
  colnames(x) <- featureNames()
  x  
}

# filterColumns picks out just the interesting columns of the feature set.
filterColumns <- function(fv) {
  # The assignment is vague on exactly which columns it wants.  I choose
  # the columns that have mean and std in the name.
  wantCols <- grep("\\.(mean|std)\\.[XYZ]$", colnames(fv))
  fv[,wantCols]
}

makeTidy <- function(f) {
  m <- melt(f, id.vars=c(1,2))
  tidy <- dcast(m, Activity + Subject ~ variable, mean)
  tidy
}

fetch()
tidy <- makeTidy(
  cbind(Subject=subjects(),
        Activity=activityLabels(), 
        filterColumns(featureValues())))
write.table(tidy, "tidy.txt", row.name=FALSE)

# The assignment asked for a table.write output, but that's hard to grade.
# Here I render the result to HTML for easy viewing:
print(xtable(tidy), type="html", file="tidy.html")
