package gr.ntua.ivml.mint.report;

import gr.ntua.ivml.mint.actions.UrlApi;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class OrganizationDetailsBeanFactory {

	String organizationId;
	Date startDate;
	Date endDate;

	PublicationDetailsBeanFactory publicationDetailsBeanFactory;
	TransformationDetailsBeanFactory transformationDetailsBeanFactory;
	MappingDetailsBeanFactory mappingDetailsBeanFactory;
	OaiPublicationDetailsBeanFactory oaipublicationbeanFactory;
	DataUploadDetailsBeanFactory datauploadDetailsFactory;
	OrgOAIBeanFactory orgoaibeanfactory;

	public OrganizationDetailsBeanFactory(String id, Date startdate,
			Date enddate) {
		super();

		this.organizationId = id;
		this.startDate = startdate;
		this.endDate = enddate;

		this.publicationDetailsBeanFactory = new PublicationDetailsBeanFactory(
				id, startDate, endDate);
		this.transformationDetailsBeanFactory = new TransformationDetailsBeanFactory(
				id, startDate, endDate);
		this.mappingDetailsBeanFactory = new MappingDetailsBeanFactory(id,
				startDate, endDate);
		this.oaipublicationbeanFactory = new OaiPublicationDetailsBeanFactory(
				id, startDate, endDate);
		this.datauploadDetailsFactory = new DataUploadDetailsBeanFactory(
				organizationId, startDate, endDate);
		this.orgoaibeanfactory = new OrgOAIBeanFactory();
	}

	public String getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationid(String organizationId) {
		this.organizationId = organizationId;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public List<OrganizationDetailsBean> getOrgDetailsBeans() {

		UrlApi api = new UrlApi();
		api.setOrganizationId(organizationId);
		JSONObject json = api.listOrganizations();
		JSONArray result = (JSONArray) json.get("result");
		JSONObject jsonObject = result.getJSONObject(0);
		return this.getOrgDetailsBeans(jsonObject);

	}

	public List<OrganizationDetailsBean> getOrgDetailsBeans(
			JSONObject jsonObject) {

		List<OrganizationDetailsBean> organizations = new ArrayList<OrganizationDetailsBean>();

		String name = jsonObject.get("englishName").toString();
		String country = jsonObject.get("country").toString();
		String publishAllowed = jsonObject.get("publishAllowed").toString();

		List<DataUploadDetailsBean> uploadsbeanCollection = null;
		List<PublicationDetailsBean> publicationsbeanCollection = null;
		List<TransformationDetailsBean> transformationsbeanCollection = null;
		List<MappingDetailsBean> mappingsbeanCollection = null;
		List<OaiPublicationDetailsBean> oaipublicationbeanCollection = null;
		List<OrgOAIBean> orgoaibeanCollection = null;
		
		System.out.println("DEBUG,lists starting" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		uploadsbeanCollection = datauploadDetailsFactory.getUploads(organizationId);
		System.out.println("DEBUG,uploadslist done" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		transformationsbeanCollection = transformationDetailsBeanFactory
				.getTransformations(organizationId);
		System.out.println("DEBUG,transformations done" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		publicationsbeanCollection = publicationDetailsBeanFactory
				.getPublications(organizationId);
		System.out.println("DEBUG,publications done" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		mappingsbeanCollection = mappingDetailsBeanFactory.getMappings();
		System.out.println("DEBUG,mappings done" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		oaipublicationbeanCollection = oaipublicationbeanFactory
				.getOaiPublicationDetailsBeans();
		System.out.println("DEBUG,oai commits done" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
	//	orgoaibeanCollection = orgoaibeanfactory.getOrgOAIBeans();
		orgoaibeanCollection = orgoaibeanfactory.getOrgOAIBeans2(organizationId);
		System.out.println("DEBUG,oai status done" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));

		OrganizationDetailsBean organizationdetailsbean = new OrganizationDetailsBean(
				name, country, uploadsbeanCollection, mappingsbeanCollection,
				transformationsbeanCollection, publicationsbeanCollection,
				oaipublicationbeanCollection, orgoaibeanCollection);
		organizations.add(organizationdetailsbean);
		return organizations;
	}

}
