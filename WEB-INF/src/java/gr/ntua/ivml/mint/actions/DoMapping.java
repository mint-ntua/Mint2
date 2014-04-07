
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;


import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Lock;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.persistent.User;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	  @Result(name="input", location="xsdmapping.jsp"),
	  @Result(name="error", location="error.jsp"),
	  @Result(name="success", location="xsdmapping.jsp" )
	})

/**
 * Action that opens the mapping editor with the specified dataset/mapping pair.
 * 
 * Use either uploadId or transformationId. If you use both, uploadId will be ignored.
 * 
 * If mapid is defined, the corresponding mapping is always used.
 * If uploadId is defined, the corresponding dataset is used.
 * If transformationId is then:
 * 	- if mapid is not defined, the dataset and mapping used to produce the transformation are used.
 *  - else transformed dataset and specified mapping are used.
 * 
 * Examples:
 * uploadId = 1001 && mapid = 1001         : Open editor with uploadId/mapId pair.
 * uploadId = 1001                         : Open editor with uploadId/most recent mapId pair.
 * transformationId = 1010                 : Open editor with parent of transformationId / transformation mapping pair.
 * transformationId = 1010 && mapid = 1001 : Open editor with parent of transformationId / mapid pair.
 * 
 */
public class DoMapping extends GeneralAction  {

	protected final Logger log = Logger.getLogger(getClass());
	private long uploadId;
	private long transformationId;
	private long mapid;
	private Lock lock;
	private long lockId;
	
	public Dataset getDataset() {
		log.debug("Transformation Id: " + getTransformationId());
		if(getTransformationId() > 0) {
			log.debug("Map Id: " + getMapid());
			if(getMapid() > 0) {
				Dataset dataset = DB.getDatasetDAO().findById(getTransformationId(), false);
				log.debug("Dataset from transformation Id: " + dataset);
				return 	dataset;
			} else {
				Transformation transformation = DB.getTransformationDAO().getById(getTransformationId(), false);
				log.debug("Dataset from transformation parent: " + transformation.getParentDataset());
				return transformation.getParentDataset();
			}
		} else {
			return DB.getDatasetDAO().findById(getUploadId(), false);				
		}
	}

	public long getUploadId() {
		return uploadId;
	}
	
	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}
	
	public long getTransformationId() {
		return transformationId;
	}
	
	public void setTransformationId(long transformationId) {
		this.transformationId = transformationId;
	}
	
	public long getMapid() {
		return mapid;
	}
	
	public Mapping getMapping() {
		if(this.getMapid() == 0) {
			if(getTransformationId() > 0) {
				Transformation transformation = DB.getTransformationDAO().findById(getTransformationId(), false);
				return transformation.getMapping();
			} else {
				Dataset dataset = this.getDataset();
				
				if(dataset != null) {
					return dataset.getRecentMapping();
				}
			}
		} else {
			return DB.getMappingDAO().findById(getMapid(), false);
		}
		
		return null;
	}
	
	public void setMapid(long mapid) {
		this.mapid = mapid;
	}

	public long getLockId() {
		return lockId;
	}

	
	@Action(value="DoMapping")
    public String execute() throws Exception {
			Dataset du = this.getDataset();
			Mapping mp = this.getMapping();
			
			log.debug(du);
			log.debug(mp);
			
			if( du != null && mp != null)
			{
				// store recent info
				mp.addRecentDataset(du);
				
				// acquire lock
				lock=DB.getLockManager().directLock(getUser(), getSessionId(), mp );
		        if(lock!=null)	{
		        	this.lockId=lock.getDbID();
		        	return "success";
		  		} else return "error";
			} else {
				addActionError("Couldn't acquire lock on Mapping!");
			}
			return "error";
    }

	@Action("DoMapping_input")
	@Override
	public String input() throws Exception {
    	if( (user.getOrganization() == null && !user.hasRight(User.SUPER_USER)) || !user.hasRight(User.MODIFY_DATA)) {
    		throw new IllegalAccessException( "No mapping rights!" );
    	}

		return super.input();
	}	
}