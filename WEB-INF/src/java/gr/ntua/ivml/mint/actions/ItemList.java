package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="json.jsp"),
	@Result(name="success", location="json.jsp")
})

public class ItemList extends GeneralAction {

	public static final Logger log = Logger.getLogger(ValueList.class ); 

	public static final String ALL = "all";
	public static final String VALID = "valid";
	public static final String INVALID = "invalid";
	
	private JSONObject json;
	private int start, max;
	private long datasetId;
	private String filter = ALL;
	
	@Action(value="ItemList")
	public String execute() {
		json = new JSONObject();
		json.element("start", start);
		json.element("max", max);
		json.element("datasetId", datasetId);
		try {
			Dataset dataset = getDataset();
			if( dataset != null ) {
				int total = 0;
				if(getFilter() == null || getFilter().equalsIgnoreCase(ItemList.ALL)) {
					total = dataset.getItemCount();
				} else {
					if(getFilter().equalsIgnoreCase(ItemList.VALID)) {
						total = dataset.getValidItemCount();
					} else if(getFilter().equalsIgnoreCase(ItemList.INVALID)){
						total = dataset.getInvalidItemCount();
					}
				}
					
				json.element("total", total);
//				if( isTotalCount() ) {
//					json.element( "totalCount", dataset.getItemCount() );
//				}
				getValues( dataset );
			}
		} catch( Exception e ) {
			json.element( "error", e.getMessage());
			log.error( "No values", e );
		}
		return SUCCESS;
	}
	
	/**
	 * Get the holder and check the read permission of the user.
	 * @return
	 */
	private Dataset getDataset() {
		boolean allow = false;

		Dataset result = null;
		
		result = DB.getDatasetDAO().getById(datasetId, false);

		if( getUser().hasRight(User.SUPER_USER)) allow=true;
		else {
			Organization owner = result.getOrganization();
			if( owner == null ) {
				log.warn( "Dataset " + result.getDbID() + " belongs to no organization." );
			} else {
				if( getUser().can("view data", owner )) allow = true;
			}
		}
		
		if( !allow ) {
			json.element( "error", "No access rights" );
			return null;
		}
		
		return result;	
	}
	
	private void getValues( Dataset dataset ) {
		try {
			List<Item> values = null;
			
			if(getFilter() == null || getFilter().equalsIgnoreCase(ItemList.ALL)) {
				values = dataset.getItems(getStart(), getMax());
			} else {
				if(getFilter().equalsIgnoreCase(ItemList.VALID)) {
					values = dataset.getValidItems(getStart(), getMax());
				} else if(getFilter().equalsIgnoreCase(ItemList.INVALID)){
					values = dataset.getInvalidItems(getStart(), getMax());
				}
			}
			
			JSONArray theValues = new JSONArray();
			for( Item i: values ) {
				JSONObject valJ = new JSONObject();
				valJ.element("id", i.getDbID());
				valJ.element("label", i.getLabel());
				valJ.element("nativeId", i.getPersistentId());
				if(i.getDataset().getSchema() != null) valJ.element("valid", i.isValid());
				theValues.add(valJ);
			}
			json.element("values", theValues);
		} catch( Exception e ) {
			log.error( "No items in dataset " + datasetId, e );
		}
	}
	
	public int getStart() {
		return start;
	}

	public void setStart(int start) {
		this.start = start;
	}

	public int getMax() {
		return max;
	}

	public void setMax(int max) {
		this.max = max;
	}

	public long getDatasetId() {
		return datasetId;
	}

	public void setDatasetId(long datasetId) {
		this.datasetId = datasetId;
	}

	public String getFilter() {
		return filter;
	}

	public void setFilter(String filter) {
		this.filter = filter;
	}

	public void setJson(JSONObject json) {
		this.json = json;
	}

	public JSONObject getJson() {
		return json;
	}
}
