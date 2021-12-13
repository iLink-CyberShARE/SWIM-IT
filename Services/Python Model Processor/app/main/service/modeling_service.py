import json
import os
import datetime
import pytz
from mongoengine import connect
from mongoengine.connection import disconnect
from ..model.private_scenario import PrivateScenario
from ..model.public_scenario import PublicScenario
from ..runner.water_balance_v2 import WaterBalance
from app.main.config import config_by_name


class RunnerService():

    def __init__(self):
        '''
        Get Mongo Database connection URL from configuration settings
        '''
        environment = (os.getenv('BOILERPLATE_ENV') or 'dev')
        settings = config_by_name[environment]
        self.mongoURL = settings.MODEL_DATABASE_URL

    def run(self, data, userid=None):
        '''
        Model execution from web service endpoint or as direct JSON input
        '''
        try:
            print('Connecting to db...')
            connect(host=self.mongoURL)

            # check if public or private scenario
            isPublic = data.get('isPublic') # will return None if doesn't exist
            print('Mapping raw json to document object...')
            if(isPublic):
                custom_scenario = PublicScenario(**data)
            else:
                custom_scenario = PrivateScenario(**data)

            # set the user id extracted from json token (must be in string format apparently)
            if(userid):
                custom_scenario.userid = str(userid)

            # set the start execution time
            now = datetime.datetime.now(pytz.timezone('America/Denver')).strftime('%Y.%m.%d.%H.%M.%S')
            custom_scenario.startedAtTime = now
            custom_scenario.status = 'running'

            # run model
            wb = WaterBalance()

            # load data from json document
            wb.load_data_document(custom_scenario.modelInputs)

            # execute model
            wb.run()

            # extract requested results and append to variable value (selective outputs)
            custom_scenario.modelOutputs = wb.export_outputs_document(custom_scenario.modelOutputs)

            # set the end execution time
            now = datetime.datetime.now(pytz.timezone('America/Denver')).strftime('%Y.%m.%d.%H.%M.%S')
            custom_scenario.endedAtTime = now

            # remove is public flag
            custom_scenario.isPublic = None

            # save results to db
            custom_scenario.status = 'complete'
            custom_scenario.save()

            # clear userid for the request response
            custom_scenario.userid = None

            # map back to json and remove backslashes
            json_raw = custom_scenario.to_json() # convert to raw string
            json_dict = json.loads(json_raw) # load the json

            # assign the id as needed for a response ??
            json_dict["id"] = json_dict["_id"]
            json_dict.pop("_id")

            # close mongo connection
            disconnect()

            # return json result (check this when webservice)
            return json_dict, 200

        except Exception as e:
            response = {
                'status': 'fail',
                'message': str(e)
            }
        return response, 500

    def runXLSInput(self):
        '''
        Model execution with excel input and output
        '''

        # load data and run model
        wb = WaterBalance()
        wb.input_xls_file = 'Inputs\\input.xlsx'
        wb.output_xls_file = 'Outputs\\output.xlsx'

        # load data from excel file
        wb.load_scalars_xls()
        wb.load_tables_xls()

        # execute model
        wb.run()

        # export all outputs to xls (non-selective outputs)
        wb.export_outputs_xls()

        return
