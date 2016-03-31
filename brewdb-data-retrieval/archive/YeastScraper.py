from brewerydb import BreweryDb
from models.yeast import Yeast
from util.DictUnicodeWriter import DictUnicodeWriter


def download_yeast():
    BreweryDb.configure('c7aeca2c6fa21f8a51e023c80332a870')
    # response = BreweryDb.beers({'withBreweries':'Y','withIngredients':'Y'})
    response = BreweryDb.yeasts()
    totalPages = response['numberOfPages']
    hops_data = response['data']
    hops_dict_list = parse_hops_data(hops_data)
    variables = [x for x in dir(Yeast) if not (x.startswith('_'))]
    hops_count = 0
    print "Starting to process page 1 of %d " % totalPages
    with open('yeast-brewerydb.csv', 'w') as csvFile:
        writer = DictUnicodeWriter(csvFile, variables)
        print "Wrote header"
        writer.writeheader()
        writer.writerows(hops_dict_list)
        hops_count += len(hops_dict_list)
        print "Wrote %d beers to file " % hops_count
    for page in range(2, totalPages + 1, 1):
        print "Retrieving data for page %d of total %d" % (page, totalPages)
        response = BreweryDb.yeasts({'p': page})
        beer_dict_list = parse_hops_data(response['data'])
        write_hops_to_csv('yeast-brewerydb.csv', variables, beer_dict_list)
        hops_count += len(beer_dict_list)
        print "Wrote %d yeasts to file " % hops_count


def parse_hops_data(hops_data):
    hops_dicts = []
    variables = [x for x in dir(Yeast) if not (x.startswith('_'))]
    for b in hops_data:
        # print json.dumps(b)
        bb = Yeast(b)
        hops_dict = dict((name, getattr(bb, name)) for name in variables)
        hops_dicts.append(hops_dict)
    return hops_dicts


def write_hops_to_csv(file_name, variables, beer_dict_list):
    with open(file_name, 'a') as csvFile:
        writer = DictUnicodeWriter(csvFile, variables)
        writer.writerows(beer_dict_list)




download_yeast()