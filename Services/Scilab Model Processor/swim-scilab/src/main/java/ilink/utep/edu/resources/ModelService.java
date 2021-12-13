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
import ilink.utep.edu.model.UserScenarioModel;
import java.util.concurrent.atomic.AtomicLong;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 *
 * @author lgarn
 */
@Path("/runmodel")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ModelService {
    
    private final AtomicLong counter;
    private final String mongoUser;
    private final String mongoPassword;
    private final String mongoDB;
    private final String mongoHost;
    private final int mongoPort;
    private ServiceConfiguration config = null;

    public ModelService(ServiceConfiguration configuration) {
    	this.mongoUser = configuration.getMongoUser();
    	this.mongoPassword = configuration.getMongoPassword();
    	this.mongoDB = configuration.getMongoDB();
    	this.mongoHost = configuration.getMongoHost();
    	this.mongoPort = configuration.getMongoPort();
    	this.config = configuration;
        this.counter = new AtomicLong();
    }
    
    @POST
    @Timed
    public Object run(String jsonRequest){
                
      try {
        
        System.out.println("Request received!");
        MongoHandler mongoH = new MongoHandler(this.mongoUser, this.mongoPassword, this.mongoDB, this.mongoHost, this.mongoPort);
        ApplicationHandler appH = new ApplicationHandler(counter.incrementAndGet(), jsonRequest, mongoH, this.config);
        appH.RunScilabModel();
        return appH.getUserScenario();
      }
      
      catch(Exception e){
          System.err.println(e.getStackTrace());
          return null;
      }
      
    }
    
}
