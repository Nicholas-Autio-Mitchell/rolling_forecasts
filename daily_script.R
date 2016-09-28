###################### ==================================== ######################
######################  Twitter mining - rolling forecasts  ######################
###################### ==================================== ######################

#' This script must be at least once per week to ensure all obtainable tweets are indeed obtained.
#' 'obtainable' because Twitter actually pre-filters slightly, returning only the most relevant or popular
#' 
#' When mining, we receive tweets for the last seven days, so if we perform this
#' script once every week, we should get a continuous timeline of tweets to analyse

library(twitteR)
library(ROAuth)

# Set up the Twitter API (only needs to be done once per session)
# This can also be executed using the document 'oauth_info.R'
# First save the keys that were defined and supplied by Twitter when creating the API
consumerKey <- 'aRE1YNfXXaw15M4MIs6w9JpY9'
consumerSecret <- 'dluHwkkzokjSusKGD6soLCSYTVUTtYEi326xDuliyHr36xpCtL'
accessToken <- '3402568396-mygMgTzp0tr3on7ySLRp4PUesc1odyELnkznnsy'
accessTokenSecret <- 'OzgNs8hh2HWPdRYoFwgYiK3Hs8OzOtVNoy5eGFcgaMofs'
# Use these keys to supply the handle function provided by package 'twitteR'
setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)

## We have to just enter this "1" to accepth the direct authentication (we don't need to keep connecting the API for this sesison)
1

## Give the package a chance to respond
Sys.sleep(3)

# Clear the workspace --> these are not longer needed for the session as the API must only be activated once
remove(consumerKey, consumerSecret, accessToken, accessTokenSecret)

## ================= ##
##  Search criteria  ##
## ================= ##

## We can expand this (if the script becomes automated) to enter the dates dynamically depending on Sys
today <- substr(as.character(Sys.time()), 1, 10) #today's date in a form we can use

## We can specify 14 days to extract, as we will be removing any replicates later
## Hence we go back more than the tens days we expect to receive to cover overlaps in script exectution
past <- substr(as.character(as.Date(Sys.time()) - 14), 1, 10) #today's date in a form we can use

## Createa data.table of search terms to use
searchTerms <- c(
    `bear_market` =      "bear+market",     
    `bull_market` =      "bull+market",                 
    `$SPX` =              "$SPX",  #must be later renamed to remove $
    `dow_jones` =        "dow+jones",          
    `dow_wallstreet` =   "dow+wallstreet",     
    `emerging_markets` =  "emerging+markets",
    `federal_reserve` =   "federal+reserve",   
    `financial_crisis` = "financial+crisis",   
    `goldman_sachs` =    "goldman+sachs",      
    `#SPX` =              "#SPX", #must be later renamed to remove #
    `interest_rates` =   "interest+rates",     
    `market_volatility` = "market+volatility",
    `obama_economy` =    "obama+economy",      
    `oil_prices` =       "oil+prices",         
    `stock_prices` =      "stock+prices"  
)

## A version with nicer names
myTerms <- c(
    `bear_market` =       "bear+market",     
    `bull_market` =       "bull+market",                 
    `dollarSign.SPX` =         "dollarSPX",  #must be later renamed to remove $
    `dow_jones` =         "dow+jones",          
    `dow_wallstreet` =    "dow+wallstreet",     
    `emerging_markets` =  "emerging+markets",
    `federal_reserve` =   "federal+reserve",   
    `financial_crisis` =  "financial+crisis",   
    `goldman_sachs` =     "goldman+sachs",      
    `hash.SPX` =           "hashSPX", #must be later renamed to remove #
    `interest_rates` =    "interest+rates",     
    `market_volatility` = "market+volatility",
    `obama_economy` =     "obama+economy",      
    `oil_prices` =        "oil+prices",         
    `stock_prices` =      "stock+prices"
)

## To ensure all possible tweets are returned, specify a huge desired maximum
maxTweets <- 99999                      #there will be a warning message

