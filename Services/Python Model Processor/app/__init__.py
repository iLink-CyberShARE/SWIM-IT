from flask_restplus import Api
from flask import Blueprint, url_for

from .main.controller.service_controller import api as service_ns
from .main.controller.run_controller import api as run_ns


blueprint = Blueprint('waterbalance', __name__, url_prefix='/swim-wb-py')

class CustomAPI(Api):
    @property
    def specs_url(self):
        '''
        The Swagger specifications absolute url (ie. `swagger.json`)
        This fix will force a relatve url to the specs.json instead of absolute
        :rtype: str
        '''
        return url_for(self.endpoint('specs'), _external=False)

authorizations = {
    'Bearer Auth' : {
        'type' : 'apiKey',
        'in' : 'header',
        'name' : 'Authorization',
        'description': 'Type in the value input box below: Bearer &lt;JWT&gt; where JWT is the token'
    }
}

api = CustomAPI(blueprint,
          title= "MRG Water Balance Run Service",
          version='2.0',
          description='Webservice encapsulation of the Middle Rio Grande Water Balance Model v2.0',
          doc='/docs/',
          security='Bearer Auth',
          authorizations = authorizations
          )

api.add_namespace(service_ns, path='/service/ping')
api.add_namespace(run_ns, path='/model/run')


