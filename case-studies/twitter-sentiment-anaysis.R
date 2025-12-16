## Tapwater tweet sentiment analysis
library(tidyverse)
library(tidytext)

# library(twitteR)
# 
# source("case-studies/twitter-api.R") ## Secret keys
# setup_twitter_oauth(consumer_key, consumer_secret, acess_token, access_secret)
# 
# ## Extract tap water tweets
# tapwater_tweets <- searchTwitter("tap water", n = 1000, lang = "en") %>%
#   twListToDF() %>%
#   select(id, text)
# tapwater_tweets <- subset(tapwater_tweets, !duplicated(tapwater_tweets$text))
# tapwater_tweets$text <- gsub("’", "'", tapwater_tweets$text)
# 
# write_csv(tapwater_tweets, paste0("data/tapwater-tweets-", Sys.time(), ".csv"))

tapwater_tweets <- read_csv("data/tapwater_tweets.csv")

## Tokenise and clean the tweets
tidy_tweets <- tapwater_tweets %>%
  unnest_tokens(word, text)

data(stop_words)

tidy_tweets <- tidy_tweets %>%
  anti_join(stop_words) %>%
  filter(!word %in% c("tap", "water", "rt", "https", "t.co", "gt", "amp",
                      as.character(0:9)))
## Most common words
tidy_tweets %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col(fill = "dodgerblue4") +
  xlab(NULL) + coord_flip() +
  theme_bw(base_size = 20) + 
  ggtitle("Most common words in tap water tweets")

## Sentiment analysis
sentiment_bing <- tidy_tweets %>%
  inner_join(get_sentiments("bing"))

sentiment_bing %>%
  summarise(Negative = sum(sentiment == "negative"), 
            positive = sum(sentiment == "positive"))

sentiment_bing %>%
  group_by(sentiment) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) + 
  coord_flip() +
  facet_wrap(~sentiment, scales = "free_y") + 
  labs(title = "Contribution to sentiment", x = NULL, y = NULL)
