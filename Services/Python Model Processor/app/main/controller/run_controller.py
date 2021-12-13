from flask import request
from flask_restplus import Resource
from ..util.dto import RunDto
from flask_jwt import jwt_required, current_identity
from app.main.service.modeling_service import RunnerService

api = RunDto.api
_jsoninput = RunDto.jsoninput

@api.route('')
class Runner(Resource):
    @api.doc('Runs Water Balance Model')
    @jwt_required()
    @api.response(200, 'The request was received succesfully')
    @api.response(401, 'Not Authorized')
    @api.expect(_jsoninput, validate=True)
    def post(self):
        data = request.json
        userid= None
        if(current_identity):
            userid = current_identity.uid
            print(userid)
        runner = RunnerService()
        return runner.run(data, userid)

    