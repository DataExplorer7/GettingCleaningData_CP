
        # Read features.txt, convert them to character type and keep just the column
        # with the features names. This is done so that I can label the columns in the merged dataset
        # automatically.
        features <- read.csv("./UCI HAR Dataset/features.txt",header = FALSE, sep="")
        features <- data.frame(lapply(features, as.character), stringsAsFactors=FALSE)
        features <- features[,2]
        
        # Read subject_train.txt
        subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt",header = FALSE, sep="")
        # Read X_train.txt and name the variables from the features dataframe (Ex.4 of Course Project)
        x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt",header = FALSE, sep="")
        names(x_train) <- features
        # Read y_train.txt
        y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt",header = FALSE, sep="")
        
        #Bind the columns of all train datasets (merge)
        train_dataset <- cbind(subject_train,x_train,y_train)
        
        # Read subject_test.txt
        subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt",header = FALSE, sep="")
        # Read X_test.txt and name the variables from the features dataframe (Ex.4 of Course Project)
        x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt",header = FALSE, sep="")
        names(x_test) <- features
        # Read y_test.txt
        y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt",header = FALSE, sep="")
        
        #Bind the columns of all test datasets (merge)
        test_dataset <- cbind(subject_test,x_test,y_test)
        
        #Create the combined dataset,including both test and train data (Ex.1 of Course Project)        
        dataset <- rbind(train_dataset,test_dataset)
        
        #Change the names of the Subject and Activity variables (Ex.4 of Course Project)
        names(dataset)[1] <- "Subject"
        names(dataset)[563] <- "Activity"
        
        #Filter automatically all features that refer to mean and standard deviation (Ex.2 of Course Project)
        dataset_mean_std <- select(dataset,Subject,Activity,contains("mean()"),contains("std()"))
        #Convert the Activity value to factor
        dataset_mean_std$Activity <- factor(dataset_mean_std$Activity)
        #Rename the Activity levels (Ex.3 of Course Project)
        levels(dataset_mean_std$Activity) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
        #Convert the Subject value to factor
        dataset_mean_std$Subject <- factor(dataset_mean_std$Subject)
                
        #Create a tidy dataset with the average of each variable grouped by Subject and Activity (Ex.5 of Course Project)
        tidy_dataset <- ddply(dataset_mean_std, .(Subject,Activity), colwise(mean))
        
        #Write the tidy dataset to a text file
        write.table(tidy_dataset, file= "./UCI HAR Dataset/week3_proj_tidy_dataset",row.names=FALSE,col.names=TRUE)
