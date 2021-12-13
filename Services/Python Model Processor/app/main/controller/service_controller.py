from flask import request
from flask_restplus import Resource
from ..util.dto import ServiceDto

api = ServiceDto.api

@api.route('')
class Service(Resource):
    @api.doc('Check service availability')
    @api.response(200, 'The request was received succesfully')
    @api.response(500, 'Internal error occured')
    def get(self):
        return 'pong'

    