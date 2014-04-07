package gr.ntua.ivml.mint.report;

import java.util.Date;

public class PublicationDetailsBean {
	private String name;
	private Date created;
	private Date lastModified;
	private String creatorId;
	private String creatorName;
	private Integer itemCount;
	private Integer publishedItems;
	private String itemizerStatus;
	private String organizationId;
	private String organizationName;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public Date getLastModified() {
		return lastModified;
	}
	public void setLastModified(Date lastModified) {
		this.lastModified = lastModified;
	}
	public String getCreatorId() {
		return creatorId;
	}
	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}
	public String getCreatorName() {
		return creatorName;
	}
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}
	public Integer getItemCount() {
		return itemCount;
	}
	public void setItemCount(Integer itemCount) {
		this.itemCount = itemCount;
	}
	public String getItemizerStatus() {
		return itemizerStatus;
	}
	public void setItemizerStatus(String itemizerStatus) {
		this.itemizerStatus = itemizerStatus;
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
	public PublicationDetailsBean(String name, Date created, Date lastModified,
			String creatorId, String creatorName, Integer itemCount,Integer publishedItems,
			String itemizerStatus, String organizationId,
			String organizationName) {
		super();
		this.name = name;
		this.created = created;
		this.lastModified = lastModified;
		this.creatorId = creatorId;
		this.creatorName = creatorName;
		this.itemCount = itemCount;
		this.publishedItems = publishedItems;
		this.itemizerStatus = itemizerStatus;
		this.organizationId = organizationId;
		this.organizationName = organizationName;
	}
	public Integer getPublishedItems() {
		return publishedItems;
	}
	public void setPublishedItems(Integer publishedItems) {
		this.publishedItems = publishedItems;
	}
	
	
	
	
	

}
