
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;

import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Lock;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.xml.TreeGenerationParser;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	  @Result(name="error", location="error.jsp"),
	  @Result(name="success", location="edittemplate.jsp" )
	})

public class EditTemplate extends GeneralAction  {

	protected final Logger log = Logger.getLogger(getClass());
	private long id;
	private XmlSchema schema;
	
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}
	
	public XmlSchema getSchema(){
		return schema;
	}
	
	public void  setSchema(XmlSchema schema){
		this.schema = schema;
	}
	
	
	@Action(value="EditTemplate")
    public String execute() throws Exception {
			XmlSchema xmls = DB.getXmlSchemaDAO().getById(getId(), false);
			this.setSchema(xmls);
			if( xmls !=null){
				return "success";
			}
			else return "error";
    }

	
}
