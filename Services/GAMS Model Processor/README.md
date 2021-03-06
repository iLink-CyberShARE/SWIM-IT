# GAMS Model Processor

## Description
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
The org.gams.api maven package was manually created on the local .m2 repository using the following command:

`mvn install:install-file -Dfile=/opt/gams/gams24.7_linux_x64_64_sfx/apifiles/Java/api/GAMSJavaAPI.jar -DgroupId=org.gams.api -DartifactId=gams-api -Dversion=1.0 -Dpackaging=jar`

All GAMS API dependencies must be included within the .m2 repository 
folder.

For more information on local Maven repositories follow:
<http://maven.apache.org/guides/mini/guide-3rd-party-jars-local.html>

