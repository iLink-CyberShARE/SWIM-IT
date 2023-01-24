# Scilab Model Processor

The Scilab model Processor is a Restful web service packaged with dropwizard that enables model execution of in Scilab through their Java API. 
The service consumes a JSON structure with the scenario specification to execute. The service produces an extended JSON with appended output values.
The JSON structure is mapped to a MongoDB collection with the use of 
the Morphia library. 

## Environment
This service was tested on Windows Server 2012

## Dependencies
+ JDK 1.8+ (Java)
+ Java Libraries: Managed with Maven
+ Scilab 5.5.2 


## Setting Scilab Libraries as Maven Local Repo

1. Install Scilab version 5.5.2
2. Setup environment variable 'SCI' pointing to the scilab root folder e.g. 'C:\Program Files\scilab-5.5.2'
3. Create local maven repos for scilab java api

Linux Samples: 

-- javasci  
`mvn install:install-file -Dfile=/opt/scilab-6.0.2/share/scilab/modules/javasci/jar/org.scilab.modules.javasci.jar -DgroupId=org.scilab.modules -DartifactId=javasci -Dversion=6.0.2 -Dpackaging=jar`

-- types  
`mvn install:install-file -Dfile=/opt/scilab-6.0.2/share/scilab/modules/types/jar/org.scilab.modules.types.jar -DgroupId=org.scilab.modules -DartifactId=types -Dversion=6.0.2 -Dpackaging=jar`

Windows Samples:     

-- javasci  
`mvn install:install-file -Dfile="C:/Program Files/scilab-5.5.2/modules/javasci/jar/org.scilab.modules.javasci.jar" -DgroupId=org.scilab.modules -DartifactId=javasci -Dversion=5.5.2 -Dpackaging=jar`

-- types  
`mvn install:install-file -Dfile="C:/Program Files/scilab-5.5.2/modules/types/jar/org.scilab.modules.types.jar" -DgroupId=org.scilab.modules -DartifactId=types -Dversion=5.5.2 -Dpackaging=jar`

For more information on local Maven repositories follow:
<http://maven.apache.org/guides/mini/guide-3rd-party-jars-local.html>

### Notes
Issues were presented to interface Java with Scilab on versions above 5.5.2

## Contributors
Luis A. Garnica Chavira

## Acknowledgements
This material is based upon work supported by the National Science Foundation (NSF) under Grant No. 1835897 and The United States Department of Agriculture under Grant No. 2015-68007-23130. This work used resources from Cyber-ShARE Center of Excellence supported by NSF Grant HDR-1242122. 

Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation. 

## License
This software code is licensed under the [GNU GENERAL PUBLIC LICENSE v3.0](./LICENSE) and uses third party libraries that are distributed under their own terms (see [LICENSE-3RD-PARTY.md](./LICENSE-3RD-PARTY.md)).

## Copyright
© 2023 University of Texas at El Paso (SWIM Project) 

