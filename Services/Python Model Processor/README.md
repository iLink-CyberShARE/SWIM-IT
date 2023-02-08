# Python Model Processor
SWIM webservice wrapper for the python version of the MRG Water Balance Model version 2.0

## Build and Run

### Recommended Execution Environment
+ Python 3
+ pip dependency manager
+ All dependencies are managed via requirements.txt with pip

### Option 1: Docker Compose File
1. Download the docker-composer.yml file to a path in your machine.   
2. Install Docker and Docker composer on your target machine.   
3. Setup your docker account at: https://www.docker.com/get-started   
4. Configure the docker-composer file with your own app settings.   
5. Run docker compose: $docker-compose up   
5a. Use -d option on the composer command to run on the background.   
6. Swagger docs available at http://localhost:5001/swim-wb-py/docs/

### Option 2: Build Docker Container
1. Download this repository into a folder on your machine.
2. Install Docker and Docker composer on your target machine.
3. Setup your docker account at: https://www.docker.com/get-started
4. Using a command line or terminal navigate to the base path of the project.
5. Change configuration settings accordigly at the path /app/main/config
6. Build the image: $docker build -t swim-wb-py-public:latest .
7. Run the container: $docker run -p 5000:5000 dockeruser/swim-wb-py
8. Swagger docs available at http://localhost:5001/swim-wb-py/docs/

### Option 3: Native Installation
> py -m venv env  // create new virtual python environment (windows)   
> .\env\Scripts\activate // activate environment (windows)   
> update pip // update the pip package (optional)   
> py -m pip install -r requirements.txt // install required packages (windows)   
> change configuration settings accordigly at the path /app/main/config
> py manage.py run  // run webservice on localhost (windows)   
> py manage.py runxlsinput // run model with json file input and export results to mongo   
> py manage.py runjsoninput // run model with excel file input and export results to excel   

## API Docs
> Localhost: swagger docs will be available at http://localhost:5001/swim-wb-py/docs/   
> Docker composer: swagger docs will be available at http://xxxxxx:5001/swim-wb-py/docs/   

## Documentation
Water Balance 2.0: https://water.cybershare.utep.edu/resources/docs/en2/models/balancev2/

## Contributors
Luis A. Garnica Chavira  
Robyn Holmes  
Alex Mayer

## Acknowledgements
This material is based upon work supported by the National Science Foundation (NSF) under Grant No. 1835897 and The United States Department of Agriculture under Grant No. 2015-68007-23130. This work used resources from Cyber-ShARE Center of Excellence supported by NSF Grant HDR-1242122.   

Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation. 

## How to cite
If you create products such as publications using SWIM products, it would be great if you add the  following acknowledgement:   

"This work used the Sustainable Water for Integrated Modeling (SWIM) 2.0, which was supported by the National Science Foundation under Grant No. 1835897."  

Please use the following citation for this product:     

Supporting Regional Water Sustainability Decision-Making through Integrated Modeling
Garnica Chavira L., Villanueva-Rosales N., Heyman J., Pennington D., Salas K.
2022 IEEE 8th International Smart Cities Conference, Paphos, Cyprus. September 26-29, 2022.
DOI 10.1109/ISC255366.2022.9922004   

## License
This software code is licensed under the [GNU GENERAL PUBLIC LICENSE v3.0](https://github.com/iLink-CyberShARE/SWIM-IT/blob/master/LICENSE) and uses third party libraries that are distributed under their own terms (see [LICENSE-3RD-PARTY.md](./LICENSE-3RD-PARTY.md)).

## Copyright
© 2019-2023 University of Texas at El Paso (SWIM Project) 
