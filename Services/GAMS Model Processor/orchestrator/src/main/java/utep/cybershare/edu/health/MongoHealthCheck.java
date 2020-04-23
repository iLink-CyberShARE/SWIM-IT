package utep.cybershare.edu.health;

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

import com.codahale.metrics.health.HealthCheck;

import utep.cybershare.edu.WMDConfiguration;
import utep.cybershare.edu.db.MongoHandler;

public class MongoHealthCheck extends HealthCheck {
    private final String mongoUser;
    private final String mongoPassword;
    private final String mongoDB;
    private final String mongoHost;
    private final int mongoPort;

    public MongoHealthCheck(WMDConfiguration configuration) {
    	this.mongoUser = configuration.getMongoUser();
    	this.mongoPassword = configuration.getMongoPassword();
    	this.mongoDB = configuration.getMongoDB();
    	this.mongoHost = configuration.getMongoHost();
    	this.mongoPort = configuration.getMongoPort();
    }

    @Override
    protected Result check() throws Exception {
    	MongoHandler mongoH = new MongoHandler(this.mongoUser, this.mongoPassword, this.mongoDB, this.mongoHost, this.mongoPort);
    	
        if (!mongoH.isConnected()) {
            return Result.unhealthy("Mongo connection could not be established");
        }
    	mongoH.closeConnection();
        return Result.healthy();
    }
}
