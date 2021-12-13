package utep.cybershare.edu;

/*-
 * #%L
 * Water Modeling Distributor
 * $Id:$
 * $HeadURL:$
 * %%
 * Copyright (C) 2016 University of Texas at El Paso
 * %%
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public
 * License along with this program.  If not, see
 * <http://www.gnu.org/licenses/gpl-3.0.html>.
 * #L%
 */

import java.util.EnumSet;

import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterRegistration;
import org.eclipse.jetty.servlets.CrossOriginFilter;
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import utep.cybershare.edu.health.MongoHealthCheck;
import utep.cybershare.edu.resources.Service;


public class WMDApplication extends Application<WMDConfiguration> {
    public static void main(String[] args) throws Exception {
        new WMDApplication().run(args);
    }

    @Override
    public void initialize(Bootstrap<WMDConfiguration> bootstrap) {
        // nothing to do yet
    }

    @Override
    public void run(WMDConfiguration configuration, Environment environment) {
    	
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
        
        final Service resource = new Service(configuration);
        
        final MongoHealthCheck mongohealthCheck = new MongoHealthCheck(configuration);
        environment.healthChecks().register("Mongo", mongohealthCheck);
        environment.jersey().register(resource);
    }

}
