package utep.cybershare.edu.runner;

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

import utep.cybershare.edu.WMDConfiguration;
import utep.cybershare.edu.model.UserScenarioModel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.gams.api.GAMSDatabase;
import com.gams.api.GAMSGlobals.DebugLevel;
import com.gams.api.GAMSJob;
import com.gams.api.GAMSOptions;
import com.gams.api.GAMSParameter;
import com.gams.api.GAMSVariable;
import com.gams.api.GAMSVariableRecord;
import com.gams.api.GAMSWorkspace;

public class BucketV1_Service {

	private UserScenarioModel userScenario = null;
	private WMDConfiguration config = null;
	GAMSJob t1 = null; 
	
	private double rho_pop0_p_value;
	private double elast_p_value;
	private int volume_start_p_value;
	private double urb_price_p_value;
	private double urb_use_p_value;
	private double urb_Av_cost0_p_value;
	private int Store_capac_p_value;
	private double pop0_p_value;


	public BucketV1_Service(UserScenarioModel userScenario, WMDConfiguration config){
		
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

			if (key.equals("elast_p"))
				this.elast_p_value = Double.parseDouble((String) value);
			if (key.equals("price_p"))
				System.out.println("price_p");
			if (key.equals("Evap_rate_p"))
				System.out.println("Evap_rate_p");
			if (key.equals("Store_capac_p"))
				this.Store_capac_p_value = Integer.parseInt((String) value);
			if (key.equals("land_p"))
				System.out.println("land");
			if (key.equals("urb_use_p"))
				this.urb_use_p_value = Double.parseDouble((String) value);
			if (key.equals("volume_start_p"))
				this.volume_start_p_value = Integer.parseInt((String) value);
			if (key.equals("wat_use_acre_p"))
				System.out.println("Wat");
			if (key.equals("B2_area_volsq_p"))
				System.out.println("B2");
			if (key.equals("urb_price_p"))
				this.urb_price_p_value = Double.parseDouble((String) value);
			if (key.equals("B1_area_vol_p"))
				System.out.println("B1");
			if (key.equals("US_Mexico_treaty_p"))
				System.out.println("US");
			if (key.equals("urb_Av_cost0_p"))
				this.urb_Av_cost0_p_value = Double.parseDouble((String) value);
			if (key.equals("inflow_p"))
				System.out.println("inflwo");
			if (key.equals("pop0_p"))
				this.pop0_p_value = Double.parseDouble((String) value);
			if (key.equals("rho_pop_p")) 
				this.rho_pop0_p_value = Double.parseDouble((String) value);
			if (key.equals("yield_p"))
				System.out.println("yield_p");
			if (key.equals("cost_p"))
				System.out.println("last kek");

		}
		
	}
	
	private void initializeGAMS(){
		/** Creating a workspace */

		//Virtual Machine configuration
		//GAMSWorkspace ws = new GAMSWorkspace("/home/osboxes/Documents/gamsdir/", "/opt/gams/gams24.7_linux_x64_64_sfx", DebugLevel.KEEP_FILES);
		
		//GAMSWorkspace ws = new GAMSWorkspace("/home/admin/Documents/gamsdir/", "/opt/gams/gams24.7_linux_x64_64_sfx", DebugLevel.KEEP_FILES);

		GAMSWorkspace ws = new GAMSWorkspace(config.getGamsWorkspace(), config.getGamsPath(), DebugLevel.KEEP_FILES);
		
		/** Add a database and add input data into the database */
		GAMSDatabase db = ws.addDatabase();
		
		/** ALL STRUCT TYPE OF TYPE VARIABLE */

		GAMSParameter rho_pop_p = db.addParameter("rho_pop_p", 0, "population growth rate per year");
		rho_pop_p.addRecord().setValue(rho_pop0_p_value);

		GAMSParameter volume_start_p = db.addParameter("volume_start_p", 0, "observed storage volume 2015 (1000 acre feet) jan 1 2015");
		volume_start_p.addRecord().setValue(volume_start_p_value);
		
		GAMSParameter elast_p = db.addParameter("elast_p", 0, "urban price elasticity of demand");
		elast_p.addRecord().setValue(elast_p_value); 
		
        GAMSParameter urb_price_p = db.addParameter("urb_price_p", 0, "urban base price of water");
        urb_price_p.addRecord().setValue( urb_price_p_value );
        
        GAMSParameter urb_use_p = db.addParameter("urb_use_p", 0, "urban base water use");
        urb_use_p.addRecord().setValue( urb_use_p_value );
        
        GAMSParameter urb_Av_cost0_p = db.addParameter("urb_Av_cost0_p", 0, "urban average cost of supply");
        urb_Av_cost0_p.addRecord().setValue( urb_Av_cost0_p_value );
        
        GAMSParameter Store_capac_p = db.addParameter("Store_capac_p", 0, "reservoir storage capacity	");
        Store_capac_p.addRecord().setValue( Store_capac_p_value );
		
        GAMSParameter pop0_p = db.addParameter("pop0_p", 0, "urban customer numbers 1000s");
        pop0_p.addRecord().setValue( pop0_p_value );
        

		/** Path specified in yaml configuration file */
		this.t1 = ws.addJobFromFile(config.getBucketFile());
		GAMSOptions opt = ws.addOptions();
		opt.defines("gdxincname", db.getName());
		
		this.t1.run(opt, db);
		
	}
	
    private void handleOutputs(){
    	// Hydrology block
    	this.getGAMSOutput("Volume_v", "Reservoir Storage Volume", "1000 acre-feet");
    	this.getGAMSOutput("Evaporation_v", "Reservoir Evaporation", "1000 acre-feet");
    	this.getGAMSOutput("surf_area_v", "Reservoir Surface Area", "1000 acres");
    	this.getGAMSOutput("Release_v", "Reservoir Surface Water Release ", "1000 acre-feet");
    	this.getGAMSOutput("Wat_use_ag_v", "Reservoir Release for Agricultural Irrigation", "1000 acre-feet");
    	
    	// Agriculture block
    	this.getGAMSOutput("acres_v", "Acres in production", "1000 acres");
    	this.getGAMSOutput("land_v", "Acres in all crop production", "1000 acres");
    	this.getGAMSOutput("yield_v", "Crop yield", "tons/acre");
    	this.getGAMSOutput("Ag_value_v", "irrigation economic benefits", "$US 1000 per year");
    	this.getGAMSOutput("Ag_value_acre_v", "farm income per acre", "$US per acre");
    	this.getGAMSOutput("tot_ag_value_v", "total ag value over crops", "$US 1000 per year");
    	
    	// Recreation block
    	this.getGAMSOutput("Rec_value_v", "recreation economic benefits", "$US 1000 per year");
    	
    	//Urban block
    	this.getGAMSOutput("urb_price_v", "urban water price", "$US 1000 per 1000 af");
    	this.getGAMSOutput("Wat_use_urb_v", " release for urban use", "1000 ac ft per year");
    	this.getGAMSOutput("urb_use_p_cap_v", "urban use per customer", "acre feet per year");
    	this.getGAMSOutput("urb_con_surp_v", "urban consumer surplus", "$US 1000 per year");
    	this.getGAMSOutput("urb_revenue_v", "urban gross revenues from water sales", "$US 1000 per year");
    	this.getGAMSOutput("urb_gross_ben_v", "urban gross benefits from water sales", "$US 1000 per year");
    	this.getGAMSOutput("urb_costs_v", "urban costs of water supply", "$US 1000 per year");
    	this.getGAMSOutput("Urb_value_v", "urban economic benefits", "$US 1000 per year");
    	this.getGAMSOutput("Urb_value_af_v", "urban economic value per ac", "$US per acre foot");
    	
    	//Institutions Block
    	this.getGAMSOutput("US_MX_v", "US Mexico 1906 Treaty surface deliveries", "1000 ac ft per year");
    	
    	//Total Economic Value Block
    	this.getGAMSOutput("tot_econ_value_v", "total economic value", "$US 1000 per year");
    	this.getGAMSOutput("Tot_npv_v", "total npv economic benefits", "$US 1000");
    	
    }
		
	private void getGAMSOutput(String varName, String varLabel, String varUnit){

		Map<String, Object> output = new HashMap<String, Object>();
		Map<String, Object> valueList = new HashMap<String, Object>();
		
		GAMSVariable variable = t1.OutDB().getVariable(varName);
		
		output.put("varName", varName);
		output.put("varLabel", varLabel);
		output.put("varUnit", varUnit);
		
		for (GAMSVariableRecord rec : variable) {
			//this needs a more dynamic logic to map the tables no matter the number of keys
			if(rec.getKeys().length == 0){ 
				valueList.put("0", (Object) rec.getLevel());
			}
			if(rec.getKeys().length == 1){
				valueList.put(rec.getKeys()[0], rec.getLevel());
			}
			if(rec.getKeys().length == 2){
				valueList.put(rec.getKeys()[0] + "-" + rec.getKeys()[1] , rec.getLevel());
			}
			
	    }
		output.put("varValue", valueList);
		this.userScenario.addModelOutput(output);
	}

	
    //getters and setters
	public UserScenarioModel getUserScenario() {
		return userScenario;
	}


	public void setUserScenario(UserScenarioModel userScenario) {
		this.userScenario = userScenario;
	}
	
}
