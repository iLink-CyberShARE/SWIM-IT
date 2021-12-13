package utep.cybershare.edu.resources;

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

import com.codahale.metrics.annotation.Timed;

import utep.cybershare.edu.WMDConfiguration;
import utep.cybershare.edu.api.ApplicationHandler;
import utep.cybershare.edu.db.MongoHandler;
import utep.cybershare.edu.model.UserScenarioModel;

import javax.net.ssl.SSLContext;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;

import org.glassfish.jersey.SslConfigurator;

import java.util.concurrent.atomic.AtomicLong;

@Path("/user-scenario-input")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class Service {
    private final AtomicLong counter;
    private final String mongoUser;
    private final String mongoPassword;
    private final String mongoDB;
    private final String mongoHost;
    private final int mongoPort;
    private WMDConfiguration config = null;

    public Service(WMDConfiguration configuration) {
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
    public UserScenarioModel sayHello(String jsonRequest) {

        MongoHandler mongoH = new MongoHandler(this.mongoUser, this.mongoPassword, this.mongoDB, this.mongoHost, this.mongoPort);
        System.out.println(jsonRequest);
        //return new ApplicationHandler(counter.incrementAndGet(), jsonRequest, mongoH, this.config);
        ApplicationHandler apph = new ApplicationHandler(counter.incrementAndGet(), jsonRequest, mongoH, this.config);

        return apph.getUserScenario();
        
    }
}
