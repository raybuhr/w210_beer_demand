from BaseScraper import BaseScraper
from brewerydb import BreweryDb
from models.beer import Beer
from models.brewery import Brewery
from models.category import Category
from models.hops import Hops
from models.ingredient import Ingredient
from models.style import Style
from models.yeast import Yeast


class CategoryBaseScraper(BaseScraper):
    def file_name(self):
        return 'data/category-brewdb.csv'

    def get_model_props(self):
        return [x for x in dir(Category) if not (x.startswith('_'))]

    def method_to_invoke(self):
        return BreweryDb.categories()

    def method_to_invoke_with_params(self, params):
        return BreweryDb.categories(params)

    def get_model(self, param):
        return Category(param)

    def class_type(self):
        return Category


class HopsBaseScraper(BaseScraper):
    def file_name(self):
        return 'data/hops-brewdb.csv'

    def get_model_props(self):
        return [x for x in dir(Hops) if not (x.startswith('_'))]

    def method_to_invoke(self):
        return BreweryDb.hops()

    def method_to_invoke_with_params(self, params):
        return BreweryDb.hops(params)

    def get_model(self, param):
        return Hops(param)

    def class_type(self):
        return Hops


class BeerBaseScraper(BaseScraper):
    def file_name(self):
        return 'data/beer-brewdb.csv'

    def get_model_props(self):
        return [x for x in dir(Beer) if not (x.startswith('_'))]

    def method_to_invoke(self):
        return BreweryDb.beers()

    def method_to_invoke_with_params(self, params):
        return BreweryDb.beers(params)

    def get_model(self, param):
        return Beer(param)

    def class_type(self):
        return Beer


class BreweryBaseScraper(BaseScraper):
    def file_name(self):
        return 'data/brewery-brewdb.csv'

    def get_model_props(self):
        return [x for x in dir(Brewery) if not (x.startswith('_'))]

    def method_to_invoke(self):
        return BreweryDb.breweries()

    def method_to_invoke_with_params(self, params):
        return BreweryDb.breweries(params)

    def get_model(self, param):
        return Brewery(param)

    def class_type(self):
        return Brewery


class YeastBaseScraper(BaseScraper):
    def file_name(self):
        return 'data/yeast-brewdb.csv'

    def get_model_props(self):
        return [x for x in dir(Yeast) if not (x.startswith('_'))]

    def method_to_invoke(self):
        return BreweryDb.yeasts()

    def method_to_invoke_with_params(self, params):
        return BreweryDb.yeasts(params)

    def get_model(self, param):
        return Yeast(param)

    def class_type(self):
        return Yeast


class IngredientBaseScraper(BaseScraper):
    def file_name(self):
        return 'data/ingredients-brewdb.csv'

    def get_model_props(self):
        return [x for x in dir(Ingredient) if not (x.startswith('_'))]

    def method_to_invoke(self):
        return BreweryDb.ingredients()

    def method_to_invoke_with_params(self, params):
        return BreweryDb.ingredients(params)

    def get_model(self, param):
        return Ingredient(param)

    def class_type(self):
        return Ingredient


class StyleBaseScraper(BaseScraper):
    def file_name(self):
        return 'data/ingredients-brewdb.csv'

    def get_model_props(self):
        return [x for x in dir(Style) if not (x.startswith('_'))]

    def method_to_invoke(self):
        return BreweryDb.styles()

    def method_to_invoke_with_params(self, params):
        return BreweryDb.styles(params)

    def get_model(self, param):
        return Style(param)

    def class_type(self):
        return Style


if __name__ == '__main__':

    print 'Downloading Hops Data'
    hops = HopsBaseScraper()
    hops.download_data()

    print 'Downloading Brewery Data'
    brewers = BreweryBaseScraper()
    brewers.download_data()

    print 'Downloading Yeast Data'
    y = YeastBaseScraper()
    y.download_data()

    print 'Downloading Category Data'
    c = CategoryBaseScraper()
    c.download_data()

    print 'Downloading Style Data'
    s = StyleBaseScraper()
    s.download_data()

    print 'Downloading Ingredient Data'
    i = IngredientBaseScraper()
    i.download_data()

    print 'Downloading Beer Data'
    b = BeerBaseScraper()
    b.download_data()
