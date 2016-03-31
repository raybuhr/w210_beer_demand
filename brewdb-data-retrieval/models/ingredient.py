class Ingredient(object):
    def __init__(self, data):
        self.data = data

    def __unicode__(self):
        return self.name

    @property
    def status(self):
        """ Returns whether brewery is verified """
        return self.data.get('status', None)

    @property
    def category(self):
        """ Returns srmId """
        return self.data.get('category', None)

    @property
    def id(self):
        """ Returns srmId """
        return self.data.get('id', None)

    @property
    def categoryDisplay(self):
        """ Returns srmId """
        return self.data.get('categoryDisplay', None)

    @property
    def name(self):
        """ Returns srmId """
        return self.data.get('name', None)


    @property
    def name(self):
        """ Returns srmId """
        return self.data.get('name', None)
