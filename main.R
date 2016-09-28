###################### ================================================= ######################
######################  Control script to only run model on given dates  ######################
###################### ================================================= ######################

dates <- (seq(as.Date("2016-02-05"), as.Date("2016-03-05"), by = "day"))[c(1, 5, 10, 15, 20, 25, 30)]

today <- as.Date(Sys.time())

if( today %in% dates) {

    source("/Volumes/Mac\ OS\ Drive/Documents/Rolling\ forecasts/Twitter/daily_script.R")
    print("this works!")
} else()
    

## =============================================== ##
##  Write the output of the console to a log file  ##
## =============================================== ##

con <- file("execution_log.txt")
sink(con, append=TRUE)
sink(con, append=TRUE, type="message")

## This will echo all input and not truncate 150+ character lines...
source("script.R", echo=TRUE, max.deparse.length=10000)

## Restore output to console
sink() 
sink(type="message")

## ## And look at the log...
##cat(readLines("execution_log.txt"), sep="\n")

###################### ======== ######################
######################  NO RUN  ######################
###################### ======== ######################

## ## Interesting function to see the limits of the API
## print(twitteR::getCurRateLimitInfo())


save(test.R)



(dN)/(dt)=(rN(K-N))/K,
x = 1:100
t = 1:100
r = 0.1
y <- 1/(1+(1/(x[1])-1)e^(-rt))
y <- 1/(1 + (1 / (x[1] - 1) * exp(-r * t)))
