package gr.ntua.ivml.mint.actions;

import static gr.ntua.ivml.mint.util.StringUtils.empty;
import gr.ntua.ivml.mint.Custom;
import gr.ntua.ivml.mint.concurrent.Solarizer;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.StringUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.FacetField.Count;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;



@Results({
	@Result(name="error", location="json.jsp"),
	@Result(name="success", location="json.jsp")
})

public class ItemSearch extends GeneralAction{

	protected final static Logger log = Logger.getLogger( ItemSearch.class );
	public final static int FIELD_LIMIT = 100;
	
	private JSONObject json = new JSONObject();
		
    // restrictions
	private String datasetId;
	private String organizationId;
	
	private String query;

	private String mode;
	private String facetField;
	private String field;
	
	private int start, max;
	
	// search all field with given query
	// return all meta of the items in json
	public static final String MODE_SIMPLE = "simple";
	
	public static String[] metaFieldList = {"item_id", "organization_id", "source_item_id", "last_modified_tdt",
		"user_id", "schema_id", "schema_name_s", "valid_b", "label_s", "native_id_s" };
	
	@Action(value="ItemSearch")
	public String execute() throws Exception {
		SolrQuery sq = new SolrQuery();
		if( start > 0 ) 
			sq.setStart(start);
		if( max > 0 ) 
			sq.setRows(max);
		if( empty(query)) return error( "No query specified" );
		
		if( ! StringUtils.empty(facetField)) {
			String[] facetFieldArr = facetField.split(", ");
			sq.addFacetField(facetFieldArr);
		}
		
		// check params
		if( empty( mode ) || ( MODE_SIMPLE.equals(mode))) {
			return modeSimple( sq );
		}
		return SUCCESS;
	}
	
	public String modeSimple( SolrQuery sq ) {
		try {
			sq.setQuery(query);
			addRightsFilter( sq );
			// sq.setFields("*_s");
			QueryResponse qr = Solarizer.getSolrServer().query(sq);
			searchResponse( qr );
		} catch (Exception e ) {
			return error("Problem executing query." );
		}
		return SUCCESS;
	}
	
	private void searchResponse( QueryResponse qr ) {
    	SolrDocumentList sdl = qr.getResults();
		JSONObject searchMeta = new JSONObject();
		searchMeta.element( "hits", sdl.getNumFound())
			.element( "first", sdl.getStart())
			.element( "count", sdl.size());
		
		JSONArray items = new JSONArray();
    	
    	for( SolrDocument sd: sdl ) {
    		JSONObject item = new JSONObject();
    		
    		for( String fieldName: sd.getFieldNames() ) {
    			JSONArray values = new JSONArray();
    			int limit = FIELD_LIMIT;
    			for( Object val: sd.getFieldValues(fieldName)) {
    				if( limit == 0 ) break;
    				else limit -= 1 ;
    				values.add( val.toString());
    			}
    			if( values.size() > 0 ) 
    				item.element( fieldName, values);
    		}
    		items.add( item );
    	}
    	
    	
    	if( qr.getFacetFields() != null ) {
    		for( FacetField ff : qr.getFacetFields() ) {
    			JSONObject facet = new JSONObject();
    			JSONArray facetValues = new JSONArray();
    			facet.element( "name", ff.getName());
    			for( Count c: ff.getValues()) {
    				facetValues.add( new JSONObject().element( c.getName(), c.getCount()));
    			}

    			if( !searchMeta.has("facets"))
        			searchMeta.element( "facets", new JSONArray());
    			facet.element( "values", facetValues );
        		
        		searchMeta.accumulate( "facets", facet );
    		}
    	}   	
		json.element( "searchMeta", searchMeta);
    	json.element( "items", items );

	}
	
	private String error( String msg ) {
		json.element( "error", msg );
		return ERROR;
	}
	
	/**
	 * Add a filter to the query that respects the access rights of the user.
	 */
	public void addRightsFilter( SolrQuery query ) {
		// if the user cannot see everything, we need to add a filter
		if (getUser().hasRight(User.SUPER_USER)) return;
		if(! getUser().hasRight( User.VIEW_DATA ) ) {
			// that should get nothing back
			query.addFilterQuery( "item_id:bla" );
			log.debug( "Added filter item_id:bla");
		}
		// get which orgs he can see
		StringBuilder sb = new StringBuilder();
		sb.append("organization_id:(" );
		
		for( Organization o: getUser().getAccessibleOrganizations()) {
			sb.append( " " + o.getDbID() );
		}
		sb.append( ")");
		log.debug( "Added filter " + sb.toString());
		query.addFilterQuery(sb.toString());
		Custom.rightsFilter( query, user );
	}
	
	
	//
	// Below the Getter / Setter section
	//
	
	public void setJson(JSONObject json) {
		this.json = json;
	}

	public JSONObject getJson() {
		return json;
	}

	public String getDatasetId() {
		return datasetId;
	}

	public void setDatasetId(String datasetId) {
		this.datasetId = datasetId;
	}

	public String getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(String organizationId) {
		this.organizationId = organizationId;
	}

	public String getQuery() {
		return query;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}


	public String getFacetField() {
		return facetField;
	}

	public void setFacetField(String facetField) {
		this.facetField = facetField;
	}

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
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
}