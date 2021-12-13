package ilink.utep.edu.api;


import ilink.utep.edu.health.MongoHealthCheck;
import ilink.utep.edu.resources.ModelService;
import ilink.utep.edu.resources.Service;
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import java.util.EnumSet;
import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterRegistration;
import org.eclipse.jetty.servlets.CrossOriginFilter;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author lgarn
 */
public class ServiceApplication extends Application<ServiceConfiguration> {
    
    public static void main(String[] args) throws Exception {
        new ServiceApplication().run(args);
    }
    
    @Override
    public void initialize(Bootstrap<ServiceConfiguration> bootstrap) {
        //TODO:Report to the registry service here...
    }
    
    

    @Override
    public void run(ServiceConfiguration configuration, Environment environment){
        
        // Enable CORS headers
        final FilterRegistration.Dynamic cors = environment.servlets().addFilter("CORS", (Class<? extends Filter>) CrossOriginFilter.class);
        cors.setInitParameter("allowedOrigins", "*");
        cors.setInitParameter("allowedHeaders", "X-Requested-With,Content-Type,Accept,Origin");
        cors.setInitParameter("allowedMethods", "GET, POST, OPTIONS, HEAD");
        
        // Add URL mapping
        cors.addMappingForUrlPatterns(EnumSet.allOf(DispatcherType.class), true, "/*");
        
        // Enable CORS for health checks
        FilterRegistration.Dynamic healthCors = environment.getAdminContext().getServletContext().addFilter("CORS", (Class<? extends Filter>) CrossOriginFilter.class);
        healthCors.setInitParameter("allowedOrigins", "*");
        healthCors.setInitParameter("allowedHeaders", "X-Requested-With,Content-Type,Accept,Origin");
        healthCors.setInitParameter("allowedMethods", "GET, OPTIONS, HEAD");
        healthCors.addMappingForUrlPatterns(EnumSet.allOf(DispatcherType.class), true, "/ping");

        final Service helloResource = new Service(configuration);
        final ModelService  modelResource = new ModelService(configuration);
        
        final MongoHealthCheck mongohealthCheck = new MongoHealthCheck(configuration);
        environment.healthChecks().register("Mongo", mongohealthCheck);
        environment.jersey().register(helloResource);
        environment.jersey().register(modelResource);
       
    }
    
}
