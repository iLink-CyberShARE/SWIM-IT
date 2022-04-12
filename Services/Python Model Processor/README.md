# Python Model Processor
SWIM webservice wrapper for the python version of the MRG Water Balance Model version 2.0

## Native Installation
> py -m venv env  // create new virtual python environment (windows)   
> .\env\Scripts\activate // activate environment (windows)   
> update pip // update the pip package (optional)   
> py -m pip install -r requirements.txt // install required packages (windows)   
> py manage.py run  // run webservice on localhost (windows)   
> py manage.py runxlsinput // run model with json file input and export results to mongo   
> py manage.py runjsoninput // run model with excel file input and export results to excel   

## API Docs
> Localhost: swagger docs will be available at http://localhost:5000/swim-wb-py/docs/   
> Docker composer: swagger docs will be available at http://xxxxxx:5000/swim-wb-py/docs/   

### Live Open API
A live Open API for the Water Balance Model 2.0 is available at: https://services.cybershare.utep.edu/swim-wb-py/docs/

## Contributors
Lead Developer - Luis A. Garnica Chavira  

## Acknowledgements
This material is based upon work supported by the National Science Foundation (NSF) under Grant No. 1835897 and The United States Department of Agriculture under Grant No. 2015-68007-23130. This work used resources from Cyber-ShARE Center of Excellence supported by NSF Grant HDR-1242122.   

Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation. 

## License
GNU GENERAL PUBLIC LICENSE  3.0

## Copyright
© 2021 University of Texas at El Paso (SWIM Project) 

## Additional Documentation
Water Balance 2.0: https://water.cybershare.utep.edu/resources/docs/en2/models/balancev2/
