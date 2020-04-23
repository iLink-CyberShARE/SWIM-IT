package utep.cybershare.edu.model;

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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mongodb.morphia.annotations.Entity;
import org.mongodb.morphia.annotations.Id;

@Entity("public-scenarios")
public class UserScenarioModel {

	@Id String id;
	
	private String name;
	private String description;
	private String userid;
	private String startedAtTime = null;
	private String endedAtTime = null;
	private String status;
	private String isPublic;
	private List<Map<String, Object>> modelSettings;
	private List<Map<String, Object>> modelSets;
	private List<Map<String, Object>> modelInputs;
	private List<Map<String, Object>> modelOutputs;
	
	public UserScenarioModel(){
		modelSettings = new ArrayList<Map<String,Object>>();
		modelInputs = new ArrayList<Map<String,Object>>();
		modelOutputs = new ArrayList<Map<String,Object>>();
		modelSets = new ArrayList<Map<String,Object>>();
	}

	public void addSetting(Map<String, Object> setting){
		modelSettings.add(setting);
	}
	
	 public void addModelSet(Map<String, Object> set){
	 	modelSets.add(set);
	 }

	public void addModelInput(Map<String, Object> input){
		modelInputs.add(input);
	}
	
	public void addModelOutput(Map<String, Object> output){
		modelOutputs.add(output);
	}
	
	
	/* Getters and Setters */
	
	public List<Map<String, Object>> getModelSettings() {
		return modelSettings;
	}
	

	public void setModelSettings(List<Map<String, Object>> modelSettings) {
		this.modelSettings = modelSettings;
	}
	
	 public List<Map<String, Object>> getModelSets() {
		return modelSets;
	 }
	
	 public void setModelSets(List<Map<String, Object>> modelSets) {
		 this.modelSets = modelSets;
	 }

	public List<Map<String, Object>> getModelInputs() {
		return modelInputs;
	}

	public void setModelInputs(List<Map<String, Object>> modelInputs) {
		this.modelInputs = modelInputs;
	}

	public List<Map<String, Object>> getModelOutputs() {
		return modelOutputs;
	}

	public void setModelOutputs(List<Map<String, Object>> modelOutputs) {
		this.modelOutputs = modelOutputs;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}


	public String getStartedAtTime() {
		return startedAtTime;
	}

	public void setStartedAtTime(String startedAtTime) {
		this.startedAtTime = startedAtTime;
	}

	public String getEndedAtTime() {
		return endedAtTime;
	}

	public void setEndedAtTime(String endedAtTime) {
		this.endedAtTime = endedAtTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String isPublic() {
		return isPublic;
	}

	public void setPublic(String isPublic) {
		this.isPublic = isPublic;
	}
	

}
