class Style(object):
    def __init__(self, data):
        self.data = data

    def __unicode__(self):
        return self.name

    @property
    def status(self):
        """ Returns whether brewery is verified """
        return self.data.get('status', None)

    @property
    def id(self):
        """ Returns whether brewery is verified """
        return self.data.get('id', None)

    @property
    def srmMax(self):
        """ Returns whether brewery is verified """
        return self.data.get('srmMax', None)

    @property
    def ibuMax(self):
        """ Returns whether brewery is verified """
        return self.data.get('ibuMax', None)

    @property
    def srmMin(self):
        """ Returns whether brewery is verified """
        return self.data.get('srmMin', None)

    @property
    def fgMin(self):
        """ Returns whether brewery is verified """
        return self.data.get('fgMin', None)

    @property
    def ibuMin(self):
        """ Returns whether brewery is verified """
        return self.data.get('ibuMin', None)

    @property
    def fgMax(self):
        """ Returns whether brewery is verified """
        return self.data.get('fgMax', None)

    @property
    def abvMax(self):
        """ Returns whether brewery is verified """
        return self.data.get('abvMax', None)

    @property
    def ogMin(self):
        """ Returns whether brewery is verified """
        return self.data.get('ogMin', None)

    @property
    def abvMin(self):
        """ Returns whether brewery is verified """
        return self.data.get('abvMin', None)

    @property
    def name(self):
        """ Returns whether brewery is verified """
        return self.data.get('name', None)

    @property
    def categoryId(self):
        """ Returns whether brewery is verified """
        return self.data.get('categoryId', None)
