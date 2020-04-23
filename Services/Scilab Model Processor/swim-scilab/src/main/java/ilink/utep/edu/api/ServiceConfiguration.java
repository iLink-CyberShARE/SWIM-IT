package ilink.utep.edu.api;


import com.fasterxml.jackson.annotation.JsonProperty;
import io.dropwizard.Configuration;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import org.hibernate.validator.constraints.NotEmpty;

/*
* To change this license header, choose License Headers in Project Properties.
* To change this template file, choose Tools | Templates
* and open the template in the editor.
*/

/**
 *
 * @author lgarn
 */
public class ServiceConfiguration extends Configuration {
    
    /* Mongo Settings */
    
    @NotEmpty
    private String mongoUser;
    
    @NotEmpty
    private String mongoPassword;
    
    @NotEmpty
    private String mongoHost;
    
    @NotEmpty
    private String mongoDB;
    
    @Min(1)
    @Max(65535)
    private int mongoPort;
    
    /* Scilab Settings */
    
    @NotEmpty
    private String modelPath;
    
    
    /*gettrs and setters */
    
    @JsonProperty
    public String getMongoUser() {
        return mongoUser;
    }
    
    @JsonProperty
    public void setMongoUser(String mongoUser) {
        this.mongoUser = mongoUser;
    }
    
    @JsonProperty
    public String getMongoPassword() {
        return mongoPassword;
    }
    
    @JsonProperty
    public void setMongoPassword(String mongoPassword) {
        this.mongoPassword = mongoPassword;
    }
    
    @JsonProperty
    public String getMongoHost() {
        return mongoHost;
    }
    
    @JsonProperty
    public void setMongoHost(String mongoHost) {
        this.mongoHost = mongoHost;
    }
    
    @JsonProperty
    public String getMongoDB() {
        return mongoDB;
    }
    
    @JsonProperty
    public void setMongoDB(String mongoDB) {
        this.mongoDB = mongoDB;
    }
    
    @JsonProperty
    public int getMongoPort() {
        return mongoPort;
    }
    
    @JsonProperty
    public void setMongoPort(int mongoPort) {
        this.mongoPort = mongoPort;
    }
    
    @JsonProperty
    public String getModelPath() {
        return modelPath;
    }
    
    @JsonProperty
    public void setModelPath(String modelPath) {
        this.modelPath = modelPath;
    }
    
}
