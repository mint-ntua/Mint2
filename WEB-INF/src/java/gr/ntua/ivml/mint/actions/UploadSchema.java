package gr.ntua.ivml.mint.actions;

import java.io.File;


import java.util.Collection;

import java.util.List;
import java.util.ArrayList;


import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.mapping.MappingConverter;


import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.util.StringUtils;

import net.sf.json.JSONObject;



import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;




@Results( { @Result(name = "input", location = "uploadschema.jsp"),
	@Result(name = "error", location = "uploadschema.jsp"),
	@Result(name="success", location="${url}", type="redirect" )
})

public class UploadSchema extends GeneralAction {

	protected final Logger log = Logger.getLogger(getClass());
	public String schemaName;

	private String upfile;

	private String httpUp;
	public String url="successschema";

	public boolean automatic = Config.getBoolean("ui.default.automaticMappings");
	public boolean idmappings = Config.getBoolean("ui.default.idMappings");

	

	public String getHttpUp() {
		return httpUp;
	}

	public void setHttpUp(String httpUp) {
		this.httpUp = httpUp;
	}



	public void setUpfile(String upfile){
		this.upfile=upfile;
	}

	public String getUpfile(){
		return(upfile);
	}



	@Action(value = "UploadSchema")
	public String execute() throws Exception {
		
		String dir= System.getProperty("java.io.tmpdir") + File.separator;
		File newmapping=new File(dir+upfile);
		StringBuffer contents = StringUtils.fileContents(newmapping, true);
		System.out.println(contents);
		return SUCCESS;
	}
		
