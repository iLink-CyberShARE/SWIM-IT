package ilink.utep.edu.runner;

import ilink.utep.edu.model.UserScenarioModel;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.scilab.modules.javasci.JavasciException;

import org.scilab.modules.javasci.Scilab;
import org.scilab.modules.types.ScilabDouble;
import org.scilab.modules.types.ScilabType;

/**
* The Scilab runner manages workflows with scilab defined models.
* + Prepares the input data for loading.
* + Loads input data into scilab application.
* + Calls the execution method of the scilab model.
* + Retrieves desired outputs from the model.
*
* @author  Luis Garnica
* @version 0.1
* @since   2019-07-22
*/
public class ScilabV1_Dev {
    
    private Scilab sci;
    private String model_path;
    private File model;
    
    //Model Input HashMaps
    private Map<Object, Object> scalarInputMap;
    private Map<Object, Object> matrix1DInputMap;
        
    private UserScenarioModel userScenario = null;
    
    /**
    * Scilab Runner constructor.
    * @param userScenario.
    * @return Nothing.
    */
    public ScilabV1_Dev(UserScenarioModel userScenario, String model_path) {
        try {
            
            this.userScenario = userScenario;
            this.model_path = model_path;
            
            //load model file in memory
            model = new File(model_path);
            model.setWritable(false);
            model.setExecutable(true);
            
            //start Scilab instance
            sci = new Scilab();
            
            if(sci.open()){
                this.PrepInputs();
                this.LoadInputs();
                this.ExecuteModel();
                this.GetOutputs();
                this.CloseRunner();
            }
            else{
                throw new java.lang.Error("Could not open the scilab");
            }
        }
        catch(Exception e) {
            System.err.println(e.getMessage());
        }
    }
    
    /* Getters and Setters */
    
    /**
    * Gets the loaded user scenario data model.
    * @return UserScenarioModel.
    */
    public UserScenarioModel getUserScenario(){
        return userScenario;
    }
    
    /* Methods */
    
