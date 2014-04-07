package gr.ntua.ivml.mint.actions;




import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results( { @Result(name = "input", location = "mappingsPanel.jsp"),
		@Result(name = "error", location = "mappingsPanel.jsp"),
		@Result(name = "success", location = "mappingsPanel.jsp"),
		@Result(name= "json", location="json.jsp" )
})

public class MappingsPanel extends GeneralAction {

	protected final Logger log = Logger.getLogger(getClass());
	public String mapName;
	
    private long schemaSel;
	private long uploadId;
	
	private long orgId;
	private int startMapping, endMapping, maxMappings;
	private int mappingCount=0;
	private Organization o=null;

	private List<Mapping> accessibleMappings = new ArrayList<Mapping>();
	private List<Mapping> recentMappings = new ArrayList<Mapping>();
	
	
	public int getMaxMappings() {
		return maxMappings;
	}

	public void setMaxMappings(int maxMappings) {
		this.maxMappings = maxMappings;
	}
	
	public long getOrgId() {
		return orgId;
	}

	public void setOrgId(long orgId) {
		this.orgId = orgId;
		this.o=DB.getOrganizationDAO().findById(orgId, false);
	}

	public int getStartMapping() {
		return startMapping;
	}

	public void setStartMapping( int startMapping ) {
		this.startMapping = startMapping;
	}

	public int getEndMapping() {
		return endMapping;
	}
	public void setEndMapping(int endMapping){
		this.endMapping=endMapping;
	}
   
	public void findAccessibleMappings() {
		List<Mapping> maplist = new ArrayList();
		try {
			if(this.orgId==-1){
				maplist.addAll(getUser().getAccessibleMappings());
			} else {
				maplist.addAll(DB.getMappingDAO().findByOrganization(this.o));
			}
			
			List<Mapping> l = maplist;
			this.mappingCount=maplist.size();
			if(startMapping<0)startMapping=0;


			if(l.size()>(startMapping+maxMappings)){	
				accessibleMappings = maplist.subList((int)(startMapping), startMapping+maxMappings);}
			else{
				accessibleMappings = maplist.subList((int)(startMapping),l.size());}





		} catch (Exception ex) {
			log.debug(" ERROR GETTING MAPPINGS:" + ex.getMessage());
		}
	}
	
	
	private void findRecentMappings() {
		List<Mapping> maplist = getUser().getAccessibleMappings();
		if(this.getUploadId() > 0) {
			Dataset dataset = DB.getDatasetDAO().findById(this.getUploadId(), false);
			recentMappings = Mapping.getRecentMappings(dataset, maplist);
		} else {
			recentMappings = null;
		}
	}

	public List<Mapping> getAccessibleMappings() {
		return accessibleMappings;
	}




	
	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}

	public void setUploadId(String uploadId) {
		this.uploadId = Long.parseLong(uploadId);
	}

	

	public long getSchemaSel() {
		return schemaSel;
	}

	public void setSchemaSel(long schemaSel) {
		this.schemaSel = schemaSel;
	}

	public void setMapName(String mapName) {
		this.mapName = mapName;
	}


	
	public int getMappingsCount() {

		
		return mappingCount;
	}
	

	@Action("MappingsPanel")
	public String execute() {
		
		if ((user.getOrganization() == null && !user.hasRight(User.SUPER_USER))
				|| !user.hasRight(User.MODIFY_DATA)) {
			addActionError("You dont have rights to access mappings.");
			return ERROR;
		}
		if( !isApi()) {
			Dataset du = DB.getDatasetDAO().findById(uploadId, false);
			if( !du.getItemizerStatus().equals(Dataset.ITEMS_OK)) {

				addActionError("You must first define the Item Level and Item Label.");
				return ERROR;
			}
		}
		findAccessibleMappings();
		findRecentMappings();
		if( isApi()) return "json";
		return "success";
	}

	public JSONObject getJson() {
		JSONObject result = new JSONObject();
		JSONArray mappings = new JSONArray();
		for( Mapping m: accessibleMappings) {
			mappings.add( m.toJSON() );
		}
		result.element( "result", mappings );
		return result;
	}

	public List<Mapping> getRecentMappings() {
		return recentMappings;
	}

	public void setRecentMappings(List<Mapping> recentMappings) {
		this.recentMappings = recentMappings;
	}
}