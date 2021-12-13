import os
import json
from flask import Flask
from flask_cors import CORS
from flask_script import Manager, Command
from flask_jwt import JWT
from datetime import datetime, timedelta
from app import blueprint
from app.main.security import authenticate, identity
from app.main.config import config_by_name
from app.main.service.modeling_service import RunnerService
from app.main.user_database import user_db_session

class FlagManager(Manager):
    def command(self, capture_all=False):
        def decorator(func):
            command = Command(func)
            command.capture_all_args = capture_all
            self.add_command(func.__name__, command)

            return func
        return decorator

app = Flask(__name__)

# get environment settings
environment = (os.getenv('BOILERPLATE_ENV') or 'dev')
settings = config_by_name[environment]

# app setup
app.debug = True
CORS(app)
app.register_blueprint(blueprint)

# jwt security setup
app.config['JWT_SECRET_KEY'] = settings.SECRET_KEY
app.config['JWT_VERIFY_CLAIMS'] = ['exp', 'iat']
app.config['JWT_REQUIRED_CLAIMS'] = ['exp', 'iat']
app.config['JWT_AUTH_HEADER_PREFIX'] = 'Bearer'
app.config['JWT_EXPIRATION_DELTA'] = timedelta(seconds=1800)
jwt = JWT(app, authenticate, identity)

app.app_context().push()
manager = FlagManager(app)

@manager.command()
def run():
    app.run(host='0.0.0.0', port='5000')

@manager.command()
def runxlsinput():
    """Runs model with excel input and output files"""
    print('Loading xls from file...')
    runner = RunnerService()
    runner.runXLSInput()
    
@manager.command()
def runjsoninput():
    """Runs model with json input and model database output"""
    print('Loading raw json from file...')
    path = 'Inputs\\input.json'
    data = None
    if path != '':
        with open(path, encoding='utf-8') as f:
            data = json.load(f)

    runner = RunnerService()
    runner.run(data)

@app.teardown_appcontext
def remove_session(*args, **kwargs):
    """Closes the database session."""
    user_db_session.remove()

# custom jwt token handling for swim
@jwt.jwt_payload_handler
def custom_payload_handler(identity):
    iat = datetime.utcnow()
    exp = iat + app.config.get('JWT_EXPIRATION_DELTA')
    id = getattr(identity, 'uid') or identity['uid']
    email = getattr(identity, 'uemail') or identity['uemail']
    cont = getattr(identity, 'is_contentmanager') or identity['is_contentmanager']
    cont_int = int(cont == True) 
    token = {'email': email, 'id': id, 'cont': cont_int, 'iat': iat, 'exp': exp}
    return token

if __name__ == '__main__':
    manager.run()