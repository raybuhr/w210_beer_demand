class Hops(object):
    def __init__(self, data):
        self.data = data

    def __unicode__(self):
        return self.name

    @property
    def status(self):
        """ Returns whether brewery is verified """
        return self.data.get('status', None)

    @property
    def description(self):
        """ Returns the description of the beer """
        return self.data.get('description', None)

    @property
    def countryOfOrigin(self):
        """ Returns the description of the beer """
        return self.data.get('countryOfOrigin', None)


    @property
    def alphaAcidMin(self):
        """ Returns the description of the beer """
        return self.data.get('alphaAcidMin', None)

    @property
    def betaAcidMin(self):
        """ Returns the description of the beer """
        return self.data.get('betaAcidMin', None)

    @property
    def betaAcidMax(self):
        """ Returns the description of the beer """
        return self.data.get('betaAcidMax', None)

    @property
    def humuleneMin(self):
        """ Returns the description of the beer """
        return self.data.get('humuleneMin', None)

    @property
    def caryophylleneMin(self):
        """ Returns the description of the beer """
        return self.data.get('caryophylleneMin', None)

    @property
    def caryophylleneMax(self):
        """ Returns the description of the beer """
        return self.data.get('caryophylleneMax', None)


    @property
    def cohumuloneMin(self):
        """ Returns the description of the beer """
        return self.data.get('cohumuloneMin', None)

    @property
    def cohumuloneMax(self):
        """ Returns the description of the beer """
        return self.data.get('cohumuloneMax', None)

    @property
    def myrceneMin(self):
        """ Returns the description of the beer """
        return self.data.get('myrceneMin', None)

    @property
    def myrceneMax(self):
        """ Returns the description of the beer """
        return self.data.get('myrceneMax', None)

    @property
    def farneseneMin(self):
        """ Returns the description of the beer """
        return self.data.get('farneseneMin', None)

    @property
    def farneseneMax(self):
        """ Returns the description of the beer """
        return self.data.get('farneseneMax', None)

    @property
    def category(self):
        """ Returns the description of the beer """
        return self.data.get('category', None)

    @property
    def countryCode(self):
        """ Returns the description of the beer """
        country = self.data.get('country', None)
        if country:
            return country['isoCode']
        else:
            return None

    @property
    def countryName(self):
        """ Returns the description of the beer """
        country = self.data.get('country', None)
        if country:
            return country['name']
        else:
            return None
