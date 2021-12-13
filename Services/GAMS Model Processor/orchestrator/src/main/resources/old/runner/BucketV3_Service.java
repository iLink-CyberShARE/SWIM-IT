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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

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

public class BucketV3_Service {

	private static Map<Object, Object> modelInputsMap_scalar;
	private static Map<Object, Object> modelInputsMap_tableDimension1;
	private static Map<Object, Object> modelInputsMap_tableDimension2;
	private static Map<Object, Object> modelInputsMap_tableDimension3;

	private static int m;
	private static int n;
	
	private UserScenarioModel userScenario = null;
	private WMDConfiguration config = null;
	GAMSJob t1 = null; 
	
	//input parameters to map


	public BucketV3_Service(UserScenarioModel userScenario, WMDConfiguration config){
		
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
		
		System.out.println("\n- PREP INPUTS -\n ");

		/** Prepare input data */
		List<Map<String, Object>> modelInputs = userScenario.getModelInputs();
		modelInputsMap_scalar = new HashMap<Object, Object>();
		modelInputsMap_tableDimension1 = new HashMap<Object, Object>();
		modelInputsMap_tableDimension2 = new HashMap<Object, Object>();
		modelInputsMap_tableDimension3 = new HashMap<Object, Object>();

		for (int i = 0; i < modelInputs.size(); i++) {

			Map<String, Object> kek = modelInputs.get(i); // all data up to this
															// point
			m++;
			System.out.println(m + " " + kek);

			for (Map.Entry<String, Object> entry : kek.entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				// System.out.println(key + " " + value);

				//Only scenario and user definition types will be mapped to gams
				if (value.equals("scenario") || value.equals("user")) {
					Object structType = kek.get("structType");
					Object structDimension = kek.get("structDimension");

					if (structType.equals("scalar")) {
						Object paramName = kek.get("paramName");
						Object paramValue = kek.get("paramValue");
						modelInputsMap_scalar.put(paramName, paramValue);
					}

					if (structType.equals("table") && structDimension.equals("1")) {
						Object paramName = kek.get("paramName");
						Object paramValue = kek.get("paramValue");
						modelInputsMap_tableDimension1.put(paramName, paramValue);
					}

					if (structType.equals("table") && structDimension.equals("2")) {
						Object paramName = kek.get("paramName");
						Object paramValue = kek.get("paramValue");
						modelInputsMap_tableDimension2.put(paramName, paramValue);
					}

					if (structType.equals("table") && structDimension.equals("3")) {
						Object paramName = kek.get("paramName");
						Object paramValue = kek.get("paramValue");
						modelInputsMap_tableDimension3.put(paramName, paramValue);
					}
				}
			}
		}

		System.out.println("\n- PARAM INPUT MAP -\n");

		System.out.println("Print Scalars");
		printMap(modelInputsMap_scalar);

		System.out.println("\nPrint Table Struct Dimension 1");
		printMap(modelInputsMap_tableDimension1);

		System.out.println("\nPrint Table Struct Dimension 2");
		printMap(modelInputsMap_tableDimension2);

		System.out.println("\nPrint Table Struct Dimension 3");
		printMap(modelInputsMap_tableDimension3);

		System.out.println("\n- - End of Prep Inputs - -\n");
		
	}
	
