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

public class ProjectGoalBeanFactory extends OrganizationProgressBeanFactory {

	public ProjectGoalBeanFactory(Date startdate, Date enddate) {
		super(startdate, enddate);
		// TODO Auto-generated constructor stub
	}

	public List<OrganizationGoalsSummaryBean> getProjectGoalBeans() {		
		
		Integer totaltransformed = 0;
		Integer totalpublished = 0 ;
		Integer totaloaipublished = 0 ;
		
		Integer projectfinalTargetItems = 0;
		Integer projectCurrentTargetItems =0 ;
		
		UrlApi api = new UrlApi();
		api.setOrganizationId(null);
		JSONObject json = api.listOrganizations();
		JSONArray result = (JSONArray) json.get("result");
		
		
		List<OrganizationGoalsSummaryBean> all = new ArrayList<OrganizationGoalsSummaryBean>();
		
		Iterator it = result.iterator();
		
		Date finalDate = null;

		Date targetDate = null;
		
		Date today = endDate;
		
		Integer finaltargetItems = 0;
		Integer targetItems = 0 ;
		
		while (it.hasNext()) {
			
			finaltargetItems = 0;
			
			targetItems = 0;
			
			JSONObject jsonObject = (JSONObject) it.next();
			String organizationId = jsonObject.get("dbID").toString();
			
			String organizationName = jsonObject.getString("englishName");
			if (organizationName.equals("NTUA"))
				continue;
			if (organizationName.equals("Old euscreen data")) continue;
			List<OrganizationGoalsSummaryBean> progbeans = new ArrayList<OrganizationGoalsSummaryBean>();
			totaltransformed +=transformationDetailsBeanFactory.getTransformedItems(organizationId);	
			totalpublished += publicationDetailsBeanFactory.getPublishedItems(organizationId);
			
			
			JSONObject targets = new JSONObject();
			JSONArray periods = new JSONArray();
			try {
				if (jsonObject.has("targets")) {
					targets = jsonObject.getJSONObject("targets");
					if (targets.has("periods")) {
						periods = (JSONArray) targets.get("periods");
					}
				}
			} catch (NullPointerException e) {
				e.printStackTrace();
			}

			

			
			Iterator iter = periods.iterator();
			while (iter.hasNext()) {
				JSONObject jsObject = (JSONObject) iter.next();
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
			iter = periods.iterator();
			while (iter.hasNext()) {
				JSONObject jsObject = (JSONObject) iter.next();
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

			
			projectCurrentTargetItems += targetItems;
			projectfinalTargetItems+= finaltargetItems;
		}
		
		
		totaloaipublished = orgoaibeanfactory.getProjectstatus().getUnique() / 2 ;
		
		
		OrganizationGoalsSummaryBean transformedgoalbean = new OrganizationGoalsSummaryBean(
				"Transformed Valid Items", today, totaltransformed, null,
				null, "transformed");
		all.add(transformedgoalbean);

		OrganizationGoalsSummaryBean publishedgoalbean = new OrganizationGoalsSummaryBean(
				"Published Valid Items", today, totalpublished, null, null,
				"published");
		all.add(publishedgoalbean);

		OrganizationGoalsSummaryBean oaipublishedgoalbean = new OrganizationGoalsSummaryBean(
				"OAI Published Valid Items", today, totaloaipublished, null,
				null, "oaipublished");
		all.add(oaipublishedgoalbean);

		OrganizationGoalsSummaryBean currentGoalbean = new OrganizationGoalsSummaryBean(
				"Current Target Number of Items", targetDate,
				projectCurrentTargetItems, null, null, "current goal");
		all.add(currentGoalbean);

		OrganizationGoalsSummaryBean finalGoalbean = new OrganizationGoalsSummaryBean(
				"Final Target Number of Items", finalDate, projectfinalTargetItems,
				null, null, "final goal");
		all.add(finalGoalbean);
		
		

		return all;	
		
	}

	
}
