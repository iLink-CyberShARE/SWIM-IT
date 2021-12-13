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

import utep.cybershare.edu.model.UserScenarioModel;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import com.gams.api.GAMSDatabase;
import com.gams.api.GAMSGlobals.DebugLevel;
import com.gams.api.GAMSJob;
import com.gams.api.GAMSOptions;
import com.gams.api.GAMSParameter;
import com.gams.api.GAMSParameterRecord;
import com.gams.api.GAMSSet;
import com.gams.api.GAMSVariable;
import com.gams.api.GAMSVariableRecord;
import com.gams.api.GAMSWorkspace;

public class BucketV4_Dev {

	private static Map<Object, Object> modelInputsMap_scalar;
	private static Map<Object, Object> modelInputsMap_tableDimension1;
	private static Map<Object, Object> modelInputsMapAll;

	// temporary filled outputs
	List<Map<String, Object>> modelOutputs_new = new ArrayList<Map<String, Object>>();

	private static int m;
	private static int n;

	private UserScenarioModel userScenario = null;
	GAMSJob t1 = null;

	// input parameters to map

	public BucketV4_Dev(UserScenarioModel userScenario) {

		this.userScenario = userScenario;

		// prepare input data
		this.prepInputs();

		// set gams parameters and execute
		this.initializeGAMS();

		// handle outputs
		this.handleOutputs();

	}

	private void prepInputs() {
		System.out.println("\n- MODEL INPUTS -\n ");
		System.out.println("Uncommented inputs to save console space c:");
		
		/** Prepare input data */
		List<Map<String, Object>> modelInputs = userScenario.getModelInputs();
		List<Map<String, Object>> modelOutputs = userScenario.getModelOutputs();
		List<Map<String, Object>> modelSettings = userScenario.getModelSettings();

		// Holds scalar parameters, only single value, no keys
		modelInputsMap_scalar = new HashMap<Object, Object>();
		// Holds parameters of dimension 1 (key, value pair)
		modelInputsMap_tableDimension1 = new HashMap<Object, Object>();
		// Holds parameters of dimension 2 and above, multiple keys with one
		// value
		modelInputsMapAll = new HashMap<Object, Object>();

		for (int i = 0; i < modelInputs.size(); i++) {

			Map<String, Object> modelInputsMap = modelInputs.get(i);
			m++;
			
			/** Uncomment the following line to display all model inputs*/
			//System.out.println(m + " " + modelInputsMap);

			for (Map.Entry<String, Object> entry : modelInputsMap.entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				// System.out.println(key + " " + value);

				// Only scenario and user definition types will be mapped to
				// gams
				if (value.equals("scenario") || value.equals("user")) {
					Object structType = modelInputsMap.get("structType");
					Object structDimension = modelInputsMap.get("structDimension");

					if (structType.equals("scalar")) {
						Object paramName = modelInputsMap.get("paramName");
						Object paramValue = modelInputsMap.get("paramValue");
						modelInputsMap_scalar.put(paramName, paramValue);
						// modelInputsMapAll.put(paramName, paramValue);
					}
					if (structType.equals("table") && structDimension.equals("1")) {
						Object paramName = modelInputsMap.get("paramName");
						Object paramValue = modelInputsMap.get("paramValue");
						modelInputsMap_tableDimension1.put(paramName, paramValue);
						// modelInputsMap.put(paramName, paramValue);
					}

					if (structType.equals("table") && !structDimension.equals("1")) {
						Object paramName = modelInputsMap.get("paramName");
						Object paramValue = modelInputsMap.get("paramValue");
						modelInputsMapAll.put(paramName, paramValue);
					}
				}
			}
		}

		System.out.println("\n- MODEL OUTPUTS -\n ");
		System.out.println("Uncommented inputs to save console space c:");
		//printListOfMaps(modelOutputs);

		System.out.println("\n- MODEL SETTINGS -\n ");
		System.out.println("Uncommented inputs to save console space c:");
//		printListOfMaps(modelSettings);

		System.out.println("\n- PARAM INPUT MAP -\n");

		System.out.println("Print Scalars");
		printMap(modelInputsMap_scalar);

		System.out.println("\nPrint Table Struct Dimension 1");
		printMap(modelInputsMap_tableDimension1);

		System.out.println("\nPrint Table Struct Dimension 2 .. n");
		printMap(modelInputsMapAll);

		System.out.println("\n- - End of Prep Inputs - -\n");
	}

