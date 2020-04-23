package utep.cybershare.edu.api;

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

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.ObjectMapper;

import utep.cybershare.edu.WMDConfiguration;
import utep.cybershare.edu.db.MongoHandler;
import utep.cybershare.edu.mapper.InputMapperV4;
import utep.cybershare.edu.model.UserScenarioModel;
import utep.cybershare.edu.runner.BucketV6_Service;

import java.io.IOException;
import java.text.SimpleDateFormat;

import org.hibernate.validator.constraints.Length;

public class ApplicationHandler {
    private long id;
    private UserScenarioModel userScenario= null;


    @Length(max = 3)
    private String status;
    
    public ApplicationHandler(long id, String input, MongoHandler mh, WMDConfiguration config) {
        this.id = id;
        if (this.isValidJSON(input)){
            this.status = "processing";
            this.userScenario = new UserScenarioModel();
            InputMapperV4 im = new InputMapperV4(input, mh);
            this.userScenario = im.mapToModel(userScenario);
            
            //started time
            this.userScenario.setStartedAtTime(new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date()));
            
            im.saveToMongo(userScenario);
            
            //send model to gams runner here
            System.out.println("Running GAMS...");
            BucketV6_Service s5 = new BucketV6_Service(this.userScenario, config);
            
            //retrieve the model with model outputs here
            System.out.println("Retriving results...");
            this.userScenario = s5.getUserScenario();
            
            //set status to complete
            this.userScenario.setStatus("complete");
            
            //ended time
            this.userScenario.setEndedAtTime(new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date()));
            
            //update user scenario in mongo here
            System.out.println("Saving results...");
            im.saveToMongo(userScenario);
            
            //set service response to complete
            this.status = "complete";
            
            //return the final json here
            //mh.getMorphia().toDBObject(userScenario).toString();
            
            //close the mongo connection
            mh.closeConnection();
            
        }
        else { 
        	this.status = "invalid json input";
        	System.out.println("invalid input json");
        }
    }
    

    @JsonProperty
    public long getId() {
        return id;
    }

    @JsonProperty
    public String getStatus() {
        return status;
    }
    
    
    public UserScenarioModel getUserScenario() {
		return userScenario;
	}


	public boolean isValidJSON(final String json) {
    	   boolean valid = false;
    	   try {
    	    @SuppressWarnings("deprecation")
			final JsonParser parser = new ObjectMapper().getJsonFactory()
    	            .createJsonParser(json);
    	      while (parser.nextToken() != null) { }
    	      valid = true;
    	      if (json == null)
    	    	  valid = false;
    	   } catch (JsonParseException jpe) {
    	      return valid;
    	   } catch (IOException ioe) {
    	      return valid;
    	   }

    	   return valid;
    	}
}
