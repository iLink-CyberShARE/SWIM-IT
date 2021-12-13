package ilink.utep.edu.db;

import java.util.Arrays;

import org.mongodb.morphia.Datastore;
import org.mongodb.morphia.Morphia;

import com.mongodb.MongoClient;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;

import ilink.utep.edu.model.UserScenarioModel;

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
