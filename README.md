# coursera-getting-and-cleaning-data-course-project
Coursera getting and cleaning data course project

##Prerequisites
In order to use this program, check that dplyr package is installed and modify working directory according to preferred path on your own computer.

##How it works
Program runs through few key steps, summarized here below:
- working directory is set, a 'data' subdirectory is created (if not already available) and project files downloaded to such directory and uncompressed;
- activity, subject and variables data sets from both train and test groups are read in from file, they are concatenated by row and then binded by column in a unique data frame;
- a subset of data frame created at previous step is retained, containing only columns related to mean() and std() computations, further to key columns about activity and subject;
- activity descriptive textss are read in from file, joined to reference data frame above, original integer activity column substituted with a factor description column, always named 'activity'
- column names are partly modified in order to keep them more descriptive;
- a final new tidy data set is created, providing a summary of mean values for each variable, grouped by activity and subject.

##Final outcome
Two tidy data sets are produced: 
- first one containing all (test and train) data sets for variables reporting mean() and std() values, plus activity and subject;
- a summary data set reporting mean of variables values (note that they are mean of mean or std values) grouped by activity and subject.
