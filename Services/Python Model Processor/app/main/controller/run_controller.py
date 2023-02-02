from flask import request
from flask_restx import Resource
from ..util.dto import RunDto
from flask_jwt import jwt_required, current_identity
from app.main.service.modeling_service import RunnerService
from flask_cors import cross_origin

api = RunDto.api
_jsoninput = RunDto.jsoninput

@api.route('')
class Runner(Resource):
    @api.doc('Runs Water Balance Model')
    @jwt_required()
    @api.response(200, 'The request was received succesfully')
    @api.response(401, 'Not Authorized')
    @api.expect(_jsoninput, validate=True)
    @cross_origin( supports_credentials = True )
    def post(self):
        data = request.json
        userid= None
        if(current_identity):
            userid = current_identity.uid
            print(userid)
        runner = RunnerService()
        return runner.run(data, userid)

    
