package gr.ntua.ivml.mint.report;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.beanutils.BeanComparator;

import com.hp.hpl.jena.sparql.function.library.date;

public class TransformationDetailsBean implements Comparable<TransformationDetailsBean> {
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
	private String mappingUsed;
	private String targetSchema;
	private String parentDataset;
	
	
	
	
	
	public TransformationDetailsBean(String name, Date created,
			Date lastModified, String creatorId, String creatorName,
			Integer itemCount, Integer validItems, Integer invalidItems,
			String itemizerStatus, String organizationId,
			String organizationName, String mappingUsed, String targetSchema,
			String parentDataset) {
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
		this.mappingUsed = mappingUsed;
		this.targetSchema = targetSchema;
		this.parentDataset = parentDataset;
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
	public String getMappingUsed() {
		return mappingUsed;
	}
	public void setMappingUsed(String mappingUsed) {
		this.mappingUsed = mappingUsed;
	}
	public String getTargetSchema() {
		return targetSchema;
	}
	public void setTargetSchema(String targetSchema) {
		this.targetSchema = targetSchema;
	}
	public String getParentDataset() {
		return parentDataset;
	}
	public void setParentDataset(String parentDataset) {
		this.parentDataset = parentDataset;
	}
	@Override
	public int compareTo(TransformationDetailsBean o) {
		int result = 0 ;
		/*if (this.name.compareTo(o.getName() )>0){
			result=1;
		}
		else if (this.name.compareTo(o.getName())<0){
			result=-1;
		}
		else if (this.name.equals(o.getName())){*/
			if (this.parentDataset.compareTo(o.getParentDataset()) > 0){
				result=1 ;			
			}
			else if (this.parentDataset.compareTo(o.getParentDataset()) < 0){
				result=-1;
			}
			else if (this.parentDataset.equals(o.getParentDataset())){
				if (this.lastModified.after(o.lastModified)){
					result= 1;
				}
				else if (this.lastModified.before(o.lastModified)){
					result= -1;
				}
				else {
					result=0;
				}
			}
		//}
		
		
		return result;
	}
	
}




