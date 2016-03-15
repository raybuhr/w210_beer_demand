#!/bin/bash
source /home/ray/.bash_profile
date > last_update.txt
/opt/anaconda/bin/python /home/ray/R/w210_beer_demand/data/twitter_beer_search.py
