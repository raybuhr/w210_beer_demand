from models.beer import Beer




print [x for x in dir(Beer) if not (x.startswith('_'))]
