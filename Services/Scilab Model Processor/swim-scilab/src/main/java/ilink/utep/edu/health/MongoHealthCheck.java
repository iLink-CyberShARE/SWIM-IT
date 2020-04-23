package ilink.utep.edu.health;

import com.codahale.metrics.health.HealthCheck;
import ilink.utep.edu.api.ServiceConfiguration;

import ilink.utep.edu.db.MongoHandler;

public class MongoHealthCheck extends HealthCheck {
    private final String mongoUser;
    private final String mongoPassword;
    private final String mongoDB;
    private final String mongoHost;
    private final int mongoPort;

    public MongoHealthCheck(ServiceConfiguration configuration) {
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
