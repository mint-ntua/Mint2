package gr.ntua.ivml.mint.actions;

import java.io.InputStream;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.util.Config;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.InterceptorRef;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;



@Results({
	  @Result(name="error", type="httpheader", params={ "status", "400" }),
	  @Result(name="binary", type="stream", params={"inputName", "stream", "contentType", "application/x-zip-compressed","contentDisposition", "attachment; filename=${filename}"})
	})
	
public class DownloadTransformed extends GeneralAction{
	long transformationId;
	private InputStream inputStream;
	
	public long getTransformationId() {
		return transformationId;
	}

	public void setTransformationId(long transformationId) {
		this.transformationId = transformationId;
	}
	
	public String getFilename(){
		return Long.toString(this.transformationId) + ".zip";
	}
	
	@Action(value="DownloadTransformed",interceptorRefs=@InterceptorRef("defaultStack"))
	public String execute(){
		String res = "error";
		Transformation tran = DB.getTransformationDAO().findById(transformationId, false);
		if(tran == null){
			res = "error";
		}else{
			try {
				this.setInputStream(tran.getDownloadStream().first());
			} catch (Exception e) {
				e.printStackTrace();
			}
			res = "binary";
		}
		return res;
	}

	public InputStream getStream(){
		return inputStream;
	}
	
	public InputStream getInputStream() {
		return inputStream;
	}

	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
	}
}