	private void initializeGAMS() {
		/** Creating a workspace */

		// Virtual Machine configuration
//		GAMSWorkspace ws = new GAMSWorkspace("/home/osboxes/Documents/gamsdir/", "/opt/gams/gams24.7_linux_x64_64_sfx/",
//				DebugLevel.KEEP_FILES);
		
		/**Local server configuration */
		GAMSWorkspace ws = new GAMSWorkspace("/home/admin/Documents/gamsdir/", "/opt/gams/gams24.7_linux_x64_64_sfx",
				DebugLevel.KEEP_FILES);

		// Webservice configuration
		// GAMSWorkspace ws = new GAMSWorkspace(config.getGamsWorkspace(),
		// config.getGamsPath(), DebugLevel.KEEP_FILES);

		/** Add a database and add input data into the database */
		GAMSDatabase db = ws.addDatabase();

		/**
		 * Handle and input into GAMS specific type of structures such as -
		 * Scalars - Table with dimension 1 - 3
		 */

		System.out.println("\n- - BEGIN GAMS INITIALIZATION - -\n");
		
		//adding filter sets
		
		//add selected policy: "1-policy_hist", "2-policy_base", "3-policy_new"
		GAMSSet set;
	    set = db.addSet("p2", 1);
	    set.addRecord("1-policy_hist");
	    
	    //add supply: "1-w_supl_base", "2-w_supl_new"
		GAMSSet set2;
	    set2 = db.addSet("w2", 1);
	    set2.addRecord("1-w_supl_base");
		

		// mapping scalars
		handleScalars(db);
		System.out.println("\n");

		// mapping dimension 1 tables (parameters)
		handleTablesDimension1(db);
		System.out.println("\n");

		// mapping dimension 2 and above tables
		handleEVERYTHING(db);
	
		// printMap(modelInputsMap_scalar);

		/** Path specified in yaml configuration file */
		List<Map<String, Object>> modelSettings = userScenario.getModelSettings();
		String solver = getSolver(modelSettings);
		//System.out.println("**** SOLVER ***** ->" + solver);

		// test case04
		this.t1 = ws.addJobFromFile("src/main/resources/BMOct9-ServiceReady.gms");
		GAMSOptions opt = ws.addOptions();

		opt.defines("gdxincname", db.getName());
		this.t1.run(opt, db);

	}

	private void handleOutputs() {
		System.out.println("\nHANDLE OUTPUTS\n");
		List<Map<String, Object>> modelOutputs = userScenario.getModelOutputs();
		String varName = "";
		String varLabel = "";
		String varUnit = "";
		String varDescription = "";
		String varCategory = "";
		String varType = "";

		m = 0;

		for (int i = 0; i < modelOutputs.size(); i++) {

			Map<String, Object> modelMap = modelOutputs.get(i);
			m++;

			// System.out.println(m + " " + modelMap);
			for (int j = 0; j < modelMap.size(); j++) {
				varName = (String) modelMap.get("varName");
				varLabel = (String) modelMap.get("varLabel");
				varUnit = (String) modelMap.get("varUnit");
				varDescription = (String) modelMap.get("varDescription");
				varCategory = (String) modelMap.get("varCategory");
				varType = (String) modelMap.get("varType");

			}
			// System.out.println(varName + " " + varLabel + " " + varUnit);
			if(varType != null) {
				if(varType.compareTo("outParam") == 0)
				this.getGAMSOutputParameter(varName, varLabel, varUnit, varDescription, varCategory);
			}
			else
				this.getGAMSOutput(varName, varLabel, varUnit, varDescription, varCategory);
		}

		userScenario.setModelOutputs(modelOutputs_new);

	}
	
