Coursera Getting and Cleaning Data Class Project
================================================

The data used for this analysis is credited to the following source:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

The actual data used for analysis was downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) on December 17, 2014.

The attached [run_analysis.R](https://github.com/coursera10062014/gettingdataproject/blob/master/run_analysis.R)
script will download, unpack, and clean up the data set for the class
programming assignment.

The file contains one function for each major aspect needed to construct
the tidy file set.  That task can be though of as the following blocks:
   
   * Obtain the data set.  The assignment asks that we assume the data set is present.  I go one step further and download and unzip the file as needed.
   * Load the main feature table.  The values come in as strings, so I convert them to numerics.
   * Annotate that data table with column labels from the feature info file.  The names are not suitable as names as-is, so some cleanup is done.
   * Add two additional columns annotating each data series with the subject and what activity they were performing.
   * Filter the columns to get only mean and standard errors.
   
With that done, I then compute a tidy set containing the mean of the cells
bucketed by the combination of subject plus activity.

That final data set is what is submitted.

Columns
=======

Activity: A factor indicating what the subject was doing during this
          set of measurements.  One of "LAYING", "SITTING",
          "STANDING", "WALKING", "WALKING_DOWNSTAIRS",
          or "WALKING_UPSTAIRS".  These are self explanatory.
          
Subject: A numeric identifier in the range 1-30, identifying which human
   these measurements were taken from.
   
All the rest of the columns contains the mean of a given metric for the
combination of Activity and Subject.  The remaining column names all take
the form Metric.Aggregate.Axis.

Metric is taken either in the time dimension, in which case it has a
prefix of t, or it is taken in the frequency dimension in which case it
has a prefix of f.  There were many factors coded in the original metric
names, and I've left them mostly intact.  You can see Body and Gravity
factors separated, then combined in a whole.  For detailed explanations
of the individual metrics, please see the README.txt file in
[this zip archive](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

The aggregate is either mean, or std.  The former indicates the cell
contains the average of all measurements for that metric for the activity
and subject.  The latter, std, indicates the cell holds the standard
deviation of the same measurements.

Lastly, X, Y, and Z axes are represented by those letters respectively.
The original data does not specify their geometry origin, so neither
do I.

Units
=====

Acceleration units are in multiples of 'g', the surface gravity of the earth.
Jerk is presumed to be the derivative of that, so g per second.  Gyro readings
are in radians per second.  GyroJerk units are radians per second per second.
