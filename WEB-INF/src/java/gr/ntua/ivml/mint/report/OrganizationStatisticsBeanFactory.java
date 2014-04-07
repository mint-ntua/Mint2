package gr.ntua.ivml.mint.report;

import gr.ntua.ivml.mint.actions.UrlApi;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class OrganizationStatisticsBeanFactory {

	DataUploadDetailsBeanFactory datauploadDetailsFactory;
	TransformationDetailsBeanFactory transformationDetailsBeanFactory;
	PublicationDetailsBeanFactory publicationDetailsBeanFactory;
	OrgOAIBeanFactory orgOaiBeanFactory;



	private Date startDate;
	private Date endDate;

	public OrganizationStatisticsBeanFactory(Date startDate, Date endDate) {
		super();

		this.startDate = startDate;
		this.endDate = endDate;
		
		this.datauploadDetailsFactory = new DataUploadDetailsBeanFactory(startDate, endDate);
		this.transformationDetailsBeanFactory = new TransformationDetailsBeanFactory(startDate, endDate);
		this.publicationDetailsBeanFactory = new PublicationDetailsBeanFactory(startDate, endDate);
		this.orgOaiBeanFactory = new OrgOAIBeanFactory();
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

	public List<OrganizationStatisticsBean> getOrgStatisticsBeans() {

		UrlApi api = new UrlApi();
		JSONObject json = api.listOrganizations();
		return getOrgStatisticsBeans(json);

	}

	public List<OrganizationStatisticsBean> getOrgStatisticsBeans(
			JSONObject json) {
		List<OrganizationStatisticsBean> organizations = new ArrayList<OrganizationStatisticsBean>();
		JSONArray result = (JSONArray) json.get("result");

		Iterator it = result.iterator();
		int uploadedItems = 0;
		int transformedItems = 0;
		int publishedItems = 0 ;
		int oaicommited = 0 ;
		
		while (it.hasNext()) {
			JSONObject jsonObject = (JSONObject) it.next();
			String organizationId = jsonObject.get("dbID").toString();
			String name = jsonObject.get("englishName").toString();
			String country = jsonObject.get("country").toString();
		
			 uploadedItems = 0;
			 transformedItems = 0;
			 publishedItems = 0 ;
			 oaicommited = 0 ;
			
			
			if (name.equals("NTUA"))
				continue;

			 uploadedItems = datauploadDetailsFactory.getUploadedItems(organizationId);
			
			
			 transformedItems = transformationDetailsBeanFactory.getTransformedItems(organizationId);
			
			 publishedItems = publicationDetailsBeanFactory.getPublishedItems(organizationId);
			
			 oaicommited = orgOaiBeanFactory.getItemCount(organizationId);


			OrganizationStatisticsBean organizationStatisticsbean = new OrganizationStatisticsBean(
					name, country, uploadedItems, transformedItems,
					publishedItems, oaicommited);

			organizations.add(organizationStatisticsbean);
		}

		//Collections.sort(organizations);
		return organizations;

	}

}
