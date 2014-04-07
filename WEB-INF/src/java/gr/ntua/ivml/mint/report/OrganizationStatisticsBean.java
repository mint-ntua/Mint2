package gr.ntua.ivml.mint.report;


public class OrganizationStatisticsBean implements Comparable<OrganizationStatisticsBean>{
	private String name;
	private String country;
	
	private Integer uploadedItems;
	private Integer transformedItems;
	private Integer publishedItems;
	//private Integer numberofmappings ;
	//private Integer numberofuploads;
	//private Integer numberoftransformations;
	//private Integer numberofpublications;
	private  Integer oaiuniqueitems;
	
	
//	private java.util.List<java.util.Map.Entry<String,Integer>> pairList ;//= new java.util.ArrayList<>();
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public Integer getUploadedItems() {
		return uploadedItems;
	}
	public void setUploadedItems(Integer uploadedItems) {
		this.uploadedItems = uploadedItems;
	}
	public Integer getTransformedItems() {
		return transformedItems;
	}
	public void setTransformedItems(Integer transformedItems) {
		this.transformedItems = transformedItems;
	}
	public Integer getPublishedItems() {
		return publishedItems;
	}
	public void setPublishedItems(Integer publishedItems) {
		this.publishedItems = publishedItems;
	}
	/*public Integer getNumberofmappings() {
		return numberofmappings;
	}
	public void setNumberofmappings(Integer numberofmappings) {
		this.numberofmappings = numberofmappings;
	}*/
//	public Integer getNumberofuploads() {
//		return numberofuploads;
//	}
//	public void setNumberofuploads(Integer numberofuploads) {
//		this.numberofuploads = numberofuploads;
//	}
//	public Integer getNumberoftransformations() {
//		return numberoftransformations;
//	}
//	public void setNumberoftransformations(Integer numberoftransformations) {
//		this.numberoftransformations = numberoftransformations;
//	}
//	public Integer getNumberofpublications() {
//		return numberofpublications;
//	}
//	public void setNumberofpublications(Integer numberofpublications) {
//		this.numberofpublications = numberofpublications;
//	}
//	

	
	public Integer getOaiuniqueitems() {
		return oaiuniqueitems;
	}
	public void setOaiuniqueitems(Integer oaiuniqueitems) {
		this.oaiuniqueitems = oaiuniqueitems;
	}
	public OrganizationStatisticsBean(String name, String country,
			Integer uploadedItems, Integer transformedItems,
			Integer publishedItems,Integer oaiuniqueitems) {
		super();
		this.name = name;
		this.country = country;
		this.uploadedItems = uploadedItems;
		this.transformedItems = transformedItems;
		this.publishedItems = publishedItems;
	//	this.numberofmappings = numberofmappings;
//		this.numberofuploads = numberofuploads;
//		this.numberoftransformations = numberoftransformations;
//		this.numberofpublications = numberofpublications;
		this.oaiuniqueitems = oaiuniqueitems; 		
	}
	@Override
	public int compareTo(OrganizationStatisticsBean o) {
		if (this.publishedItems < o.publishedItems){
			return -1;
		}
		if (this.publishedItems > o.publishedItems){
			return 1;
		}
		else{
		return 0;
		}
	}
	
	
	
	
	
}
