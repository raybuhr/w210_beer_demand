class Category(object) :
    """ Represents the category object """

    def __init__(self,data):
        self.data = data

    def __unicode__(self):
        self.name


    @property
    def id(self):
        """ Returns the ID of the brewery """
        return self.data.get('id', None)

    @property
    def name(self):
        """ Returns the name of the brewery """
        return self.data.get('name', None)

    @property
    def createDate(self):
        return self.data.get('createDate', None)

