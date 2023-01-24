# GAMS Model Processor

The GAMS model Processor is a Restful web service packaged with dropwizard that enables model execution of in GAMS through their Java API. 
The service consumes a JSON structure with the scenario specification to execute. The service produces an extended JSON with appended output values.

The JSON structure is mapped to a MongoDB collection with the use of 
the Morphia library. 

## Environment
This service was tested on CentOS 7 

## Dependencies
+ JDK 1.8+ (Java)
+ Java Libraries: Managed with Maven
+ GAMS 24.7.4 with licence for Linux distribution

## Notes
The org.gams.api maven package was manually created as a local Maven (.m2) repository using the following command:

`mvn install:install-file -Dfile=/opt/gams/gams24.7_linux_x64_64_sfx/apifiles/Java/api/GAMSJavaAPI.jar -DgroupId=org.gams.api -DartifactId=gams-api -Dversion=1.0 -Dpackaging=jar`

All GAMS API dependencies must be included within the .m2 repository 
folder.

For more information on local Maven repositories follow:
<http://maven.apache.org/guides/mini/guide-3rd-party-jars-local.html>

## Contributors
Luis A. Garnica Chavira  
Jose Caballero  

## Acknowledgements
This material is based upon work supported by the National Science Foundation (NSF) under Grant No. 1835897 and The United States Department of Agriculture under Grant No. 2015-68007-23130. This work used resources from Cyber-ShARE Center of Excellence supported by NSF Grant HDR-1242122.   

Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation. 

## License
This software code is licensed under the [GNU GENERAL PUBLIC LICENSE v3.0](https://github.com/iLink-CyberShARE/SWIM-IT/blob/master/LICENSE) and uses third party libraries that are distributed under their own terms (see [LICENSE-3RD-PARTY.md](./LICENSE-3RD-PARTY.md)).

## Copyright
© 2019-2023 University of Texas at El Paso (SWIM Project) 