package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	  @Result(name="error", location="statistics.jsp"),
	  @Result(name="success", location="statistics.jsp")
	})


public class Stats extends GeneralAction {

	protected final static Logger log = Logger.getLogger(Stats.class);
	
	
	
	
	long uploadId;

	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}

	public String getName() {
		return DB.getDatasetDAO().getById(this.uploadId, false).getName();
	}
	
	public long getNoItems(){
		return DB.getDatasetDAO().getById(this.uploadId, false).getItemCount();
	}
	
	@Action(value="Stats")
	public String execute() throws Exception {
		return SUCCESS;
	}

}
