package ilink.utep.edu.model;

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
