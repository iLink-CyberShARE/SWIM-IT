from flask import request
from flask_restx import Resource
from ..util.dto import ServiceDto
from flask_cors import cross_origin

api = ServiceDto.api

@api.route('')
class Service(Resource):
    @api.doc('Check service availability')
    @api.response(200, 'The request was received succesfully')
    @api.response(500, 'Internal error occured')
    @cross_origin( supports_credentials = True )
    def get(self):
        return 'pong'

    
