package utep.cybershare.edu.validation;

import java.util.ArrayList;

/*-
 * #%L
 * Water Modeling Distributor
 * $Id:$
 * $HeadURL:$
 * %%
 * Copyright (C) 2016 - 2017 University of Texas at El Paso
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.swing.plaf.synth.SynthSeparatorUI;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import utep.cybershare.edu.model.UserScenarioModel;

public class Validator {
	
	private static UserScenarioModel userScenario = null;
	private static int n;
	private static String errorMessage;
	private List<String> parameters;
	
	public Validator(UserScenarioModel userScenario){
		this.userScenario = userScenario;
	}
	
	public Validator(){
		
	}
		
	public boolean validateInputs(String keyC, Double valC) {
		//System.out.println("\n- VALIDATE INPUTS -*\n ");
		
		/** Prepare input data */
		List<Map<String, Object>> modelInputs = userScenario.getModelInputs();
		//System.out.println("Validating : " + keyC + " -> " + valC);
		
		for (int i = 0; i < modelInputs.size(); i++) {

			Map<String, Object> modelInputsMap = modelInputs.get(i);
			n++;
			//System.out.println(n + " " + modelInputsMap);
			
			
			for (Map.Entry<String, Object> entry : modelInputsMap.entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				//System.out.println("__" + key + " " + value);
				
				if (value.equals(keyC)) {
					Double minValue = (Double)modelInputsMap.get("minValue");
					Double maxValue = (Double) modelInputsMap.get("maxValue");

					//System.out.println(keyC + " has a min and max value of [" + minValue + "," + maxValue + "]");
					
					if(valC >= minValue && valC <= maxValue){
						return true;
					}
					else 
						errorMessage = "Check '" +keyC + "'. Variable min and max values are of [" + minValue + "," + maxValue + "]";
				}				
			}
		}
		return false;	
	}

	public void validateInputs() {
		/** Prepare input data */
		List<Map<String, Object>> modelInputs = userScenario.getModelInputs();
		int m = 0;

		for (int i = 0; i < modelInputs.size(); i++) {

			Map<String, Object> modelInputsMap = modelInputs.get(i);
			m++;
//			System.out.println(m + " " + modelInputsMap);

			for (Map.Entry<String, Object> entry : modelInputsMap.entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				Double minValue = (Double) modelInputsMap.get("minValue");
				Double maxValue = (Double) modelInputsMap.get("maxValue");
				String paramName = (String) modelInputsMap.get("paramName");
				String structType = (String) modelInputsMap.get("structType");
				Double paramValue;

				// System.out.println(key + " -> " + value);

				/** SCALAR */
				if (structType.equals("scalar")) {
					paramValue = Double.valueOf(modelInputsMap.get("paramValue").toString());
					validateValueInRangeS(paramName, paramValue, minValue, maxValue);
				}

				/** TABLE */
				if (structType.equals("table")) {
					// System.out.println("TABLE");
					Object objParamValue = modelInputsMap.get("paramValue");
					// System.out.println(objParamValue);
					JSONArray jArray = (JSONArray) objParamValue;
					//
					for (int k = 0; k < jArray.size(); k++) {
						 JSONObject objects = (JSONObject) jArray.get(k);
						 // System.out.println("CURRENTLY AT " + objects);
						 paramValue = Double.valueOf(objects.get("value").toString());
						 validateValueInRangeS(paramName, paramValue, minValue, maxValue);
					}
				}

			}

		}

		System.out.println("\n\nWrong parameters " + getParameters());

	}
	
	public void validateValueInRangeS(String paramName, Double paramValue, Double minValue, Double maxValue) {
		List<String> myList = new ArrayList<String>();

		if (paramValue >= minValue && paramValue <= maxValue) {
			// System.out.println("Valid in range");
		} else {
			// System.out.println(paramValue + " is not in valid range");
			myList.add(paramName);
			setParameters(myList);
		}

	}

	public List<String> getParameters() {
		return parameters;
	}
	
	public void setParameters(List<String> input) {
		this.parameters = input;
	}
	
	
	public String getErrorMessage(){
		return errorMessage;
	}
}