    /**
    * Prepares model inputs according to data and structure types.
    * @return Nothing.
    */
    private void PrepInputs(){
        try{
            
            System.out.println("Preping Input Parameters...");

            //read model inputs from user scenario data model
            List<Map<String, Object>> modelInputs = userScenario.getModelInputs();

            //declarations for parsed maps
            scalarInputMap = new HashMap<Object, Object>();
            matrix1DInputMap = new HashMap<Object, Object>();
            

            //loop through all the model inputs
            for (int i = 0; i < modelInputs.size(); i++) {
                Map<String, Object> modelInputsMap = modelInputs.get(i);

                for(Map.Entry<String, Object> entry : modelInputsMap.entrySet()) {
                    String key = entry.getKey();
                    Object value = entry.getValue();

                    //only scenario and user defined parameters will be loaded
                    if (value.equals("scenario") || value.equals("user")) {
                        Object structType = modelInputsMap.get("structType");
                        //Object structDimension = modelInputsMap.get("structDimension");
                        
                        if (structType.equals("scalar")) {
                            Object paramName = modelInputsMap.get("paramName");
                            Object paramValue = modelInputsMap.get("paramValue");
                            scalarInputMap.put(paramName, paramValue);
                        }
                        if(structType.equals("matrix")){
                            Object paramName = modelInputsMap.get("paramName");
                            Object paramValue = modelInputsMap.get("paramValue");
                            matrix1DInputMap.put(paramName, paramValue);
                        }
                    } 
                }
            }   
        
        }
        catch(Exception ex){
            Logger.getLogger(ScilabV1_Dev.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
    * Calls Methods to load input data into Scilab.
    * @return Nothing.
    */
    private void LoadInputs() {
        try {
            System.out.println("Loading input parameters into Scilab...");
            
            //load scalar inputs of type double
            this.LoadScalars();
            
            //load matrixes of 1 dimension (arrays)
            this.Load1DMatrix();
           
        }
        catch(Exception ex) {
            Logger.getLogger(ScilabV1_Dev.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
    * Calls a Scilab model script for execution.
    * @return execution status. True if OK and False if error.
    */
    private boolean ExecuteModel() {
        try {
            System.out.println("Executing Scilab Model...");
            boolean success = sci.exec(model);
            System.out.println("Model Run: " + success);
            
            if (success == false)
                System.out.println(sci.getLastErrorMessage());
            
            return success;
            
        }
        catch(Exception ex) {
            Logger.getLogger(ScilabV1_Dev.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    
    /**
    * Retrieves model outputs after it has been executed on Scilab
    * @return execution status. True if OK and False if error.
    */
    private void GetOutputs() {
        try {         
            System.out.println("Retrieving Model Outputs...");
            
            List<Map<String, Object>> modelOutputs = userScenario.getModelOutputs();
            String varName = "";
            
            for (int i = 0; i < modelOutputs.size(); i++) {
                Map<String, Object> modelMap = modelOutputs.get(i);
                
                varName = (String) modelMap.get("varName");

                JSONArray jsonResultArray = new JSONArray();
                double[][] javaResultArray = GetSciOutput(varName, "real");
                
                //just supports two dimension arrays
                for(int r = 0; r < javaResultArray.length; r++){
                    for(int c = 0; c < javaResultArray[r].length; c++){
                        JSONObject jsonObj = new JSONObject();
                        
                        if(javaResultArray[r].length > 1){
                            jsonObj.put("row", r);
                            jsonObj.put("column", c);
                        }
                        jsonObj.put("value", javaResultArray[r][c]);
                        jsonResultArray.add(jsonObj);
                        modelMap.put("varValue", jsonResultArray);
                    }
                }
                
                modelOutputs.set(i, modelMap);
            }
            
            //update the user scenario with retrieved values
            userScenario.setModelOutputs(modelOutputs);
            //System.out.println(userScenario.getModelOutputs().toString());
            

        }
        catch(Exception ex) {
            Logger.getLogger(ScilabV1_Dev.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
    * Closes the Scilab instance.
    * @return Nothing.
    */
    private void CloseRunner() {
        System.out.println("Closing Scilab instance...");
        sci.close();
    }
    
    /**
    * Retrieves a variable value available from the Scilab instance.
    * @return double[][]. multi-dimension array of type double.
    */
    private double[][] GetSciOutput(String varName, String type){
        try {
            ScilabType svariable = sci.get(varName);
            //System.out.println(varName + ": " + svariable);
            double [][] jvariable = ((ScilabDouble) svariable).getRealPart();
            return jvariable;
            
        } catch (JavasciException ex) {
            Logger.getLogger(ScilabV1_Dev.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
        
    /**
    * Loads input data of scalar structure and type double into Scilab instance.
    * @return Nothing.
    */
    private void LoadScalars(){
        try {
            for (Iterator<?> iterator = scalarInputMap.keySet().iterator(); iterator.hasNext();) {

                    String key = (String) iterator.next();
                    Double jValue = Double.valueOf(scalarInputMap.get(key).toString());
                    //System.out.println(key + " -> " + jValue);

                    ScilabDouble sValue = new ScilabDouble(jValue);
                    sci.put(key, sValue);

            }
        } catch (JavasciException ex) {
            Logger.getLogger(ScilabV1_Dev.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
    * Loads input data of matrix structure of one dimension (array of values).
    * @return Nothing.
    */
    private void Load1DMatrix(){
        try {
            for (Iterator<?> iterator = matrix1DInputMap.keySet().iterator(); iterator.hasNext();) {
                //name of the variable
                String key = (String) iterator.next();
                Object value = matrix1DInputMap.get(key);
                
                //load the json array with values here
                JSONArray jsonArr = (JSONArray) value;
                double [][]jValues = new double[jsonArr.size()][1];
                int m = 0;
                
                //jsonArray level
                for (int i = 0; i < jsonArr.size(); i++) { 
                    JSONObject objects = (JSONObject) jsonArr.get(i);
                    //JSON object level
                    for (Iterator<?> keys = objects.keySet().iterator(); keys.hasNext();) {
                        String tablekey = (String) keys.next();
                        if(tablekey.equals("value")){
                            jValues[m][0] = Double.valueOf(objects.get(tablekey).toString());
                        }
                    }
                    m++;
                }
               
                //System.out.println(key + " -> " + Arrays.deepToString(jValues));
                ScilabDouble sValues = new ScilabDouble(jValues);
                sci.put(key, sValues);
            
            }
        }
        catch(Exception ex){
            Logger.getLogger(ScilabV1_Dev.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
     
}
