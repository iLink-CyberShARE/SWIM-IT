package utep.cybershare.edu.runner;

import utep.cybershare.edu.WMDConfiguration;

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

import utep.cybershare.edu.model.UserScenarioModel;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.gams.api.GAMSDatabase;
import com.gams.api.GAMSGlobals.DebugLevel;
import com.gams.api.GAMSJob;
import com.gams.api.GAMSOptions;
import com.gams.api.GAMSParameter;
import com.gams.api.GAMSVariable;
import com.gams.api.GAMSVariableRecord;
import com.gams.api.GAMSWorkspace;

public class BucketV2_Service {

	private UserScenarioModel userScenario = null;
	private WMDConfiguration config = null;
	GAMSJob t1 = null; 
	
	//input parameters to map


	public BucketV2_Service(UserScenarioModel userScenario, WMDConfiguration config){
		
		this.userScenario = userScenario;
		this.config = config;
		
		//prepare input data
		this.prepInputs();
		
		//set gams parameters and execute
		this.initializeGAMS();
		
		//handle outputs
		this.handleOutputs();
		
	}
	
	
	private void prepInputs(){
		
		/** Prepare input data */
		List<Map<String, Object>> modelInputs = userScenario.getModelInputs();

		Map<Object, Object> modelInputsMap = new HashMap<Object, Object>();
		for (int i = 0; i < modelInputs.size(); i++) {

			Map<String, Object> kek = modelInputs.get(i);

			for (Map.Entry<String, Object> entry : kek.entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				// System.out.println(key + " " + value);

				if (key.equals("paramName")) {
					Object paramName = value;
					Object paramValue = kek.get("paramValue");
					modelInputsMap.put(paramName, paramValue);
				}
			}
		}

		System.out.println("PARAM INPUT MAP");

		for (Iterator<?> iterator = modelInputsMap.keySet().iterator(); iterator.hasNext();) {
			Object key = (String) iterator.next();
			Object value = modelInputsMap.get(key);

			/*
			if (key.equals("elast_p"))
				this.elast_p_value = Double.parseDouble((String) value);
	        */


		}
		
	}
	
	private void initializeGAMS(){
		/** Creating a workspace */

		GAMSWorkspace ws = new GAMSWorkspace(config.getGamsWorkspace(), config.getGamsPath(), DebugLevel.KEEP_FILES);
		
		/** Add a database and add input data into the database */
		GAMSDatabase db = ws.addDatabase();
		
		/** ALL STRUCT TYPE OF TYPE VARIABLE */

		//SET PARAMETER VALUES
		//GAMSParameter rho_pop_p = db.addParameter("rho_pop_p", 0, "population growth rate per year");
		//rho_pop_p.addRecord().setValue(rho_pop0_p_value);

        
		/** Path specified in yaml configuration file */
		this.t1 = ws.addJobFromFile(config.getBucketFile());
		GAMSOptions opt = ws.addOptions();
		opt.defines("gdxincname", db.getName());
		
		this.t1.run(opt, db);
		
	}
	
    private void handleOutputs(){
    	 List<String> ykeys = new ArrayList<String>();
    	
     	// Water Activity
     	this.getGAMSOutput("X_v", "Flows -- all kinds", "1000 af/yr");
        this.getGAMSOutput("Z_v", "Water Stocks -- Reservoirs", "1000 af/yr");
        this.getGAMSOutput("Q_v", "Aquifer Storage Volume", "1000 af/yr");
     	
     	// Water Use
        this.getGAMSOutput("Ag_use_v", "Irrigation Surface Water Use", "1000 af/yr");
        this.getGAMSOutput("urb_use_v", "Urban Water Use", "1000 af/yr");
         
    	// Economics
    	this.getGAMSOutput("Ag_Ben_v", "Farm Income", "$1000/yr");
    	this.getGAMSOutput("urb_value_v", "Urban Net Benefits", "$1000/yr");
    	this.getGAMSOutput("rec_ben_v", "Reservoir Recreational Benefits", "$1000/yr");
    	this.getGAMSOutput("Env_ben_v", "Environmental Benefits", "$1000/yr");
    	
    }
		
	private void getGAMSOutput(String varName, String varLabel, String varUnit){
 
		Map<String, Object> output = new HashMap<String, Object>();
		GAMSVariable variable = t1.OutDB().getVariable(varName);
		List<String> domains = new ArrayList<String>();
		JSONArray jsonArray = new JSONArray();
		int dimension = 0;
		
		output.put("varName", varName);
		output.put("varLabel", varLabel);
		output.put("varUnit", varUnit);
		output.put("description", variable.getText());
		
		dimension= variable.getDimension();
		domains = variable.getDomainsAsStrings();
		
		
		for (GAMSVariableRecord rec : variable) {
			//this needs a more dynamic logic to map the tables no matter the number of keys

			JSONObject jsonObj= new JSONObject();
			
			for (int i = 0; i < dimension; i++){
				jsonObj.put(domains.get(i), rec.getKeys()[i]);
			}
			
			jsonObj.put("value", this.round(rec.getLevel(), 2));
		    jsonArray.add(jsonObj);

	    }
		
		output.put("varValue",  jsonArray);
		this.userScenario.addModelOutput(output);
	}

	//utilities
	private  double round(double value, int places) {
	    if (places < 0) throw new IllegalArgumentException();

	    BigDecimal bd = new BigDecimal(value);
	    bd = bd.setScale(places, RoundingMode.HALF_UP);
	    return bd.doubleValue();
	}
	
	
    //getters and setters
	public UserScenarioModel getUserScenario() {
		return userScenario;
	}


	public void setUserScenario(UserScenarioModel userScenario) {
		this.userScenario = userScenario;
	}
	
}
