/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ilink.utep.edu.resources;

import com.codahale.metrics.annotation.Timed;
import ilink.utep.edu.api.ApplicationHandler;
import ilink.utep.edu.api.ServiceConfiguration;
import ilink.utep.edu.db.MongoHandler;
import java.util.concurrent.atomic.AtomicLong;
import javax.ws.rs.GET;
import javax.ws.rs.Path;

/**
 *
 * @author lgarn
 */
@Path("/hello")
public class Service {
    
    private AtomicLong counter;
    private String mongoUser;
    private String mongoPassword;
    private String mongoDB;
    private String mongoHost;
    private int mongoPort;
    private ServiceConfiguration config = null;

    public Service(ServiceConfiguration configuration) {
    	this.mongoUser = configuration.getMongoUser();
    	this.mongoPassword = configuration.getMongoPassword();
    	this.mongoDB = configuration.getMongoDB();
    	this.mongoHost = configuration.getMongoHost();
    	this.mongoPort = configuration.getMongoPort();
    	this.config = configuration;
        this.counter = new AtomicLong();
    }
    
     @GET
     @Timed
     public String sayHello(){
        MongoHandler mongoH = new MongoHandler(this.mongoUser, this.mongoPassword, this.mongoDB, this.mongoHost, this.mongoPort);
        ApplicationHandler appH = new ApplicationHandler(counter.incrementAndGet(), "input", mongoH, this.config);
        
        return appH.SayHello();
     }
    
    
}
