These files contain the useful columns returned by the Twitter API.
These are: tweetID, date-Created, tweet-text, number of retweets and favourites.

there should be at least one file in every period of one week so that there are no gaps in
the timeline. Should there be a gap, either the tweets from that time period must be obtained
by other means (scraped or bought), or the final model will suffer in some way, depending on how
the missing data is dealt with.

The text still must be cleaned, replicates should be removed (using the unique tweetIDs)
and the everyting must be collated into one or several csv files to be put through the 
Sentiment Analysis models.


