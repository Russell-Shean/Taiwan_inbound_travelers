# this reads the csv file into R as a data frame

visa_categories <- read.csv("./data/inbound_travelers_purpose.csv")

# the column names are weird, so we're going to make them more descriptive
# and easier to use

#This takes the existing column names 
#and splits all the column names at the "."
# the [] is neccesary because periods are regular expression characters
# and do weird things if you don't escape (put the brackets around them)

split_columns <-  strsplit(x=colnames(visa_categories),split="[.]")

# new_columns is a list with each element being a vector representing the old column names
# each vector contains all the words that were in the original column name
# so then we'll take the first word in each vector
# using a loop

# Befor the fore loop let's make a new empty vector to put the first words into

new_columns <- vector(mode = "character")

for(i in 1:length(split_columns)){
  new_columns <- c(new_columns, split_columns[[i]][1])
}


# now we'll change the first column name bc it's really the year
# and make the %change category a little bit more clear

new_columns[c(1,3)] <- c("year","percent_change")

#now we replace the old column names with new_columns
colnames(visa_categories) <- new_columns


# there are commas in the middle of the numbers that need to be removed

visa_categories <- apply(visa_categories,   # apply applies a function to each column in a data frame
           2,                 # 2 specifies that you want to apply the function to each column instead of each row (which would be 1)
           function(x){gsub(",","",x)})   # this is the function we're applying

# gsub looks for "," and replaces them with blank space


# apply simplifies the data frame to a matrix
# which we'll need to convert to a dataframe
#but first we'll convert the characters to numbers
visa_categories <- as.numeric(visa_categories)

#one NA was introduced, but that's okay because it makes
# sense to be NA here
#now convert to matrix, then datafram:
visa_categories <- matrix(visa_categories, nrow = 39)
visa_categories <- as.data.frame(visa_categories)

# and then reattach the column names lol
colnames(visa_categories) <- new_columns




###################################################
##  graphing
##################################################

library(ggplot2)
library("scales")
library(dplyr)
library(reshape2)

#first we're going to change the dataframe format
#for faster stratification in ggplot

#remove the percent change column
visa_categories_melt <- visa_categories %>%
  select(-percent_change)

#this changes the data frame to a long form
visa_categories_melt <- melt(visa_categories_melt, 
                             id.vars = c("year") )%>%
  mutate(visa_type = as.character(variable))

labels(visa_categories_melt) <- c("Year","Entries","Visa Category")


# we only really care about post 2015?
visa_categories_melt %>%
  filter(year > 2015)%>%     # this filters out anything before or at 2015
  ggplot()+                 # this calls the plot using the dataframe you just piped in
  geom_line(                #geom_line makes a line graph, other geoms make other types of graphs
    aes(x=year,             # this makes year the x axis
                y=value,    # this the number of visitors the y axis
                color= variable)) + #this stratifies and colors by visa category
  ggtitle("Inbound visitors to Taiwan stratified by visa category")+
  ylab("People Entering Taiwan")+
  scale_y_continuous(labels = comma)+  #this changes y axis format from scientific notation to commas
  labs(color="Visa Category")
