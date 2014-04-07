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

public class MappingDetailsBeanFactory {

	String organizationId = null;
	private Date startDate;
	private Date endDate;

	public MappingDetailsBeanFactory(String organizationId, Date startDate,
			Date endDate) {
		super();
		this.organizationId = organizationId;

		this.startDate = startDate;
		this.endDate = endDate;
	}

	public String getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(String organizationId) {
		this.organizationId = organizationId;
	}

	public List<MappingDetailsBean> getMappings() {
		UrlApi api = new UrlApi();
		api.setOrganizationId(organizationId);
		JSONObject json = api.listMappings();

		return getMappings(json);
	}

	public List<MappingDetailsBean> getMappings(JSONObject json) {
		List<MappingDetailsBean> mappings = new ArrayList<MappingDetailsBean>();
		JSONArray result = (JSONArray) json.get("result");
		Iterator it = result.iterator();
		while (it.hasNext()) {
			JSONObject jsonObject = (JSONObject) it.next();
			String name = jsonObject.get("name").toString();
			Date created = new Date(0);
			;
			Date lastModified = new Date(0);
			try {

				String dateCreated = (String) jsonObject.get("date");
				created = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
						.parse(dateCreated);
				String dateModified = (String) jsonObject.get("lastModified");
				lastModified = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
						.parse(dateModified);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			if (!(created.compareTo(startDate) > 0 && created
					.compareTo(endDate) < 0)
					&& !(lastModified.compareTo(startDate) > 0 && lastModified
							.compareTo(endDate) < 0)) {
				continue;
			}

			String schemaName = null;
			String schemaId = null;

			String organizationName = null;
			String organizationId = null;

			JSONObject org = (JSONObject) jsonObject.get("organization");
			if (org.has("dbID")) {
				organizationId = org.getString("dbID").toString();
			}
			if (org.has("name")) {
				organizationName = org.getString("name").toString();
			}

			JSONObject schema = (JSONObject) jsonObject.get("Schema");
			try {
				if (schema.has("name")) {
					schemaName = schema.getString("name").toString();

				}
				if (schema.has("dbId")) {
					schemaId = schema.getString("dbId").toString();
				}

			} catch (NullPointerException e) {
				e.printStackTrace();

			}

			MappingDetailsBean mappingDetailsBean = new MappingDetailsBean(
					name, created, lastModified, organizationId,
					organizationName, schemaName, schemaId);
			mappings.add(mappingDetailsBean);
		}

		return mappings;
	}

}
