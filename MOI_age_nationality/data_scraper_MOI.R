# travel data scraper

# First we'll import a ministry of interior excel spreadsheet that has entry statistics stratified by sex
# and then by age
# and then again by nationality 
# 3+ separate datasets mushed together U+1F644

library(readxl)
url <- "https://ws.moi.gov.tw/001/Upload/400/relfile/0/4413/79c158fd-d51f-4061-b24b-fbcdb0fb92d9/month/m6-01.xls"
destfile <- "m6_01.xls"
curl::curl_download(url, destfile)
MOI_inbound <- read_excel(destfile)


# and then per normal, we're going to write ~ 2 billion lines of code to get the data in a useable format
# bc Taiwan's MOI loves horribly formated excel files U+1F644 U+1F644 U+1F644

## 1. Rename columns

################################################################################

#first we're going to check to see if the MOI_inbound dataframe is a tibble
# and then if it is convert from tibble to dataframe, bc I actually prefer base R sometimes

if(class(MOI_inbound)=="tbl_df"){
  MOI_inbound <- as.data.frame(MOI_inbound)
}

# I think that warning is safe to ignore bc we're only converting one file 
#lazyprogramming


###################################################################################

# It looks like the third row is the one where most of the actual variable names are U+1F644

new_column_names <- MOI_inbound[3,]

# and now we're going to name a few columns that were named with a non-descriptive name U+1F644
# or have spaces and other weird characters

new_column_names[1,c(1:2,5:8,10:11)] <- c("date","total_entries", "ages0_14","ages15_64","ages65_up","nationals_registered","HK_Macao","nationals_unregistered")

# now we make the values new_column_names the new column names for MOI_inbound

colnames(MOI_inbound) <- new_column_names

#############################################################################

# 2. Remove unneeded rows

# We'll start by removing the first 3 rows and the bottom 4 rows bc they don't actually contain any data

# this will create a more general case that can be used for other MOI datasets
# assuming that they use a consistent format for these excel file monstrosities U+1F644

a <- nrow(MOI_inbound)
b <- a-3

#it also makes this code easier to read:

MOI_inbound <- MOI_inbound[-c(1:3,b:a),]




#################################################################################
# remove intermediate data files    ############################################
###############################################################################

rm(new_column_names,a,b,destfile,url)
file.remove("m6_01.xls")

###############################################################
##  save dataframe
#################################################################

write.csv(MOI_inbound, file = "./data/MOI_inbound.csv")
