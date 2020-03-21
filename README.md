# Getting-and-Cleaning-Data-Course-Project

This script works by reading each of the subject, x and y files for the test and train data sets into R.  It then merges the datasets into one.  

Since we only want measurements on mean and standard deviation, the script subsets the entire dataset to get just those columns with variables on mean and standard deviation. It then reads from the "activity_labels.txt" file to add descriptive labels for each activity (e.g. walking, sitting etc.). 

The script also works to label each variable in the dataset. This is mainly achieved by reading in the "features.txt" file into R, subsetting to get just those variables which specify mean and standard deviation, and then adding these column names to the main dataset.

Finally, to get the average of each variable by subject and activity, we apply the melt and cast functions, taking averages with reference to the interaction between ID and activity.
