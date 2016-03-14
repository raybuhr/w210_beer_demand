import os
import pandas as pd
from sqlalchemy import create_engine
from textblob import TextBlob

# database connection
DB_USER = os.environ.get('BEER_USER')
DB_PW = os.environ.get('BEER_PW')
db_url = 'postgresql://' + DB_USER + ':' + DB_PW + '@localhost:5432/beer'
db_con = create_engine(db_url)

# pull db table into pandas dataframe
query = 'select index, beer_name, text from twitter_beer_search'
t = pd.read_sql(query, db_con)

# apply textblob sentiment methods to twitter text
t['polarity'] = t.text.apply(lambda x: TextBlob(x).sentiment.polarity)
t['subjectivity'] = t.text.apply(lambda x: TextBlob(x).sentiment.subjectivity)

# write results into new table
t.to_sql('twitter_beer_sentiment', db_con, if_exists='append')
