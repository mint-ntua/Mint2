package gr.ntua.ivml.mint.report;

import java.util.Date;

public class OrganizationGoalsSummaryBean {
	private String name;
	private Date date;
	private Integer items;
	private String organizationId;
	private String organizationName;
	private String type;
	
	
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public Integer getItems() {
		return items;
	}
	public void setItems(Integer items) {
		this.items = items;
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
		public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public OrganizationGoalsSummaryBean(String name, Date date, Integer items,
			String organizationId, String organizationName, String type) {
		super();
		this.name = name;
		this.date = date;
		this.items = items;
		this.organizationId = organizationId;
		this.organizationName = organizationName;
		this.type = type;
	}
	
}