# Set which results we want to receive. Either most recent ('recent'), most popular ('popular') or a mixture ('mixed)
resultSort <- 'recent'

## =============================== ##
##  Create object to store tweets  ##
## =============================== ##

## We need a list of of the dates on which the script is executed
## Each element of the list holds the results of one of the search terms
## We only need to hard-code the first date that is used as following
## dates are dynamically appended

raw_tweets <- sapply(c("extraction.42"), function(x) NULL) #Adjust the number of extraction each time

search_terms <- sapply(myTerms, function(x) NULL)

for(i in length(raw_tweets)) {raw_tweets[[i]] <- search_terms}

## ==================== ##
##  Extract the tweets  ##
## ==================== ##


## Perform in three chunks to not overload the API limits
## Chunk one
for(i in 1:(length(searchTerms)/3)) {
    
    raw_tweets[[1]][[i]]<- searchTwitter(searchTerms[i], n = maxTweets, since = today, lang = "en", resultType = resultSort)

}    

Sys.sleep(5*60)                       #attempt to prevent time out


## Chunk two
for(i in 6:(2*(length(searchTerms)/3))) {
    
    raw_tweets[[1]][[i]]<- searchTwitter(searchTerms[i], n = maxTweets, since = today, lang = "en", resultType = resultSort)

}

Sys.sleep(5*60)

## Chunk three
for(i in 11:length(searchTerms)) {
    
    raw_tweets[[1]][[i]]<- searchTwitter(searchTerms[i], n = maxTweets, since = today, lang = "en", resultType = resultSort)

}    


## ----------------------------------- ##
##  Convert all data into data frames  ##
## ----------------------------------- ##

all_tweets <- sapply(myTerms, function(x) NULL)
## Extract to data tables
for(i in 1:length(searchTerms)) {

    if(length(raw_tweets[[1]][[i]]) > 0) {
        all_tweets[[i]] <- as.data.table(twListToDF(raw_tweets[[1]][[i]]))
    } else {
        message(paste0("There were zero tweets for the search term: '", searchTerms[i], "'"))
        all_tweets[[i]] <- 0
    }
}

## ============================ ##
##  Extract useful information  ##
## ============================ ##

## ## for each search term we have the following data column (some are empty / NA / NULL)
##  [1] "text"          "favorited"     "favoriteCount" "replyToSN"     "created"       "truncated"     "replyToSID"    "id"            "replyToUID"    "statusSource" 
## [11] "screenName"    "retweetCount"  "isRetweet"     "retweeted"     "longitude"     "latitude"     

## the ones to keep
to_retain <- c("text", "favoriteCount", "created", "id", "screenName", "retweetCount")

## Create object to house the useful information
retained_info <- sapply(myTerms, function(x) NULL)
## Extract
for(i in 1:length(all_tweets)) {

    ## >1 because if there were zero tweets, a value of zero (i.e. length ==1) exists
    ## Just check back when extracting tweets. there each terms returned double figures, i.e. >9
    if (length(all_tweets[[i]]) > 1) {
    retained_info[[i]] <- subset(all_tweets[[i]], select = to_retain)
    } else {
        retained_info[i] <- NULL      # delete any search terms that didn't appear in this data range
    }
}

## Convert dates to type Date (were POSIXct)
for(i in 1:length(retained_info)) {(retained_info[[i]])[, created := as.Date(created)]}

## change to order of the columns and rename them
for(i in 1:length(retained_info)) {
    
    setcolorder(retained_info[[i]], c("created", "id", "screenName",
                                      "retweetCount", "favoriteCount", "text"))
    names(retained_info[[i]]) <- c("date", "tweetID", "userName", "retweetCount",
                                   "favouriteCount", "text")
}

retained_info.5 <- copy(retained_info)

## Save a copy of the retained information
file_name <- paste0("/Volumes/Mac\ OS\ Drive/Documents/Rolling\ forecasts/Twitter/raw_data/retained_info_", today, ".rda")
save(retained_info.5, file = file_name)