		/*if(selaction==null){selaction="";}
		Organization o;
		if(user.organization==null){
			o=DB.getDatasetDAO().findById(uploadId, false).getOrganization();
			this.orgId=o.getDbID();

		}
		else{
			o=user.organization;
			this.orgId=user.getOrganization().getDbID();
		}
		findSchemas();
		if ("createschemanew".equals(selaction)) {
			if (mapName == null || mapName.length() == 0) {

				addActionError("Specify a mapping name!");
				return ERROR;
			}

			if (getSchemaSel() <= 0) {

				addActionError("No schema specified!");
				return ERROR;
			}

			Mapping mp = new Mapping();
			mp.setCreationDate(new java.util.Date());
			if (checkName(mapName) == true) {

				addActionError("Mapping name already exists!");
				return ERROR;

			}
			mp.setName(mapName);
			mp.setOrganization(o);
			// mp.setOrganization(user.getOrganization());
			if (getSchemaSel() > 0) {
				long schemaId = getSchemaSel();
				XmlSchema schema = DB.getXmlSchemaDAO()
						.getById(schemaId, false);
				mp.setTargetSchema(schema);
				mp.setJsonString(schema.getJsonTemplate());
			}

			Dataset ds = DB.getDatasetDAO().findById(uploadId, false);

			// apply automatic mappings from schema configuration
			try {
				mp.applyConfigurationAutomaticMappings(ds);
			} catch(Exception e) {
				e.printStackTrace();
			}
			
			// if automatic mappings are enabled, try to apply them
			if(this.getAutomatic()) {
				try {
					mp.applyAutomaticMappings(ds);
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
			
			// if id mappings are required check if schema supports and map them
			if(this.getIdMappings()) {
				try {
					log.debug("Apply id mappings");
					mp.applyIdMappings(ds);
				} catch(Exception e) {
					e.printStackTrace();
				}
			}

			// save mapping name to db and commit

			DB.getMappingDAO().makePersistent(mp);
			DB.commit();
			this.setSelectedMapping(mp.getDbID());
			this.url+="?selectedMapping="+this.selectedMapping+"&uploadId="+this.uploadId+"&orgId="+this.orgId+"&userId="+this.user.getDbID()+"&selaction="+this.getSelaction();

			return "success";
		} 
		else if ("uploadmapping".equals(selaction)) {
			if (this.upfile == null || upfile.length() == 0) {

				addActionError("Please upload a file first!");
				return ERROR;
			}
			if (mapName == null || mapName.length() == 0) {

				addActionError("Specify a mapping name!");
				return ERROR;
			}

			if (getSchemaSel() <= 0) {

				addActionError("No schema specified!");
				return ERROR;
			}

			Mapping mp = new Mapping();
			mp.setCreationDate(new java.util.Date());
			if (checkName(mapName) == true) {

				addActionError("Mapping name already exists!");
				return ERROR;

			}
			mp.setName(mapName);

			mp.setOrganization(o);

			String convertedMapping = null;
			
			if(upfile!=null){
				try{
					String dir= System.getProperty("java.io.tmpdir") + File.separator;
					File newmapping=new File(dir+upfile);
					StringBuffer contents = StringUtils.fileContents(newmapping);
					MappingConverter converter = new MappingConverter(DB.getXmlSchemaDAO()
							.getById(getSchemaSel(), false));
					JSONObject converted = converter.convert(contents.toString());
					if(converted != null) convertedMapping = converted.toString();
				}catch (Exception e){//Catch exception if any
					e.printStackTrace();

					System.err.println("Error importing file: " + e.getMessage());
					addActionError("Mappings import failed: " + e.getMessage());
					return ERROR;
				}	}
			if (getSchemaSel() > 0) {
				long schemaId = getSchemaSel();
				XmlSchema schema = DB.getXmlSchemaDAO()
						.getById(schemaId, false);
				mp.setTargetSchema(schema);

				if(convertedMapping != null) {
					mp.setJsonString(convertedMapping);
				} else {
					mp.setJsonString(schema.getJsonTemplate());
				}
			}

			// save mapping name to db and commit?

			DB.getMappingDAO().makePersistent(mp);
			DB.commit();
			this.setSelectedMapping(mp.getDbID());
			this.url+="?selectedMapping="+this.selectedMapping+"&uploadId="+this.uploadId+"&orgId="+this.orgId+"&userId="+this.user.getDbID()+"&selaction="+this.getSelaction();

			return "success";
		} else if ("uploadxsl".equals(selaction)) {
			if (this.upfile == null || upfile.length() == 0) {

				addActionError("Please upload a file first!");
				return ERROR;
			}
			if (mapName == null || mapName.length() == 0) {

				addActionError("Specify a mapping name!");
				return ERROR;
			}

			if (getSchemaSel() <= 0) {

				addActionError("No schema specified!");
				return ERROR;
			}

			Mapping mp = new Mapping();
			mp.setCreationDate(new java.util.Date());
			if (checkName(mapName) == true) {

				addActionError("Mapping name already exists!");
				return ERROR;

			}
			mp.setName(mapName);

			mp.setOrganization(o);

			String xsl = null;

			if(upfile!=null){
				try{
					String dir= System.getProperty("java.io.tmpdir") + File.separator;
					File newmapping=new File(dir+upfile);
					StringBuffer contents = StringUtils.fileContents(newmapping, true);
					xsl = contents.toString();
				}catch (Exception e){//Catch exception if any
					e.printStackTrace();

					System.err.println("Error importing file: " + e.getMessage());
					addActionError("Mappings import failed: " + e.getMessage());
					return ERROR;
				}
			}

			if (getSchemaSel() > 0) {
				long schemaId = getSchemaSel();
				XmlSchema schema = DB.getXmlSchemaDAO()
						.getById(schemaId, false);
				mp.setTargetSchema(schema);

				if(xsl != null) {
					mp.setXsl(xsl);
				} else {
					System.err.println("Error importing xsl: xsl is null");
					addActionError("Mappings import failed: xsl is null");
					return ERROR;
				}
			}

			// save mapping name to db and commit?

			DB.getMappingDAO().makePersistent(mp);
			DB.commit();
			this.setSelectedMapping(mp.getDbID());
			this.url = "successxsl?selectedMapping="+this.selectedMapping+"&uploadId="+this.uploadId+"&orgId="+this.orgId+"&userId="+this.user.getDbID()+"&selaction="+this.getSelaction();

			return "successxsl";
		} else {
			log.error("Unknown action");
			addActionError("Specify a mapping action!");

			return ERROR;
		}


	}*/

	@Action("UploadSchema_input")
	@Override
	public String input() throws Exception {

		if ( !user.hasRight(User.SUPER_USER) ) {
			addActionError("No super user  rights");
			return ERROR;
		}
		return super.input();
	}

}