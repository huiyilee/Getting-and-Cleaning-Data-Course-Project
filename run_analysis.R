## Read the subject, x and y files for the test data sets into R. 

subject_test <- read.table("subject_test.txt", sep = "", header = FALSE)
x_test <- read.table("X_test.txt", sep = "", header = FALSE)
y_test <- read.table("y_test.txt", sep = "", header = FALSE)

## Read the subject, x and y files for the train data sets into R. 

subject_train <- read.table("subject_train.txt", sep = "", header = FALSE)
x_train <- read.table("X_train.txt", sep = "", header = FALSE)
y_train <- read.table("y_train.txt", sep = "", header = FALSE)

## Section 1 - Add columns for ID and activity to each of the training and test data sets.  

test <- cbind(subject_test, y_test, x_test)
train <- cbind(subject_train, y_train, x_train)

## Merge the training and test sets into one data set.

combine <- rbind(test, train)

## Section 2 - Generate vector with column numbers corresponding to the variables we want to extract. 

meanstd <- c(1:8, 43:48, 83:88, 123:128, 163:168, 203:204, 216:217, 229:230, 242:243, 255:256, 268:273, 347:352, 426:431, 505:506, 518:519, 531:532, 544:545) 

## Convert into a numeric vector

meanstd_num <- as.numeric(meanstd)

## Extract only columns relating to mean and standard deviation for each type of measurement (e.g. tBodyAcc, tGravityAcc, etc.), for both test and train data sets.

combine_subset <- combine[, meanstd_num]


## Section 3 - Add a column with descriptive activity names to the "combine_subset" data set.  

activity_name <- read.table("activity_labels.txt", sep = "", header = FALSE)
combine_subset$activity_name <- activity_name$V2[match(combine_subset$V1.1, activity_name$V1)]

## Section 4 - Read the features file into R. 

features <- read.table("features.txt", sep = "", header = FALSE)
summary(features) 

## Subset the "features" dataframe to get only rows corresponding to the variables we want to extract. We also want to subset for the 2nd column, i.e. to retrieve descriptive variable names

meanstd2 <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254, 266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543) 
meanstd2_num <- as.numeric(meanstd2)

features_subset <- features[meanstd2_num, 2]
features_subset <- as.data.frame(features_subset)

## Add column names in "features_subset" vector to "combine_subset" dataframe 

colnames(combine_subset)[3:68] <- as.character(features_subset[, 1])
colnames(combine_subset)[1:2] <- c("ID", "activity")


## Section 5 - Reorder rows by ID and activity

combine_order <- combine_subset[order(combine_subset[, 1], combine_subset[, 2]), ]

## Generate interaction variable based on each ID and activity, gives it header "int", and appends this to RHS of the finalised dataframe "combine_order" from part 4 above. 

combine_order$int <- with(combine_order, interaction(ID, activity))

## Check for columns that have NA values

list_na <- colnames(combine_order)[apply(combine_order, 2, anyNA)]

## Install relevant package

install.packages("reshape")
library(reshape) 

## Melt data while keeping all the factor variables constant, i.e. "ID", "activity", "activity_name", "int". 

meltdata <- melt(combine_order, id = c("ID", "activity", "activity_name", "int"))

## Apply cast function to get mean for each value of the "int" variable, i.e. for each ID and activity.

recast <- cast(meltdata, ID+activity+activity_name+int ~ variable, mean)

recast <- cast(meltdata, int ~ variable, mean)

## Write "recast" dataframe to a text file

write.table(recast, "C3W4_solution.txt", row.names = FALSE, col.names = TRUE)