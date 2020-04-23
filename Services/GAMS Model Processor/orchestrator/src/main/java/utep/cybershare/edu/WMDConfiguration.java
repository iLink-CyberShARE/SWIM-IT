package utep.cybershare.edu;

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

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonProperty;

import io.dropwizard.Configuration;

public class WMDConfiguration extends Configuration {
	
	/* Mongo Settings */

	@NotEmpty
	private String mongoUser;
	
	@NotEmpty
	private String mongoPassword;
	
	@NotEmpty
	private String mongoHost;
	
	@NotEmpty
	private String mongoDB;
	
	@Min(1)
	@Max(65535)
	private int mongoPort;
	
	/* GAMS Settings */
	
	@NotEmpty
	private String gamsPath;
	
	@NotEmpty
	private String gamsWorkspace;
	
	@NotEmpty
	private String bucketFile;
	
    /* Getters and Setters */
	
	@JsonProperty
	public String getMongoUser() {
		return mongoUser;
	}

	@JsonProperty
	public void setMongoUser(String mongoUser) {
		this.mongoUser = mongoUser;
	}

	@JsonProperty
	public String getMongoPassword() {
		return mongoPassword;
	}

	@JsonProperty
	public void setMongoPassword(String mongoPassword) {
		this.mongoPassword = mongoPassword;
	}

	@JsonProperty
	public String getMongoHost() {
		return mongoHost;
	}

	@JsonProperty
	public void setMongoHost(String mongoHost) {
		this.mongoHost = mongoHost;
	}

	@JsonProperty
	public String getMongoDB() {
		return mongoDB;
	}

	@JsonProperty
	public void setMongoDB(String mongoDB) {
		this.mongoDB = mongoDB;
	}

	@JsonProperty
	public int getMongoPort() {
		return mongoPort;
	}

	@JsonProperty
	public void setMongoPort(int mongoPort) {
		this.mongoPort = mongoPort;
	}

	@JsonProperty
	public String getGamsPath() {
		return gamsPath;
	}

	@JsonProperty
	public void setGamsPath(String gamsPath) {
		this.gamsPath = gamsPath;
	}

	@JsonProperty
	public String getGamsWorkspace() {
		return gamsWorkspace;
	}

	@JsonProperty
	public void setGamsWorkspace(String gamsWorkspace) {
		this.gamsWorkspace = gamsWorkspace;
	}

	@JsonProperty
	public String getBucketFile() {
		return bucketFile;
	}

	@JsonProperty
	public void setBucketFile(String bucketFile) {
		this.bucketFile = bucketFile;
	}
	
	

}
