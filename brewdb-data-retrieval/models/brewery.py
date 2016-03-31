class Brewery(object):
    """
    """

    resource_url = 'brewery'

    def __init__(self, data):
        self.data = data

    def __unicode__(self):
        return self.name

    @property
    def id(self):
        """ Returns the ID of the brewery """
        return self.data.get('id', None)

    @property
    def description(self):
        """ Returns the description of the brewery """
        return self.data.get('description', None)

    @property
    def name(self):
        """ Returns the name of the brewery """
        return self.data.get('name', None)

    @property
    def established(self):
        """ Returns the year that the brewery was established """
        return self.data.get('established', None)

    @property
    def organic(self):
        """ Returns a bool value on if this brewery is organic """
        if self.data.get('isOrganic', 'F') == 'Y':
            return True
        return False

    @property
    def website(self):
        """ Returns the website of the brewery """
        return self.data.get('website', None)

    # @property
    # def large_image(self):
    #     """ Returns the large image of the brewery """
    #     return self.data['images']['large']
    #
    # @property
    # def medium_image(self):
    #     """ Return the medium size image of the brewery """
    #     return self.data['images']['medium']
