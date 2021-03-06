package utep.cybershare.edu.mapper;

/*-
 * #%L
 * Water Modeling Distributor
 * $Id:$
 * $HeadURL:$
 * %%
 * Copyright (C) 2016 - 2019 University of Texas at El Paso
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

public class InputMapperV4 {

	private String inputJSON = "";
	private MongoHandler mh;

	public InputMapperV4(String inputJSON, MongoHandler mh) {
		super();
		this.inputJSON = inputJSON;
		this.mh = mh;
	}

	;

	public UserScenarioModel mapToModel(UserScenarioModel userModel) {

		System.out.println("Starting JSON to Morphia Mapper...");

		JSONParser jsonParser = new JSONParser();
		try {
			JSONObject jsonObject = (JSONObject) jsonParser.parse(this.inputJSON);

			Map<String, Object> ind = new HashMap<String, Object>();

			System.out.println("Mapping Root Fields...");
			for (Object keyObject : jsonObject.keySet()) {
				String key = (String) keyObject;
				// System.out.println(key);
				if (key.equals("modelSettings") || key.equals("modelInputs") || key.equals("modelOutputs")
						|| key.equals("modelSets")) {
					continue;
				}

				// System.out.println(jsonObject.get(key));
				String value = (String) jsonObject.get(key);
				ind.put(key, value);
				// System.out.println(ind);
			}

			for (Iterator<?> iterator = ind.keySet().iterator(); iterator.hasNext();) {
				String key = (String) iterator.next();
				String value = (String) ind.get(key);
				if (key.equals("id")) {
					userModel.setId(value);
				}
				if (key.equals("name")) {
					userModel.setName(value);
				}
				if (key.equals("isPublic")) {
					userModel.setPublic(value);
				}
				if (key.equals("description")) {
					userModel.setDescription(value);
				}
				if (key.equals("userid")) {
					userModel.setUserid(value);
				}
				if (key.equals("status")) {
					userModel.setStatus(value);
				}

			}

			// Mapping of model inputs
			System.out.println("Mapping Inputs Block...");
			// System.out.println("Uncommented inputs to save console space c:");
			JSONArray modelInputsJArray = (JSONArray) jsonObject.get("modelInputs");
			Iterator<?> j = modelInputsJArray.iterator();

			for (int k = 0; k < modelInputsJArray.size(); k++) {
				Map<String, Object> temp = new HashMap<String, Object>();
				JSONObject current = (JSONObject) modelInputsJArray.get(k);
				current = (JSONObject) j.next();
				// System.out.println(current.toJSONString());
				// System.out.println("\n" + k);

				for (Iterator<?> iterator = current.keySet().iterator(); iterator.hasNext();) {
					String key = (String) iterator.next();
					String value = "";
					String structType = (String) current.get("structType");
					// System.out.println(key);

					if (key.equals("paramDefaultValue") || key.equals("paramValue")) {

						// scalar case
						if (structType.equals("scalar")) {
							Double parameterVal = Double.valueOf(current.get(key).toString());
							temp.put(key, parameterVal);
						}

						// Table case
						else if (structType.equals("table") || structType.equals("matrix")) {
							JSONArray parameterVal = (JSONArray) current.get(key);
							temp.put(key, parameterVal);
						}
						// break;
					} else if (key.equals("minValue") || key.equals("maxValue") || key.equals("stepSize")) {
						Double valueDouble = Double.valueOf(current.get(key).toString());
						temp.put(key, valueDouble);
					} else if (key.equals("paraminfo")) {
						JSONArray paraminfo = (JSONArray) current.get("paraminfo");
						temp.put("paraminfo", paraminfo);
					} else if (key.equals("paramBenchMarks")) {
						JSONArray parambenchmarks = (JSONArray) current.get("paramBenchMarks");
						temp.put("paramBenchMarks", parambenchmarks);
					} else {
						value = (String) current.get(key);
						temp.put(key, value);
					}
				}
				userModel.addModelInput(temp);
			}

			// Model Settings
			System.out.println("Mapping Settings Block...");
			JSONArray jsonTest = (JSONArray) jsonObject.get("modelSettings");
			Iterator<?> i = jsonTest.iterator();
			HashMap<String, Object> modelSettings = new HashMap<String, Object>();

			JSONObject obj = (JSONObject) i.next();

			for (Iterator<?> iterator = obj.keySet().iterator(); iterator.hasNext();) {
				String key = (String) iterator.next();
				String value = (String) obj.get(key);
				modelSettings.put(key, value);
				// System.out.println(key + ": " + value);
			}
			// Add to the model
			userModel.addSetting(modelSettings);

			// Model Sets
			System.out.println("Mapping Sets Block...");
			// System.out.println("Uncommented inputs to save console space
			// c:\n");
			JSONArray modelSetsJArray = (JSONArray) jsonObject.get("modelSets");
			j = modelSetsJArray.iterator();

			for (int k = 0; k < modelSetsJArray.size(); k++) {
				HashMap<String, Object> modelSets = new HashMap<String, Object>();
				JSONObject current = (JSONObject) modelSetsJArray.get(k);
				current = (JSONObject) j.next();
				// System.out.println("\n" + k);
				for (Iterator<?> iterator = current.keySet().iterator(); iterator.hasNext();) {
					String key = (String) iterator.next();
					String value = (String) current.get(key);
					modelSets.put(key, value);
					// System.out.println(key + ": " + value);
				}
				// System.out.println(modelSets);
				// userModel.addModelOutput(modelOutputs);
				userModel.addModelSet(modelSets);
			}

			// Model Outputs
			System.out.println("Mapping Model Outputs Block...");
			// System.out.println("Uncommented outputs to save console space c:\n");
			JSONArray modelOutputsJArray = (JSONArray) jsonObject.get("modelOutputs");
			j = modelOutputsJArray.iterator();

			for (int k = 0; k < modelOutputsJArray.size(); k++) {
				HashMap<String, Object> modelOutputs = new HashMap<String, Object>();
				JSONObject current = (JSONObject) modelOutputsJArray.get(k);
				current = (JSONObject) j.next();
				// System.out.println("\n" + k);
				for (Iterator<?> iterator = current.keySet().iterator(); iterator.hasNext();) {
					String key = (String) iterator.next();

					if (key.equals("varinfo")) {
						JSONArray value = (JSONArray) current.get("varinfo");
						modelOutputs.put(key, value);
					}

					else if (key.equals("varBenchMarks")) {
						JSONArray value = (JSONArray) current.get("varBenchMarks");
						modelOutputs.put(key, value);

					} // temporary patch, need to handle all this section better

					else if (key.equals("varValue")) {
						// nothing to do here
					}

					else {
						String value = (String) current.get(key);
						modelOutputs.put(key, value);
					}
				}
				userModel.addModelOutput(modelOutputs);
			}

		} catch (ParseException e) {
			e.printStackTrace();
		}
		System.out.println("Finished Mapping JSON Input!");
		return userModel;
	}

	public void saveToMongo(UserScenarioModel userModel) {
		mh.getDs().save(userModel);
	}

}
