package gr.ntua.ivml.mint.report;

import java.util.Date;

public class MappingDetailsBean {
	private String name;
	private Date Created;
	private Date lastModified;
	private String organizationId;
	private String organizationName;
	private String schemaName;
	private String schemaId;
	
	
	
	public MappingDetailsBean(String name, Date created, Date lastModified,
			String organizationId, String organizationName, String schemaName,
			String schemaId) {
		super();
		this.name = name;
		Created = created;
		this.lastModified = lastModified;
		this.organizationId = organizationId;
		this.organizationName = organizationName;
		this.schemaName = schemaName;
		this.schemaId = schemaId;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getCreated() {
		return Created;
	}
	public void setCreated(Date created) {
		Created = created;
	}
	public Date getLastModified() {
		return lastModified;
	}
	public void setLastModified(Date lastModified) {
		this.lastModified = lastModified;
	}
	public String getOrganizationId() {
		return organizationId;
	}
	public void setOrganizationId(String organizationId) {
		this.organizationId = organizationId;
	}
	public String getOrganizationName() {
		return organizationName;
	}
	public void setOrganizationName(String organizationName) {
		this.organizationName = organizationName;
	}
	public String getSchemaName() {
		return schemaName;
	}
	public void setSchemaName(String schemaName) {
		this.schemaName = schemaName;
	}
	public String getSchemaId() {
		return schemaId;
	}
	public void setSchemaId(String schemaId) {
		this.schemaId = schemaId;
	}
	

	
	
	
	
	

}
