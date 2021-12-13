from mongoengine import *

class BaseScenario(Document):
    _id = StringField(primary_key=True, unique=True)
    name = StringField(required=True)
    description = StringField(required=True)
    isPublic = BooleanField()
    userid = StringField(required=False)
    start = StringField(required=False)
    startedAtTime = StringField(null=True)
    endedAtTime = StringField(null=True)
    status =  StringField(required=True)
    modelSettings = ListField(required=True)
    modelSets = ListField(required=False)
    modelInputs = ListField(required=True)
    modelOutputs = ListField(required=True)
    meta = {
        'allow_inheritance': True,
        'abstract': True
    }