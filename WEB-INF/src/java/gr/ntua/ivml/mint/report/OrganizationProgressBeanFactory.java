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

public class OrganizationProgressBeanFactory {
	String organizationId;
	Date startDate;
	Date endDate;

	  PublicationDetailsBeanFactory publicationDetailsBeanFactory;
	  TransformationDetailsBeanFactory transformationDetailsBeanFactory;
	  OrgOAIBeanFactory orgoaibeanfactory;
	  OrganizationGoalsSummaryBeanFactory orggoalsFactory;

	public OrganizationProgressBeanFactory(String organizationId,Date startdate,
			Date enddate) {
		super();
		this.organizationId = organizationId;
		this.startDate = startdate;
		this.endDate = enddate;

		this.transformationDetailsBeanFactory = new TransformationDetailsBeanFactory(
			startDate, endDate);
		this.publicationDetailsBeanFactory = new PublicationDetailsBeanFactory(
			 startDate, endDate);
		this.orggoalsFactory = new OrganizationGoalsSummaryBeanFactory(
				startDate, endDate);
		this.orgoaibeanfactory = new OrgOAIBeanFactory();
	}
	
	
	public OrganizationProgressBeanFactory(Date startdate,
			Date enddate) {
		super();
		this.startDate = startdate;
		this.endDate = enddate;

		this.transformationDetailsBeanFactory = new TransformationDetailsBeanFactory(
			startDate, endDate);
		this.publicationDetailsBeanFactory = new PublicationDetailsBeanFactory(
			 startDate, endDate);
		this.orggoalsFactory = new OrganizationGoalsSummaryBeanFactory(
				startDate, endDate);
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
	
	

	public List<OrganizationProgressDetailsBean> getOrgProgressbeans() {
		UrlApi api = new UrlApi();
		api.setOrganizationId(this.organizationId);
		JSONObject json = api.listOrganizations();
		JSONArray result = (JSONArray) json.get("result");
		List<OrganizationProgressDetailsBean> all = new ArrayList<OrganizationProgressDetailsBean>();
		Iterator it = result.iterator();
		while (it.hasNext()) {
			JSONObject jsonObject = (JSONObject) it.next();
			String organizationId = jsonObject.get("dbID").toString();
			String organizationName = jsonObject.getString("englishName");
			if (organizationName.equals("NTUA"))
				continue;
			if (organizationName.equals("Old euscreen data")) continue;			
			List<OrganizationProgressDetailsBean> progbeans = new ArrayList<OrganizationProgressDetailsBean>();
			progbeans = getOrgProgressbeans(organizationId);
			all.addAll(progbeans);
		}

		return all;

	}

	public List<OrganizationProgressDetailsBean> getOrgProgressbeans(
			String orgid) {
		UrlApi api = new UrlApi();
		api.setOrganizationId(orgid);
		JSONObject json = api.listOrganizations();
		JSONArray result = (JSONArray) json.get("result");
		JSONObject jsonObject = result.getJSONObject(0);
		return getOrgProgressbeans(jsonObject);

	}

	public List<OrganizationProgressDetailsBean> getOrgProgressbeans(
			JSONObject jsonObject) {

		List<OrganizationProgressDetailsBean> organizations = new ArrayList<OrganizationProgressDetailsBean>();

		String name = jsonObject.get("englishName").toString();
		String country = jsonObject.get("country").toString();
		String organizationId = jsonObject.get("dbID").toString();
		
	//	this.populateFactories(organizationId);

		List<PublicationDetailsBean> publicationsbeanCollection = null;
		List<TransformationDetailsBean> transformationsbeanCollection = null;
		List<OrganizationGoalsSummaryBean> goalsbeanColleection = null;
		List<OrgOAIBean> orgoaibeanCollection = null;
		
		//System.out.println("DEBUG, Started making lists  " + "for organization "+name+" "+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		transformationsbeanCollection = transformationDetailsBeanFactory.getTransformations(organizationId);
		//System.out.println("DEBUG, finished making transformed lists  " + "for organization "+name+" "+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		publicationsbeanCollection = publicationDetailsBeanFactory
				.getPublications(organizationId);
		//System.out.println("DEBUG, finished making published lists  " + "for organization "+name+" "+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		orgoaibeanCollection = orgoaibeanfactory.getOrgOAIBeans2(organizationId);
		//System.out.println("DEBUG, finished making oai published lists  " + "for organization "+name+" "+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		
		Integer transformed = transformationDetailsBeanFactory.getTransformedItems(organizationId);
		Integer published = publicationDetailsBeanFactory.getPublishedItems(organizationId);
		Integer oaipublished = orgoaibeanfactory.getItemCount(organizationId);
		
		//System.out.println("DEBUG, passing "+" "+transformed+" "+ published+" "+ oaipublished);

		goalsbeanColleection = orggoalsFactory.getOrgGoalBeans(organizationId,transformed,published,oaipublished);

		//System.out.println("DEBUG, finished making goals  lists  " + "for organization "+name+" "+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		
		OrganizationProgressDetailsBean orgBean = new OrganizationProgressDetailsBean(
				name, country, transformationsbeanCollection,
				publicationsbeanCollection, goalsbeanColleection,
				orgoaibeanCollection);

		organizations.add(orgBean);
		return organizations;
	}
	
	/*protected void populateFactories(String organizationId) {
		transformationDetailsBeanFactory.setOrganizationId(organizationId);
		publicationDetailsBeanFactory.setOrganizationId(organizationId);
		orgoaibeanfactory.setOrganizationId(organizationId);
	//	orggoalsFactory.setOrganizationid(organizationId);	
	}
*/

}
