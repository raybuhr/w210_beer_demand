__author__='satish'
__version__ = 0.1

import json
import ConfigParser
from datetime import datetime
from brewerydb import *
config = ConfigParser.ConfigParser()
config.read('config.ini')

apiKey  = config.get('brewerydb.params','apikey')
BreweryDb.configure(apikey=apiKey)

#beers = BreweryDb.beers({'ids':'O3tmVI'})


beer =BreweryDb.beer('oeGSxs')

print beer





