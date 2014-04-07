
package gr.ntua.ivml.mint.actions;


import java.util.ArrayList;

import javax.xml.bind.JAXBElement;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.messages.schema.PublishTransformation;
import gr.ntua.ivml.mint.uim.messages.schema.PublishTransformationAction;
import gr.ntua.ivml.mint.uim.messages.schema.PublishTransformationResponse;
import gr.ntua.ivml.mint.uim.queue.OutboundProducer;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;
import gr.ntua.ivml.mint.util.Config;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	  @Result(name="error", location="json.jsp"),
	  @Result(name="success", location="json.jsp")
	  
	})

public class Publish extends GeneralAction  {

	protected final Logger log = Logger.getLogger(getClass());
	private long uploadId;
	
	private JSONObject json;
	
	public long getUploadId(){
		return uploadId;
	}
	
	public void setUploadId(long uploadId){
		this.uploadId=uploadId;
	}
	
	
	public JSONObject getJson(){
		
		return json;
	}
	
	public void setJson(String message){
		
		json=new JSONObject();
		json.element("message", message);
	}
	

	
	@Action(value="Publish")
    public String execute() throws Exception {
		Transformation trans = DB.getTransformationDAO().getById(this.uploadId, false);
		
		ObjectFactory fact = new ObjectFactory();
		
		if(!trans.isOk()){
			ErrorResponse err = fact.createErrorResponse();
			err.setErrorMessage("No valid transformation was found for import with ID:" + this.uploadId);
			err.setCommand("publishTransformation");
			PublishTransformationAction resp = fact.createPublishTransformationAction();
			
			resp.setError(err);
			OutboundProducer prod = new OutboundProducer();
			String corrId = "*"+System.currentTimeMillis();
			JAXBElement elem = fact.createPublishTransformation(resp);
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(elem);
			prod.sendItem(resP, corrId);
			prod.close();
		}else{
			Long id = trans.getDbID();
			String url = "http://"+Config.get("mint.api.base") + ":" + Config.get("mint.api.port")+"/"+
						Config.get("mint.api.database") + "/DownloadTransformed?transformationId=" + Long.toString(id);
			PublishTransformationResponse resp = fact.createPublishTransformationResponse();
			resp.setTransformationId(Long.toString(id));
			resp.setUrl(url);
			PublishTransformationAction respA = fact.createPublishTransformationAction();
			respA.setPublishTransformationResponse(resp);
			JAXBElement elem = fact.createPublishTransformation(respA);
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(false);
			resP.setPayload(elem);
			/* find the parent upload name */
			
		    Transformation t=trans;
		    Dataset tmp=t.getParentDataset();
		    String corrId="";
			while(tmp!=null){
				if(tmp instanceof DataUpload){
					break;
				}
				else{tmp=((Transformation)tmp).getParentDataset();}
			}
			/*should we add the target transformation schema name?*/
			if(tmp instanceof DataUpload)
			corrId = ((DataUpload)tmp).getOriginalFilename()+"*"+System.currentTimeMillis();
			else
			corrId = trans.getName()+"*"+System.currentTimeMillis();
				
			OutboundProducer prod = new OutboundProducer();
			prod.sendItem(resP, corrId);
			prod.close();
		}
		setJson("Notification sent successfully");
		return "success";
    }

	
}