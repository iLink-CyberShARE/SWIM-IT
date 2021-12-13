import json
import os
from mongoengine import *
from .base_scenario import BaseScenario

class PublicScenario(BaseScenario):
    meta = {'collection': 'public-scenarios'}


