package gr.ntua.ivml.mint.report;


import java.util.Date;
import java.util.List;

public class DataUploadDetailsBean {
	private String name;
	private Date created;
	private Date lastModified;
	private String creatorId;
	private String creatorName;
	private Integer itemCount;
	private Integer validItems;
	private Integer invalidItems;
	private String itemizerStatus;
	private String organizationId;
	private String organizationName;
	private List<TransformationDetailsBean> derivedTransformations;
	
	public Integer getValidItems() {
		return validItems;
	}
	public void setValidItems(Integer validItems) {
		this.validItems = validItems;
	}
	public Integer getInvalidItems() {
		return invalidItems;
	}
	public void setInvalidItems(Integer invalidItems) {
		this.invalidItems = invalidItems;
	}
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
	
	public String getCreatorName() {
		return creatorName;
	}
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}
	public String getCreatorId() {
		return creatorId;
	}
	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}
	public List<TransformationDetailsBean> getDerivedTransformations() {
		return derivedTransformations;
	}
	public void setDerivedTransformations(
			List<TransformationDetailsBean> derivedTransformations) {
		this.derivedTransformations = derivedTransformations;
	}
	public DataUploadDetailsBean(String name, Date created, Date lastModified,
			String creatorId, String creatorName, Integer itemCount,
			Integer validItems, Integer invalidItems, String itemizerStatus,
			String organizationId, String organizationName,
			List<TransformationDetailsBean> derivedTransformations) {
		super();
		this.name = name;
		this.created = created;
		this.lastModified = lastModified;
		this.creatorId = creatorId;
		this.creatorName = creatorName;
		this.itemCount = itemCount;
		this.validItems = validItems;
		this.invalidItems = invalidItems;
		this.itemizerStatus = itemizerStatus;
		this.organizationId = organizationId;
		this.organizationName = organizationName;
		this.derivedTransformations = derivedTransformations;
	}
	
	
	
	
	

}
