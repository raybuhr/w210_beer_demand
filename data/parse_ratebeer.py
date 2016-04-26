import csv

cols = ['beer_name', 'beer_beerid', 'beer_brewerid', 'beer_abv', 'beer_style',
        'review_appearance', 'review_aroma', 'review_palate', 'review_taste',
        'review_overall', 'review_time', 'review_profilename', 'review_text']


def cast_int_float(x):
    try:
        return float(x)
    except:
        try:
            return int(x)
        except:
            return x

f = open('rate_beer_reviews.csv', 'w')
w = csv.writer(f)
w.writerow(cols)

row = {}

for line in open('Ratebeer.txt'):
    line = line.strip()
    if line == "":
        w.writerow([row.get(col) for col in cols])
        row = {}
    else:
        idx = line.find(":")
        key, value = tuple([line[:idx], line[idx + 1:]])

        key = key.strip().replace("/", "_").lower()
        value = value.strip()
        row[key] = cast_int_float(value)
        print key, value

f.close()
