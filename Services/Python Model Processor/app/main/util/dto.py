from flask_restplus import Namespace, fields

class ServiceDto:
    api = Namespace('/service/ping', description='Service availability check')

class RunDto:
    api = Namespace('/model/run', description='Model execution endpoint')
    jsoninput = api.model( 'input' , {
        'id': fields.String(required=True, description='Unique custom scenario identifier'),
        'name': fields.String(required=True, description='Custom scenario name'),
        'description': fields.String(required=True, description='Scenario description'),
        'isPublic': fields.Boolean(required=False, description='Private or public scenario'),
        'status': fields.String(required=False, description='Execution status', example='submitted'),
        "modelSettings": fields.List(fields.Raw, required=True, description='List of model settings and themes'),
        "modelInputs": fields.List(fields.Raw, required=True, description='List of input parameters and values'),
        "modelOutputs": fields.List(fields.Raw, description='List of requested model outputs')
    })