	private void initializeGAMS(){
		/** Creating a workspace */

		GAMSWorkspace ws = new GAMSWorkspace(config.getGamsWorkspace(), config.getGamsPath(), DebugLevel.KEEP_FILES);
		
		/** Add a database and add input data into the database */
		GAMSDatabase db = ws.addDatabase();
		

		/**
		 * Handle and input into GAMS specific type of structures such as -
		 * Scalars - Table with dimension 1 - 3
		 */
		
		//mapping scalars
		handleScalars(db);
		
		//TODO: 1 to n dimension tables should be handled on a single dynamic function
		
		//mapping dimension 1 tables
		handleTablesDimension1(db);

		System.out.println("\n");
		
		//mapping dimension 2 tables
		handleTablesDimension2(db);
		
		//TODO: handle dimension 3 tables


        
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
	
	private void printMap(Map<Object, Object> inputMap) {
		System.out.println("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ");
		for (Iterator<?> iterator = inputMap.keySet().iterator(); iterator.hasNext();) {
			Object key = (String) iterator.next();
			Object value = inputMap.get(key);
			n++;
			System.out.println(n + ". " + key + " -> " + value);
		}

		n = 0;
	}
	
	private List removeRepeated(List<String> list){
		Set<String> x = new LinkedHashSet<String>();
				
		x.addAll(list);
		list.clear();
		list.addAll(x);
		
		return list;
		
	}
	
	private void handleScalars(GAMSDatabase db) {
		for (Iterator<?> iterator = modelInputsMap_scalar.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			Double value = Double.parseDouble((String) modelInputsMap_scalar.get(key));
			// System.out.println(key + " -> " + value);

			GAMSParameter GAMSParameter;
			GAMSParameter = db.addParameter(key, 0);
			// System.out.println("GAMS " + GAMSParameter.getName());
			GAMSParameter.addRecord().setValue(value);
		}
	}
	
	/* Uses a regular hashtable to hold key value pairs */
	private void handleTablesDimension1(GAMSDatabase db) {
		//array to hold the keys
		ArrayList<String> holdDemKeysFam = new ArrayList<String>();
		int counter = 0;

		for (Iterator<?> iterator = modelInputsMap_tableDimension1.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			Object value = modelInputsMap_tableDimension1.get(key);
			n++;
			// System.out.println(n + ". " + key + " -> " + value);

			JSONArray arr = (JSONArray) value;
			Map<String, Double> holdThisFam = new HashMap<String, Double>();

			for (int i = 0; i < arr.size(); i++) {
				JSONObject objects = (JSONObject) arr.get(i);

				for (Iterator<?> keys = objects.keySet().iterator(); keys.hasNext();) {
					String tablekey = (String) keys.next();
					holdDemKeysFam.add(tablekey);
					break;
				}

				for (Iterator<?> keys = objects.keySet().iterator(); keys.hasNext();) {

					String tablekey = (String) keys.next();
					String getKey = (String) objects.get(holdDemKeysFam.get(counter));
					String getKeyValue = (String) objects.get("value");
					// System.out.println(counter + ". " + getKey + " - - - - -
					// " + getKeyValue);
					holdThisFam.put(getKey, Double.parseDouble(getKeyValue));

				}
				counter++;
			}
			// System.out.println("CURRENTLY HOLDING THIS FAM : " + key + " -> "
			// + holdThisFam);
			// System.out.println("CURRENTLY HOLDING THIS KEYS FAM : " +
			// holdDemKeysFam + "\n");

			GAMSParameter GAMSParameter;
			GAMSParameter = db.addParameter(key, 1);
			System.out.println("GAMS " + GAMSParameter.getName());
			for (String t : holdThisFam.keySet()) {
				// System.out.println(t + " -> " + holdThisFam.get(t));
				GAMSParameter.addRecord(t).setValue(holdThisFam.get(t));
			}

		}

	}
	
	/* uses map <vector, string> to hold multiple key sets and string as the referenced value */
	private void handleTablesDimension2(GAMSDatabase db) {
		ArrayList<String> holdDemKeysFam = new ArrayList<String>();
		List<String> xkeys = new ArrayList<String>();
		List<String> ykeys = new ArrayList<String>();
		List<String> values = new ArrayList<String>();		
		Map<Vector<String>, Double> toGams = new HashMap<Vector<String>, Double>();
		int counter = 0;
		int count = 0;
		
		for (Iterator<?> iterator = modelInputsMap_tableDimension2.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			Object value = modelInputsMap_tableDimension2.get(key);
			n++;
			System.out.println(n + ". " + key + " -> " + value);

			JSONArray arr = (JSONArray) value;
			Map<String, Double> holdThisFam = new HashMap<String, Double>();

			for (int i = 0; i < arr.size(); i++) {
				JSONObject objects = (JSONObject) arr.get(i);
				System.out.println("CURRENTLY AT " + objects + " - object size is " + objects.size());
				for (Iterator<?> keys = objects.keySet().iterator(); keys.hasNext();) {
					String tablekey = (String) keys.next();
//					holdDemKeysFam.add(tablekey);
					String tableKeyVal = (String) objects.get(tablekey);

					
					if (count == 0) {
						ykeys.add(tableKeyVal);
					}
					if (count == 1) {
						xkeys.add(tableKeyVal);
					}
					if (count == 2) {
						values.add(tableKeyVal);
					}
					count++;
				}
				counter++;
				count = 0;
			}

			System.out.println();
			removeRepeated(xkeys);
			removeRepeated(ykeys);
			
			System.out.println("XKEYS " + xkeys);
			System.out.println("YKEYS " + ykeys);
			System.out.println("VALUES " + values);
			
			int numCount = 0;
			for (int i = 0; i < xkeys.size(); i++) {
				for (int j = 0; j < ykeys.size(); j++) {
					System.out.println("[" + xkeys.get(i) + ", " +  ykeys.get(j) + "]"  +  " -> " + values.get(numCount));
				    toGams.put( new Vector<String>( Arrays.asList(new String[]{xkeys.get(i), ykeys.get(j)}) ),   Double.valueOf(values.get(numCount))); 
				    numCount++;
				}	
			}
			
			GAMSParameter GAMSParameter;
			GAMSParameter = db.addParameter(key, 2);
			System.out.println("\nGAMS " + GAMSParameter.getName());
						
			System.out.println(toGams);
			System.out.println("\n");
			
			xkeys.clear();
			ykeys.clear();
			values.clear();
			toGams.clear();
		}

	}
	
	
    //getters and setters
	public UserScenarioModel getUserScenario() {
		return userScenario;
	}


	public void setUserScenario(UserScenarioModel userScenario) {
		this.userScenario = userScenario;
	}
	
}
