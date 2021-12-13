import json
import os
from mongoengine import *
from .base_scenario import BaseScenario

class PrivateScenario(BaseScenario):
    meta = {'collection': 'private-scenarios'}

