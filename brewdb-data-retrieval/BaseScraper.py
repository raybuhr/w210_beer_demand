import abc

from brewerydb import BreweryDb
from util.DictUnicodeWriter import DictUnicodeWriter


class BaseScraper(object):
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    def method_to_invoke_with_params(self, params):
        """
        :param params:
        :return:
        """
        return

    @abc.abstractmethod
    def method_to_invoke(self):
        """
        :param params:
        :return:
        """
        return

    @abc.abstractmethod
    def class_type(self):
        """
        :return:
        """
        return

    @abc.abstractmethod
    def file_name(self):
        """

        :return:
        """
        return

    @abc.abstractmethod
    def get_model(self, param):
        """
        :return:
        """
        return

    @abc.abstractmethod
    def get_model_props(self):
        """
        :return:
        """

    def download_data(self):
        BreweryDb.configure('c7aeca2c6fa21f8a51e023c80332a870')
        response = self.method_to_invoke()
        totalPages = response.get('numberOfPages', None)
        if totalPages:
            print 'Total Page to read %d : ' % totalPages
        response_data = response['data']
        model_dict_list = self.parse_data(response_data, self.get_model_props())
        variables = self.get_model_props()
        hops_count = 0
        with open(self.file_name(), 'w') as csvFile:
            writer = DictUnicodeWriter(csvFile, variables)
            print "Wrote header"
            writer.writeheader()
            writer.writerows(model_dict_list)
            hops_count += len(model_dict_list)
            print "Wrote %d records to file " % hops_count
        if totalPages:
            for page in range(2, totalPages + 1, 1):
                print "Retrieving data for page %d of total %d" % (page, totalPages)
                response = self.method_to_invoke_with_params({'p': page})
                model_dict_list = self.parse_data(response['data'], variables)
                self.write_to_csv(self.file_name(), variables, model_dict_list)
                hops_count += len(model_dict_list)
                print "Wrote %d  to file " % hops_count

    def parse_data(self, model_data, variables):
        model_dicts = []
        for b in model_data:
            # print json.dumps(b)
            bb = self.get_model(b)
            model_dict = dict((name, getattr(bb, name)) for name in variables)
            model_dicts.append(model_dict)
        return model_dicts

    def write_to_csv(self, file_name, variables, model_dict_list):
        with open(file_name, 'a') as csvFile:
            writer = DictUnicodeWriter(csvFile, variables)
            writer.writerows(model_dict_list)
