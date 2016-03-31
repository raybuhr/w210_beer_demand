class Beer(object):


    def __init__(self, data):
        self.data = data

    def __unicode__(self):
        return self.name

    @property
    def status(self):
        """ Returns whether brewery is verified """
        return self.data.get('status', None)

    @property
    def srmId(self):
        """ Returns srmId """
        return self.data.get('srmId', None)

    @property
    def glass_id(self):
        """ Returns the glass id """
        glass = self.data.get('glass', None)
        if glass:
            return glass['id']
        else:
            return None

    @property
    def glass_name(self):
        """ Returns the glass id """
        glass = self.data.get('glass', None)
        if glass:
            return glass['name']
        else:
            return None

    def __get_from_style(self, attr):
        style = self.data.get('style', None)
        if style:
            return style.get(attr, None)
        else:
            return None

    @property
    def ogMin(self):
        return self.__get_from_style('ogMin')

    @property
    def ibuMin(self):
        return self.__get_from_style('ibuMin')

    @property
    def ibuMax(self):
        return self.__get_from_style('ibuMax')

    @property
    def abvMin(self):
        return self.__get_from_style('abvMin')

    @property
    def fgMin(self):
        return self.__get_from_style('fgMin')

    @property
    def originalGravity(self):
        return self.data.get('originalGravity', None)

    @property
    def foodPairings(self):
        return self.data.get('foodPairings', None)

    @property
    def servingTemperature(self):
        return self.data.get('servingTemperature', None)

    @property
    def servingTemperatureDisplay(self):
        return self.data.get('servingTemperatureDisplay', None)

    @property
    def shortName(self):
        return self.__get_from_style('shortName')

    @property
    def srmMin(self):
        return self.__get_from_style('srmMin')

    @property
    def createDate(self):
        return self.data.get('createDate', None)

    @property
    def updateDate(self):
        return self.data.get('updateDate', None)

    @property
    def glasswareId(self):
        return self.data.get('glasswareId', None)

    @property
    def srmMax(self):
        return self.__get_from_style('srmMax')

    @property
    def name(self):
        """ Returns the name of the
        beer """
        return self.data.get('name', None)

    @property
    def id(self):
        """ Returns the ID of the beer """
        return self.data.get('id', None)

    @property
    def abv(self):
        """ Returns the Alocohol By Volume of the beer """
        return self.data.get('abv', None)

    @property
    def ibu(self):
        """ Returns the IBU of the beer """
        return self.data.get('ibu', None)

    @property
    def description(self):
        """ Returns the description of the beer """
        return self.data.get('description', None)

    @property
    def organic(self):
        """ Returns a boolean on if the beer is
        organic or not """
        return self.data.get('isOrganic', None)
    @property
    def year(self):
        """ Return the year the beer was first produced """
        return self.data.get('year', None)

    @property
    def style(self):
        """ Returns the name of the style
        category that this beer belongs to."""
        style = self.data.get('style', None)
        if style:
            return style['category']['name']
        else:
            return None

    # @property
    # def label_image_large(self):
    #     """ Return the large size label """
    #     return self.data['labels']['large']
    #
    # @property
    # def label_image_medium(self):
    #     """ Return the medium size image """
    #     return self.data['labels']['medium']

    @property
    def brewery_id(self):
        """ Returns the brewery ID of the beer """
        breweries = self.data.get('breweries', None)
        if breweries:
            return breweries[0]['id']
        else:
            return None

            # @property
            # def brewery(self):
            #     """ Returns the brewery object. """
            #     breweries = self.data.get('breweries', None)
            #     if breweries:
            #         return breweries[0]
            #     else:
            #         return None
