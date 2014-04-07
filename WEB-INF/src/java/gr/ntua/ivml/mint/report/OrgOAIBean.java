package gr.ntua.ivml.mint.report;

public class OrgOAIBean {
	
	String organizationName;
	String type;
	String  organizationId;
	Integer uniqueItems;
	
	public String getOrganizationName() {
		return organizationName;
	}
	public void setOrganizationName(String organizationName) {
		this.organizationName = organizationName;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getOrganizationId() {
		return organizationId;
	}
	public void setOrganizationId(String organizationId) {
		this.organizationId = organizationId;
	}
	public Integer getUniqueItems() {
		return uniqueItems;
	}
	public void setUniqueItems(Integer uniqueItems) {
		this.uniqueItems = uniqueItems;
	}
	
	public OrgOAIBean(String organizationName, String type,
			String organizationId, Integer uniqueItems) {
		super();
		this.organizationName = organizationName;
		this.type = type;
		this.organizationId = organizationId;
		this.uniqueItems = uniqueItems;
	}


}