	/*
	 * Get model output parameter optimized output param
	 * 
	 */
	private void getGAMSOutputParameter(String varName, String varLabel, String varUnit, String varDescription, String varCategory) {
		Map<String, Object> output = new HashMap<String, Object>();
		GAMSParameter outputParam = t1.OutDB().getParameter(varName);
		List<String> domains = new ArrayList<String>();
		JSONArray jsonArray = new JSONArray();
		int dimension = 0;
		
		output.put("varName", varName);
		output.put("varLabel", varLabel);
		output.put("varUnit", varUnit);
		output.put("varDescription", varDescription);
		output.put("varCategory", varCategory);
		
		dimension = outputParam.getDimension();
		domains = outputParam.getDomainsAsStrings();
		
		for (GAMSParameterRecord rec : outputParam) {
			JSONObject jsonObj = new JSONObject();

			for (int i = 0; i < dimension; i++) {
				jsonObj.put(domains.get(i), rec.getKeys()[i]);

			}

			jsonObj.put("value", this.round(rec.getValue(), 2));
			jsonArray.add(jsonObj);
		}
		
		output.put("varValue", jsonArray);
		
		//load the output variable to a temporary map
		modelOutputs_new.add(output);
		
		System.out.println("output :" + output);
	
	}

	
	/*
	 * Get model output variable
	 * 
	 */
	private void getGAMSOutput(String varName, String varLabel, String varUnit, String varDescription,
			String varCategory) {

		Map<String, Object> output = new HashMap<String, Object>();
		GAMSVariable variable = t1.OutDB().getVariable(varName);
		List<String> domains = new ArrayList<String>();
		JSONArray jsonArray = new JSONArray();
		int dimension = 0;

		output.put("varName", varName);
		output.put("varLabel", varLabel);
		output.put("varUnit", varUnit);
		output.put("varDescription", varDescription);
		output.put("varCategory", varCategory);

		dimension = variable.getDimension();
		domains = variable.getDomainsAsStrings();

		for (GAMSVariableRecord rec : variable) {
			JSONObject jsonObj = new JSONObject();

			for (int i = 0; i < dimension; i++) {
				jsonObj.put(domains.get(i), rec.getKeys()[i]);

			}

			jsonObj.put("value", this.round(rec.getLevel(), 2));
			jsonArray.add(jsonObj);
		}

		output.put("varValue", jsonArray);

		// load the output variable to a temporary map
		modelOutputs_new.add(output);

		System.out.println("output :" + output);

	}

