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

public class OrganizationGoalsSummaryBeanFactory {

	Date startDate;
	Date endDate;
	

	public OrganizationGoalsSummaryBeanFactory( Date startdate,
			Date enddate) {
		super();
		this.startDate = startdate;
		this.endDate = enddate;


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




	public List<OrganizationGoalsSummaryBean> getOrgGoalBeans(String orgid,Integer transformed,Integer published,Integer oaipublished)  {

		UrlApi api = new UrlApi();
		api.setOrganizationId(orgid);
		JSONObject json = api.listOrganizations();
		JSONArray result = (JSONArray) json.get("result");
		JSONObject jsonObject = result.getJSONObject(0);
	//	System.out.println("DEBUG, items passed to getOrgGoalBeans A "+" "+transformed+" "+ published+" "+ oaipublished);
		return this.getOrgGoalBeans(jsonObject,transformed,published,oaipublished);

	}

	public List<OrganizationGoalsSummaryBean> getOrgGoalBeans(
			JSONObject jsonObject,Integer transformed,Integer published,Integer oaipublished) {

		List<OrganizationGoalsSummaryBean> goals = new ArrayList<OrganizationGoalsSummaryBean>();

	//	System.out.println("DEBUG, items passed to getOrgGoalBeans B "+" "+transformed+" "+ published+" "+ oaipublished);
		
		String name = jsonObject.get("englishName").toString();
		String country = jsonObject.get("country").toString();
		String organizationId = jsonObject.get("dbID").toString();
		

		JSONObject targets = new JSONObject();
		JSONArray result = new JSONArray();

		try {
			if (jsonObject.has("targets")) {
				targets = jsonObject.getJSONObject("targets");
				if (targets.has("periods")) {
					result = (JSONArray) targets.get("periods");
				}
			}
		} catch (NullPointerException e) {
			e.printStackTrace();
		}

		Integer finaltargetItems = 0;
		Date finalDate = null;

		Integer targetItems = 0;
		Date targetDate = null;

		// Date today = new Date();
		Date today = endDate;

		Iterator it = result.iterator();
		while (it.hasNext()) {
			JSONObject jsObject = (JSONObject) it.next();
			finaltargetItems += (Integer) jsObject.get("count");
			String end = jsObject.get("end").toString();
			try {
				finalDate = new SimpleDateFormat("dd-MM-yyyy").parse(end);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if (today.before(finalDate)) {
				targetDate = finalDate;
			}
		}
		it = result.iterator();
		while (it.hasNext()) {
			JSONObject jsObject = (JSONObject) it.next();
			targetItems += (Integer) jsObject.get("count");
			String end = jsObject.get("end").toString();
			try {
				targetDate = new SimpleDateFormat("dd-MM-yyyy").parse(end);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if (today.before(targetDate)) {
				break;
			}
		}

		Integer totalTransformedValidItems = transformed;
		Integer totalPublishedValidItems = published;
		Integer totalOaiPublishedValidItems = oaipublished;
		
		//System.out.println("DEBUG, items passed to getOrgGoalBeans "+" "+totalTransformedValidItems+" "+ totalPublishedValidItems+" "+totalOaiPublishedValidItems);


		OrganizationGoalsSummaryBean transformedgoalbean = new OrganizationGoalsSummaryBean(
				"Transformed Valid Items", today, totalTransformedValidItems,
				name, organizationId, "transformed");
		goals.add(transformedgoalbean);

	//	System.out.println("DEBUG, made transbean");
		
		OrganizationGoalsSummaryBean publishedgoalbean = new OrganizationGoalsSummaryBean(
				"Published Valid Items", today, totalPublishedValidItems, name,
				organizationId, "published");
		goals.add(publishedgoalbean);
	//	System.out.println("DEBUG, made publbean");
		OrganizationGoalsSummaryBean oaipublishedgoalbean = new OrganizationGoalsSummaryBean(
				"OAI Published Items", today, totalOaiPublishedValidItems,
				name, organizationId, "oaipublished");
		goals.add(oaipublishedgoalbean);

	//	System.out.println("DEBUG, made oaipublbean");
		OrganizationGoalsSummaryBean currentGoalbean = new OrganizationGoalsSummaryBean(
				"Current Target Number of Items", targetDate, targetItems,
				name, organizationId, "current goal");
		goals.add(currentGoalbean);
	//	System.out.println("DEBUG, made curgoalbean");

		OrganizationGoalsSummaryBean finalGoalbean = new OrganizationGoalsSummaryBean(
				"Final Target Number of Items", finalDate, finaltargetItems,
				name, organizationId, "final goal");
		goals.add(finalGoalbean);
	//	System.out.println("DEBUG, made finalgoalbean");

		return goals;
	}

	

}
