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
Ken Thieman
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

