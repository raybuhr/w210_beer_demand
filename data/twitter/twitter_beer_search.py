# -*- coding: utf-8 -*-
import os
import tweepy
import datetime
import pandas as pd
from sqlalchemy import create_engine

# Twitter authorization
consumer_key = os.environ.get('TW_CONSUMER_KEY')
consumer_secret = os.environ.get('TW_CONSUMER_SECRET')
access_token = os.environ.get('TW_ACCESS_TOKEN')
access_token_secret = os.environ.get('TW_ACCESS_SECRET')

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth_handler=auth,wait_on_rate_limit=True,wait_on_rate_limit_notify=True)

# database connection
DB_USER = os.environ.get('BEER_USER')
DB_PW = os.environ.get('BEER_PW')
db_url = 'postgresql://' + DB_USER + ':' + DB_PW + '@localhost:5432/beer'
db_con = create_engine(db_url)

# get list of beers from db
beer_list = 'select distinct name from openbeerdb_beers'
df = pd.read_sql_query(beer_list, con=db_con)
df['chars'] = df.name.apply(lambda x: len(x))
df = df.sample(frac=0.1)
beers = df[df['chars'] > 9].name.tolist()

# twitter search builder
today = datetime.datetime.now()
yesterday = today - datetime.timedelta(days=1)
start_day = yesterday.strftime('%Y-%m-%d') 
end_day = today.strftime('%Y-%m-%d')
q_days = " since:" + start_day + " until:" + end_day

for beer in beers:
    q = beer + q_days
    # run the search and store data to db table
    for tweet in tweepy.Cursor(api.search,q=q,lang="en").items():
        now = datetime.datetime.utcnow()
        data ={}
        data['beer_name'] = beer
        data['created_at'] = tweet.created_at.strftime('%Y-%m-%d %H:%M:%S')
        data['text'] = tweet.text
        data['id'] = tweet.id
        data['retweeted'] = tweet.retweeted
        data['in_reply_to_user_id'] = tweet.in_reply_to_user_id
        data['in_reply_to_screen_name'] = tweet.in_reply_to_screen_name
        data['retweet_count'] = tweet.retweet_count
        data['geo'] = tweet.geo
        data['coordinates'] = tweet.coordinates
        tw_df = pd.DataFrame(data, index=[now])
        tw_df.to_sql('twitter_beer_search', db_con, if_exists='append')