	// utilities
	private double round(double value, int places) {
		if (places < 0)
			throw new IllegalArgumentException();

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

	private void printListOfMaps(List<Map<String, Object>> inputListMap) {
		System.out.println("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ");
		m = 0;
		for (int i = 0; i < inputListMap.size(); i++) {
			Map<String, Object> modelMap = inputListMap.get(i); // all data up
																// to this point
			m++;
			System.out.println(m + " " + modelMap);
		}
	}

	private String getSolver(List<Map<String, Object>> modelSettings) {
		System.out.println("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ");
		m = 0;
		for (int i = 0; i < modelSettings.size(); i++) {
			Map<String, Object> modelMap = modelSettings.get(i);
			m++;
			System.out.println(m + " " + modelMap);
			return (String) modelMap.get("solver");
		}
		return null;
	}

	private void handleScalars(GAMSDatabase db) {
		for (Iterator<?> iterator = modelInputsMap_scalar.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			Double value = Double.valueOf(modelInputsMap_scalar.get(key).toString());
			System.out.println(key + " -> " + value);

			GAMSParameter GAMSParameter;
			GAMSParameter = db.addParameter(key, 0);
			System.out.println("GAMS " + GAMSParameter.getName());
			GAMSParameter.addRecord().setValue(value);

		}
	}

	/* Uses a regular hashtable to hold key value pairs */
	private void handleTablesDimension1(GAMSDatabase db) {
		int counter = 0;
		Map<String, Double> toGams = new HashMap<String, Double>();

		for (Iterator<?> iterator = modelInputsMap_tableDimension1.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			Object value = modelInputsMap_tableDimension1.get(key);
			String tableKey = "";
			Double tableKeyVal = null;
			GAMSParameter GAMSParameter;
			GAMSParameter = db.addParameter(key, 1);
			System.out.println("GAMS " + GAMSParameter.getName());
			n++;
			// System.out.println(n + ". " + key + " -> " + value);

			JSONArray arr = (JSONArray) value;

			for (int i = 0; i < arr.size(); i++) {
				JSONObject objects = (JSONObject) arr.get(i);
				// System.out.println("CURRENTLY AT " + objects + " - object
				// size is " + objects.size());

				for (Iterator<?> keys = objects.keySet().iterator(); keys.hasNext();) {

					String tablekey = (String) keys.next();

					if (tablekey.equals("value")) {
						tableKeyVal = Double.valueOf(objects.get(tablekey).toString());
						// System.out.println(counter + ". " + tablekey + " - -
						// - - -" + tableKeyVal);
					} 
					else if(tablekey.equals("t")) {
						tableKey = objects.get(tablekey).toString();
						System.out.println(counter + ". " + tablekey + " - - - - -" + tableKey);
					}
					
					else {
						tableKey = (String) objects.get(tablekey);
						// System.out.println(counter + ". " + tablekey + " - -
						// - - -" + tableKey);
					}
				}
				// System.out.println(tableKey + " " + tableKeyVal);
				counter++;
				GAMSParameter.addRecord(tableKey).setValue(tableKeyVal);

			}

		}

	}

	private void handleEVERYTHING(GAMSDatabase db) {
		System.out.println(" - - - - - - - T A B L E - D I M E N S I O N - X - - - - - - - - -");
		List<String> myList = new ArrayList<String>();
		Map<Vector<String>, Double> toGams = new HashMap<Vector<String>, Double>();

		for (Iterator<?> iterator = modelInputsMapAll.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			Object value = modelInputsMapAll.get(key);
			GAMSParameter genericParam = null;
			n++;
			System.out
					.println("-------------------------------------------------- \n" + n + ". " + key + " -> " + value);

			JSONArray arr = (JSONArray) value;

			for (int i = 0; i < arr.size(); i++) {
				Double tableKeyValDouble = null;
				int a = 0;
				JSONObject objects = (JSONObject) arr.get(i);

				/**
				 * Do it only once to add GAMS Parameter with proper dimension
				 * calculated by (objects.size - 1)
				 */
				if (i == 0) {
					genericParam = db.addParameter(key, objects.size() - 1);
					//System.out.println("\nGAMS " + genericParam.getName());
				}

				for (Iterator<?> keys = objects.keySet().iterator(); keys.hasNext();) {
					a++;
					String tablekey = (String) keys.next();
					// System.out.println(tablekey);
					if (tablekey.equals("value")) {
						tableKeyValDouble = Double.valueOf(objects.get(tablekey).toString());
						// System.out.println(tablekey + " = > " +
						// tableKeyValDouble);
					} else {
						String tableKeyVal = (String) objects.get(tablekey).toString();
						// System.out.println(tablekey + " = > " + tableKeyVal);
						if (a != objects.size()) {
							myList.add(tableKeyVal);
						}
					}
				}

				toGams.put(new Vector<String>(myList), tableKeyValDouble);
					for (Vector<String> vd : toGams.keySet()) {
						genericParam.addRecord(vd).setValue(toGams.get(vd).doubleValue());
						//System.out.println(vd + "->" + toGams.get(vd).doubleValue());
					}
					myList.clear();
					toGams.clear();
				
			}
		}
	}

	/* Getters and Setters */
	public UserScenarioModel getUserScenario() {
		return userScenario;
	}

	public void setUserScenario(UserScenarioModel userScenario) {
		this.userScenario = userScenario;
	}

}
