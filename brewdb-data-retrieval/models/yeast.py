class Yeast(object):

    def __init__(self, data):
        self.data = data

    def __unicode__(self):
        return self.name

    @property
    def id(self):
        """ Returns the ID of the beer """
        return self.data.get('id', None)

    @property
    def name(self):
        """ The name of the yeast. """
        return self.data.get('name', None)

    @property
    def description(self):
        """ The description of the yeast."""
        return self.data.get('description', None)

    @property
    def yeastType(self):
        """ The type of yeast that this yeast is. Will be one of: ale, wheat, lager, wine, champagne.."""
        return self.data.get('yeastType', None)

    @property
    def attenuationMin(self):
        """ The type of yeast that this yeast is. Will be one of: ale, wheat, lager, wine, champagne.."""
        return self.data.get('attenuationMin', None)

    @property
    def attenuationMax(self):
        """ The type of yeast that this yeast is. Will be one of: ale, wheat, lager, wine, champagne.."""
        return self.data.get('attenuationMax', None)

    @property
    def fermentTempMin(self):
        """ The type of yeast that this yeast is. Will be one of: ale, wheat, lager, wine, champagne.."""
        return self.data.get('fermentTempMin', None)

    @property
    def fermentTempMax(self):
        """ The minimum recommended fermentation temperature, in Fahrenheit.."""
        return self.data.get('fermentTempMax', None)

    @property
    def alcoholToleranceMin(self):
        """ If there is a range of the upper limit alcohol tolerance of the yeast, this will be the minimum value. Expressed as percentage alcohol by volume."""
        return self.data.get('alcoholToleranceMin', None)

    @property
    def alcoholToleranceMax(self):
        """ The minimum recommended fermentation temperature, in Fahrenheit.."""
        return self.data.get('alcoholToleranceMax', None)

    @property
    def alcoholToleranceMax(self):
        """ The maximum alcohol tolerance of the yeast. Expressed as percentage alcohol by volume.."""
        return self.data.get('alcoholToleranceMax', None)

    @property
    def productId(self):
        """ The supplier's product ID of the yeast."""
        return self.data.get('productId', None)

    @property
    def supplier(self):
        """The supplier or company the provides the yeast."""
        return self.data.get('supplier', None)

    @property
    def yeastFormat(self):
        """The format(s) that yeast is available in. Will be one of: liquid, dry, or both."""
        return self.data.get('yeastFormat', None)

    @property
    def category(self):
        """The format(s) that yeast is available in. Will be one of: liquid, dry, or both."""
        return self.data.get('category', None)

