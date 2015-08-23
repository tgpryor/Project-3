# Introduction

The script `run_analysis.R`performs the following steps described in the course project's definition:

* Data is loaded from unzipped flat files
* Activity, Subject, and Feature row data are concatenated, using rbind(), since these have the same number of columns and refer to the same entities
* Only the mean and standard deviation columns are kept
* Columns are given descriptive names, based on the features flat file
* Activity values are given descriptive labels based on the activity_labels flat file
* Descriptive column names are provided globally
* The tidied data is output as a flat file called tidy.txt
