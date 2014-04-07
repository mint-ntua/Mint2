package gr.ntua.ivml.mint.report;


import java.util.List;

public class OrganizationDetailsBean {
	
	private String name;
	private String country;
	
	private List<DataUploadDetailsBean> uploads;
	private List<MappingDetailsBean> mappings;
	private List<TransformationDetailsBean> transformations;
	private List<PublicationDetailsBean> publications;
	private List<OaiPublicationDetailsBean> oaipublications;
	private List<OrgOAIBean> oaistatus;
	
	
	public OrganizationDetailsBean(String name, String country,
			List<DataUploadDetailsBean> uploads,
			List<MappingDetailsBean> mappings,
			List<TransformationDetailsBean> transformations,
			List<PublicationDetailsBean> publications, List<OaiPublicationDetailsBean> oaipublications, List<OrgOAIBean> oaistatus) {
		super();
		this.name = name;
		this.country = country;
		this.uploads = uploads;
		this.mappings = mappings;
		this.transformations = transformations;
		this.publications = publications;
		this.oaipublications = oaipublications;
		this.oaistatus = oaistatus;
	}
	
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
	public List<DataUploadDetailsBean> getUploads() {
		return uploads;
	}
	public void setUploads(List<DataUploadDetailsBean> uploads) {
		this.uploads = uploads;
	}
	public List<MappingDetailsBean> getMappings() {
		return mappings;
	}
	public void setMappings(List<MappingDetailsBean> mappings) {
		this.mappings = mappings;
	}
	public List<TransformationDetailsBean> getTransformations() {
		return transformations;
	}
	public void setTransformations(List<TransformationDetailsBean> transformations) {
		this.transformations = transformations;
	}
	public List<PublicationDetailsBean> getPublications() {
		return publications;
	}
	public void setPublications(List<PublicationDetailsBean> publications) {
		this.publications = publications;
	}

	public List<OaiPublicationDetailsBean> getOaipublications() {
		return oaipublications;
	}

	public void setOaipublications(List<OaiPublicationDetailsBean> oaipublications) {
		this.oaipublications = oaipublications;
	}

	public List<OrgOAIBean> getOaistatus() {
		return oaistatus;
	}

	public void setOaistatus(List<OrgOAIBean> oaistatus) {
		this.oaistatus = oaistatus;
	}
	
	


}
