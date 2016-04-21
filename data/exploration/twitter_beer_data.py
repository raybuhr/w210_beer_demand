# -*- coding: utf-8 -*-
# python3.5.1
from sqlalchemy import create_engine
import json
import os
import tweepy
import urllib

# PostgreSQL Database auth
pg_user = os.environ.get("BEER_USER")
pg_pw = os.environ.get("BEER_PW")
db = create_engine('postgresql://' + pg_user +':'+ pg_pw +'@localhost:5432/beer')

# get list of beers
beers = pd.read_sql_query("select distinct name from openbeerdb_beers", con=db)
beers['chars'] = beers['name'].apply(len)
beers = beers[beers['chars'] > 9]
beers['url_names'] = beers['name'].apply(urllib.parse.quote)

# Twitter auth
consumer_key = os.environ.get("TW_CONSUMER_KEY")
consumer_secret = os.environ.get("TW_CONSUMER_SECRET")
access_token = os.environ.get("TW_ACCESS_TOKEN")
access_token_secret = os.environ.get("TW_ACCESS_SECRET")

# connect to twitter api
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth, wait_on_rate_limit=True, wait_on_rate_limit_notify=True)

for beer_name in beers['url_names']:
    for tweet in tweepy.Cursor(api.search, q='%23'+beer_name, lang="en").items():
        print tweet._json
        file_name = 'twitter_data-'+beer+'.txt'
        twitter_data = open(file_name,'a')
        twitter_data.write(json.dumps(tweet._json).encode('utf8'))
