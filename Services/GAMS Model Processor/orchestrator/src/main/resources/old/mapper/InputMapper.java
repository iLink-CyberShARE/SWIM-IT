package utep.cybershare.edu.mapper;

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

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import utep.cybershare.edu.db.MongoHandler;
import utep.cybershare.edu.model.UserScenarioModel;

public class InputMapper {

	private String inputJSON = "";
	private MongoHandler mh;
	
	public InputMapper(String inputJSON, MongoHandler mh) {
		super();
		this.inputJSON = inputJSON;
		this.mh = mh;
	};
	
	public UserScenarioModel mapToModel(UserScenarioModel userModel){
		JSONParser jsonParser = new JSONParser();
		try {
			JSONObject jsonObject = (JSONObject) jsonParser.parse(this.inputJSON);
		
			Map<String, Object> ind = new HashMap<String, Object>();
			
			//Mapping of root JSON fields
			for (Object keyObject : jsonObject.keySet()){
				String key = (String)keyObject;
				
				if(key.equals("modelSettings") || key.equals("modelInputs")){
					continue;
				}
				
				String value = (String)jsonObject.get(key);
				ind.put(key, value);
			}
			
			for (Iterator<?> iterator = ind.keySet().iterator(); iterator.hasNext();) {
				String key = (String) iterator.next();
				String value = (String) ind.get(key);
				if (key.equals("id"))
					userModel.setId(value);
				if (key.equals("name"))
					userModel.setName(value);
				if (key.equals("isPublic"))
					userModel.setPublic(value);
				if (key.equals("description"))
					userModel.setDescription(value);
				if (key.equals("baseClimateScenario"))
					userModel.setBaseClimateScenario(value);
				if (key.equals("userid"))
					userModel.setUserid(value);
				if (key.equals("status"))
					userModel.setStatus(value);
				if (key.equals("baseScenario"))
					userModel.setBaseScenario(value);
				
			}
			
			//Mapping of model inputs
			JSONObject modelObj = ((JSONObject) jsonObject.get("modelInputs"));
			System.out.println("\nMODEL INPUTS\n");
			
			for (Iterator<?> iterator = modelObj.keySet().iterator(); iterator.hasNext();) {
				Map<String, Object> temp = new HashMap<String, Object>();
				String key = (String) iterator.next();
				System.out.println("Currently looping thru :" + key);
				JSONObject modelObjWithin = ((JSONObject) modelObj.get(key));

				for (Iterator<?> innerIterator = modelObjWithin.keySet().iterator(); innerIterator.hasNext();) {
					String innerKey = (String) innerIterator.next();
					String value = "";
					String structType = (String) modelObjWithin.get("structType");
					if (innerKey.equals("paramDefaultValue") || innerKey.equals("paramValue")) {
						
						//scalar case
						if (structType.equals("scalar")) {
							String paramDefaultValue = (String) modelObjWithin.get("paramDefaultValue");
							String paramValue = (String) modelObjWithin.get("paramValue");
							String definitionType = (String) modelObjWithin.get("definitionType");
							System.out.println("Param Default Value is " + paramDefaultValue + "\n" + "Param value " + paramValue);
							temp.put("paramDefaultValue", paramDefaultValue);
							temp.put("paramValue", paramValue);
							temp.put("definitionType", definitionType);
						}
						
						
                        //scalar case
						if (structType.equals("table")) {
							JSONArray tableParamDefaultValue = (JSONArray) modelObjWithin.get("paramDefaultValue");
							JSONArray tableParamValue = (JSONArray) modelObjWithin.get("paramValue");
							//System.out.println("tableParamDefaultValue " + tableParamDefaultValue);
							//System.out.println("tableParamValue " + tableParamValue);
							
							temp.put("paramDefaultValue", tableParamDefaultValue);
							temp.put("paramValue", tableParamValue);
						
						}
						


						break;
					}

					value = (String) modelObjWithin.get(innerKey);
					temp.put(innerKey, value);
					System.out.println("Inner key " + innerKey + " " + value);
				}

				userModel.addModelInput(temp);

				System.out.println(" - - - - - - - - - - - - - - -");
			}
			
			//Model Settings
			System.out.println("MODEL SETTINGS \n");
			JSONArray jsonTest = (JSONArray) jsonObject.get("modelSettings");
			Iterator<?> i = jsonTest.iterator();
			HashMap<String, Object> modelSettings = new HashMap<String, Object>();

			JSONObject obj = (JSONObject) i.next();

			for (Iterator<?> iterator = obj.keySet().iterator(); iterator.hasNext();) {
				String key = (String) iterator.next();
				String value = (String) obj.get(key);
				modelSettings.put(key, value);
				System.out.println(key + ": " + value);
			}

			//Add to the model
			userModel.addSetting(modelSettings);

		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return userModel;
	}
	
	public void saveToMongo(UserScenarioModel userModel){
		mh.getDs().save(userModel);
	}
	
	
}
