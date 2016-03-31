from brewerydb import BreweryDb
from models.beer import Beer
from util.DictUnicodeWriter import DictUnicodeWriter

BreweryDb.configure('c7aeca2c6fa21f8a51e023c80332a870')


def download_beers():
    # response = BreweryDb.beers({'withBreweries':'Y','withIngredients':'Y'})
    response = BreweryDb.beers({'withBreweries': 'Y'})
    totalPages = response['numberOfPages']
    beers_data = response['data']
    beer_dict_list = parse_beer_data(beers_data)
    variables = [x for x in dir(Beer) if not (x.startswith('_'))]
    beer_count = 0
    print "Starting to process page 1 of %d " % totalPages
    with open('beers-brewerydb.csv', 'w') as csvFile:
        writer = DictUnicodeWriter(csvFile, variables)
        print "Wrote header"
        writer.writeheader()
        writer.writerows(beer_dict_list)
        beer_count += len(beer_dict_list)
        print "Wrote %d beers to file " % beer_count
    for page in range(2, totalPages + 1, 1):
        print "Retrieving data for page %d of total %d" % (page, totalPages)
        response = BreweryDb.beers({'withBreweries': 'Y', 'p': page})
        beer_dict_list = parse_beer_data(response['data'])
        write_beers_to_csv('beers-brewerydb.csv', variables, beer_dict_list)
        beer_count += len(beer_dict_list)
        print "Wrote %d beers to file " % beer_count


def parse_beer_data(beers_data):
    beer_dicts = []
    variables = [x for x in dir(Beer) if not (x.startswith('_'))]
    for b in beers_data:
        # print json.dumps(b)
        bb = Beer(b)
        beer_dict = dict((name, getattr(bb, name)) for name in variables)
        beer_dicts.append(beer_dict)
    return beer_dicts


def write_beers_to_csv(file_name, variables, beer_dict_list):
    with open(file_name, 'a') as csvFile:
        writer = DictUnicodeWriter(csvFile, variables)
        writer.writerows(beer_dict_list)


#
# def list_public_attributes(input_var):
#     """ Return all 'public fields """
#     return [k for k, v in vars(input_var).items() if
#             not (k.startswith('_') or callable(v))]
#
#
# def parse_write_beers(beers_data):
#     beers = []
#     for b in beers_data:
#         # print json.dumps(b)
#         bb = Beer(b)
#         beers.append(bb)
#
#     variables = [x for x in dir(Beer) if not (x.startswith('_'))]
#     print variables
#     beers_df = pd.DataFrame([[getattr(i, j) for j in variables] for i in beers], columns=variables)
#     h = beers_df.head()
#     h.to_csv('test.csv', header=True, index=False, encoding='utf-8')


download_beers()
