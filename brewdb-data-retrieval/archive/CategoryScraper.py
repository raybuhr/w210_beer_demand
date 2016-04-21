from brewerydb import BreweryDb
from models.category import Category
from util.DictUnicodeWriter import DictUnicodeWriter


def download_categories():
    BreweryDb.configure('c7aeca2c6fa21f8a51e023c80332a870')
    # response = BreweryDb.beers({'withBreweries':'Y','withIngredients':'Y'})
    response = BreweryDb.categories()
    cat_data = response['data']
    variables = [x for x in dir(Category) if not (x.startswith('_'))]
    cat_dicts = parse_cat_data(cat_data)
    with open('categories-brewerydb.csv', 'w') as csvFile:
        writer = DictUnicodeWriter(csvFile, variables)
        print "Wrote header"
        writer.writeheader()
        writer.writerows(cat_dicts)
        print "Wrote %d categories to file " % len(cat_dicts)


def parse_cat_data(cat_data):
    cat_dicts = []
    variables = [x for x in dir(Category) if not (x.startswith('_'))]
    for c in cat_data:
        # print json.dumps(b)
        c = Category(c)
        c_dict = dict((name, getattr(c, name)) for name in variables)
        cat_dicts.append(c_dict)
    return cat_dicts


download_categories()