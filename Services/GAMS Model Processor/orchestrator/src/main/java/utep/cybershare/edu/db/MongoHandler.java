package utep.cybershare.edu.db;

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

import java.util.Arrays;

import org.mongodb.morphia.Datastore;
import org.mongodb.morphia.Morphia;

import com.mongodb.MongoClient;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;

import utep.cybershare.edu.model.UserScenarioModel;

public class MongoHandler {

	private String mongoUser;
	private char[] mongoPassword;
	private String mongoDB;
	private String mongoHost;
	private int mongoPort;
	
	private Datastore ds;
	private Morphia morphia;
	private MongoClient mongoClient;
	
	public MongoHandler(String mongoUser, String mongoPassword, String mongoDB, String mongoHost, int mongoPort) {
		super();
		this.mongoUser = mongoUser;
		this.mongoPassword = mongoPassword.toCharArray();
		this.mongoDB = mongoDB;
		this.mongoHost = mongoHost;
		this.mongoPort = mongoPort;
		this.openConnection();
	}
	
	
	private void openConnection(){
		//Mongo Client connection
		MongoCredential credential = MongoCredential.createCredential(this.mongoUser, this.mongoDB, this.mongoPassword);	
		this.mongoClient = new MongoClient(new ServerAddress(this.mongoHost, this.mongoPort), Arrays.asList(credential));
		
    	//Instantiate morphia
    	morphia = new Morphia();
    	
    	//Map the model classes
    	morphia.map(UserScenarioModel.class);
    	
    	//Create the datastore
    	ds = morphia.createDatastore(mongoClient, this.mongoDB);
	}
	
	public boolean isConnected(){
		try {
			  mongoClient.getAddress();
			} catch (Exception e) {
			  System.out.println("Mongo is down");
			  this.closeConnection();
			  return false;
			}
		return true;
		
	}
	
	public void closeConnection(){
		this.mongoClient.close();
		
	}

	//Getters and setters
	public Datastore getDs() {
		return ds;
	}

	public MongoClient getMongoClient() {
		return mongoClient;
	}


	public Morphia getMorphia() {
		return morphia;
	}

	
}
