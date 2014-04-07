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

public class OaiPublicationDetailsBeanFactory {

	String organizationId = null;

	OaijsonFetcher oaijsonFetcher;
	private Date startDate;
	private Date endDate;

	public OaiPublicationDetailsBeanFactory(String organizationId,
			Date startDate, Date endDate) {
		super();
		this.organizationId = organizationId;
		this.oaijsonFetcher = new OaijsonFetcher(this.organizationId);

		this.startDate = startDate;
		this.endDate = endDate;
	}

	public List<OaiPublicationDetailsBean> getOaiPublicationDetailsBeans() {
		UrlApi api = new UrlApi();
		api.setOrganizationId(this.organizationId);
		JSONObject json = api.listOrganizations();
		JSONArray result = (JSONArray) json.get("result");
		List<OaiPublicationDetailsBean> all = new ArrayList<OaiPublicationDetailsBean>();
		Iterator it = result.iterator();
		while (it.hasNext()) {
			JSONObject jsonObject = (JSONObject) it.next();
			String organizationId = jsonObject.get("dbID").toString();
			String organizationName = (String) jsonObject.get("englishName");
			/*
			 * OaiPublicationDetailsBeanFactory oaifactory = new
			 * OaiPublicationDetailsBeanFactory( organizationId, startDate,
			 * endDate);
			 */
			List<OaiPublicationDetailsBean> pubs = new ArrayList<OaiPublicationDetailsBean>();
			/*
			 * pubs = oaifactory.getOaiPublicationDetailsBeans(organizationId,
			 * organizationName);
			 */
			pubs = getOaiPublicationDetailsBeans(organizationId,
					organizationName);
			all.addAll(pubs);
		}

		return all;

	}

	public List<OaiPublicationDetailsBean> getOaiPublicationDetailsBeans(
			String orgid, String organizationName) {
		JSONObject result = oaijsonFetcher.getJson();
		return getOaiPublicationDetailsBeans(result, organizationName);
	}

	public List<OaiPublicationDetailsBean> getOaiPublicationDetailsBeans(
			JSONObject result, String organizationName) {
		List<OaiPublicationDetailsBean> oaiPublications = new ArrayList<OaiPublicationDetailsBean>();
		if (result != null) {

			JSONArray oaiReports = (JSONArray) result.get("reports");
			Iterator it = oaiReports.iterator();
			while (it.hasNext()) {
				JSONObject jsonObject = (JSONObject) it.next();
				String projectName = (String) jsonObject.get("projectName");
				Integer organizationId = (Integer) jsonObject.get("orgId");
				Long datestamp = (Long) jsonObject.get("datestamp");

				String dateCreated = (String) jsonObject.get("publicationDate");
				Date created = null;
				try {
					created = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss")
							.parse(dateCreated);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				if (!(created.compareTo(startDate) > 0 && created
						.compareTo(endDate) < 0)) {
					continue;
				}
				Integer insertedRecords = 0;
				Integer conflictedRecords = 0;

				if (jsonObject.get("insertedRecords") != null) {
					insertedRecords = (Integer) jsonObject
							.get("insertedRecords") / 2;
				}
				// else insertedRecords = 0;

				if (jsonObject.get("conflictedRecords") != null) {
					conflictedRecords = (Integer) jsonObject
							.get("conflictedRecords") / 2;
				}
				// else conflictedRecords = 0;

				OaiPublicationDetailsBean oaipublicationbean = new OaiPublicationDetailsBean(
						projectName, organizationName, organizationId,
						datestamp, created, insertedRecords, conflictedRecords);
				oaiPublications.add(oaipublicationbean);
			}
		}
		return oaiPublications;
	}

	public Integer gettotalValidItemsPublished() {
		Integer totalValidPublished = 0;
		List<OaiPublicationDetailsBean> tlist = this
				.getOaiPublicationDetailsBeans();

		Iterator<OaiPublicationDetailsBean> it = tlist.iterator();

		while (it.hasNext()) {
			OaiPublicationDetailsBean oaibean = (OaiPublicationDetailsBean) it
					.next();
			totalValidPublished += oaibean.getInsertedRecords();
		}

		/*
		 * if (tlist.size()>0){ OaiPublicationDetailsBean oaibean =
		 * tlist.get(tlist.size() -1); totalValidPublished =
		 * oaibean.getInsertedRecords(); }
		 */

		return totalValidPublished;
	}

}
