package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.concurrent.Itemizer;
import gr.ntua.ivml.mint.concurrent.Queues;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="json.jsp"),
	@Result(name="success", location="json.jsp")
})

public class Itemize extends GeneralAction {

	public static final Logger log = Logger.getLogger(Itemize.class ); 
	private long uploadId;
	private String itemLevel;
	private String itemLabel;
	private String itemNativeId;
	private boolean force;
	private JSONObject json;
	

	@Action(value="Itemize")
	public String execute() {
		try {
			this.json = new JSONObject();
			
			final DataUpload du = DB.getDataUploadDAO().findById(this.getUploadId(), false);

			if(du != null) {
				if(force || du.getItemRootXpath() == null || (!du.getItemRootXpath().getXpathWithPrefix(true).equals(this.getItemLevel()))) {
					du.setItemizerStatus(Dataset.ITEMS_NOT_APPLICABLE);
					this.json.put("force", this.getForce());
					this.json.put("itemize", true);
				} else {
					this.json.put("relabel", true);
				}
				
				this.json.put("level", this.itemLevel);
				this.json.put("label", this.itemLabel);
				this.json.put("nativeId", this.itemNativeId);
				
				du.setItemRootXpath(du.getByPath(this.getItemLevel()));
				if( this.getItemLabel().length()>0 )
					du.setItemLabelXpath(du.getByPath(this.getItemLabel()));
				if( this.getItemNativeId().length() > 0 )
					du.setItemNativeIdXpath(du.getByPath(this.getItemNativeId()));
				
				DB.commit();

				Queues.queue(new Itemizer(du), "db");
			}
		} catch( Exception e ) {
			log.error( "Itemization error", e );
		}
		return SUCCESS;
	}
	
	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}
	
	public String getItemLevel() {
		return this.itemLevel.trim();
	}
	
	public void setItemLevel(String path) {
		this.itemLevel = path.trim();
	}
	
	public String getItemLabel() {
		return this.itemLabel.trim();
	}
	
	public void setItemLabel(String path) {
		this.itemLabel = path.trim();
	}
	
	public String getItemNativeId() {
		return this.itemNativeId.trim();
	}
	
	public void setItemNativeId(String path) {
		this.itemNativeId = path.trim();
	}
	
	public boolean getForce() {
		return this.force;
	}
	
	public void setForce(boolean force) {
		this.force = force;
	}

	public JSONObject getJson() {
		return this.json;
	}
}
