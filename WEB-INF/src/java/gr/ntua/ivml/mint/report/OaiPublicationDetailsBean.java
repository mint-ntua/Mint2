package gr.ntua.ivml.mint.report;

import java.util.Date;

public class OaiPublicationDetailsBean {
	String projectName;
	String organizationName;
	Integer organizationId;
	Long datestamp;
	Date created;
	Integer insertedRecords;
	Integer conflictedRecords;

	public String getOrganizationName() {
		return organizationName;
	}
	public void setOrganizationName(String organizationName) {
		this.organizationName = organizationName;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public String getProjectName() {
		return projectName;
	}
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	public Integer getOrganizationId() {
		return organizationId;
	}
	public void setOrganizationId(Integer organizationId) {
		this.organizationId = organizationId;
	}
	public Long getDatestamp() {
		return datestamp;
	}
	public void setDatestamp(Long datestamp) {
		this.datestamp = datestamp;
	}
	public Integer getInsertedRecords() {
		return insertedRecords;
	}
	public void setInsertedRecords(Integer insertedRecords) {
		this.insertedRecords = insertedRecords;
	}
	public Integer getConflictedRecords() {
		return conflictedRecords;
	}
	public void setConflictedRecords(Integer conflictedRecords) {
		this.conflictedRecords = conflictedRecords;
	}
	public OaiPublicationDetailsBean(String projectName,
			String organizationName, Integer organizationId, Long datestamp,
			Date created, Integer insertedRecords, Integer conflictedRecords) {
		super();
		this.projectName = projectName;
		this.organizationName = organizationName;
		this.organizationId = organizationId;
		this.datestamp = datestamp;
		this.created = created;
		this.insertedRecords = insertedRecords;
		this.conflictedRecords = conflictedRecords;
	}
	
	

	
	
	
	

}
