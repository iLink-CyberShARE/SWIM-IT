/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ilink.utep.edu.api;

import ilink.utep.edu.db.MongoHandler;
import ilink.utep.edu.mapper.InputMapperV4;
import ilink.utep.edu.model.UserScenarioModel;
import ilink.utep.edu.runner.ScilabV1_Dev;
import java.text.SimpleDateFormat;

/**
 *
 * @author lgarn
 */
public class ApplicationHandler {
    
    private long id;
    private UserScenarioModel userScenario= null;
    
    private String jsonInput;
    private ServiceConfiguration configuration;
    MongoHandler mh;
    
    public ApplicationHandler(long id, String input, MongoHandler mh, ServiceConfiguration config){
        jsonInput = input;
        this.mh = mh;
        configuration = config;
    }
    
    
    public void RunScilabModel(){
        
        try {
            //user scenario data model instance
            this.userScenario = new UserScenarioModel();

            //map json inpuy input into morphia data model
            InputMapperV4 im = new InputMapperV4(jsonInput, mh);
            userScenario = im.mapToModel(userScenario);

            //set execution start time
            userScenario.setStartedAtTime(new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date()));

            //start runner
            ScilabV1_Dev sci_runner = new ScilabV1_Dev(userScenario, configuration.getModelPath());

            //retrive extended model with generated outputs
            userScenario = sci_runner.getUserScenario();

            //set execution end time (todo)
            userScenario.setEndedAtTime(new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date()));

            //set status to complete
            userScenario.setStatus("complete");

            //update user scenario in mongo
            im.saveToMongo(userScenario);

            // close mongo connection
            // mh.closeConnection();
            
        } catch(Exception e){
            System.err.println(e.getMessage());
        }
        
    }
    
    public UserScenarioModel getUserScenario() {
        return userScenario;
    }
    
    public String SayHello(){
        return "Hello from Scilab Webservice!";
    }
    
    
}
