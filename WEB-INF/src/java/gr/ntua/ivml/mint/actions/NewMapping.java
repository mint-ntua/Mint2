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




@Results( { @Result(name = "input", location = "newmapping.jsp"),
	@Result(name = "error", location = "newmapping.jsp"),
	@Result(name="success", location="${url}", type="redirect" ),
	@Result(name="successxsl", location="${url}", type="redirect" )
})

public class NewMapping extends GeneralAction {

	protected final Logger log = Logger.getLogger(getClass());
	public String mapName;
	public String selaction;

	private long selectedMapping=-1;
	private long orgId;
	private long schemaSel;
	private long uploadId;
	private Mapping selmapping;
	private List<XmlSchema> schemas = new ArrayList<XmlSchema>();
	private String upfile;

	private String httpUp;
	public String url="successmaptool";

	public boolean automatic = Config.getBoolean("ui.default.automaticMappings");
	public boolean idmappings = Config.getBoolean("ui.default.idMappings");

	public Boolean getAutomatic() {
		return this.automatic;
	}


	public void setAutomatic(Boolean automatic) {
		this.automatic = automatic;
	}

	public Boolean getIdMappings() {
		return this.idmappings;
	}


	public void setIdMappings(Boolean idmappings) {
		this.idmappings = idmappings;
	}

	public long getOrgId() {
		return orgId;
	}

	public String getHttpUp() {
		return httpUp;
	}

	public void setHttpUp(String httpUp) {
		this.httpUp = httpUp;
	}


	public void findSchemas() {
		List<XmlSchema> allSchemas = DB.getXmlSchemaDAO().findAll();

		for(XmlSchema schema: allSchemas) {
			if(schema.getJsonTemplate() != null) {
				schemas.add(schema);
			}
		}
	}

	public List<XmlSchema> getSchemas() {
		return schemas;
	}



	public boolean checkName(String newname) {
		boolean exists = false;
		try {
			Organization org = user.getOrganization();
			for (Mapping m : DB.getMappingDAO().findByOrganization(org)) {
				if (m.getName().equalsIgnoreCase(newname)) {
					exists = true;
					break;
				}
			}

		} catch (Exception ex) {
			log.debug(" ERROR GETTING MAPPINGS:" + ex.getMessage());
		}
		return exists;
	}




	public void setSelectedMapping(long selectedMapping) {
		this.selectedMapping = selectedMapping;
		this.selmapping=DB.getMappingDAO().findById(this.selectedMapping, false);

	}

	public Mapping getSelmapping(){
		return this.selmapping;
	}

	public long getSelectedMapping() {
		return selectedMapping;
	}

	public void setUpfile(String upfile){
		this.upfile=upfile;
	}

	public String getUpfile(){
		return(upfile);
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


	public String getSelaction() {
		return selaction;
	}

	public void setSelaction(String selaction) {
		this.selaction = selaction;
	}

	@Action(value = "NewMapping")
	public String execute() throws Exception {
		if(selaction==null){selaction="";}
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
					mp.applyConfigurationAutomaticMappings(ds);
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
			}

			if(xsl != null) {
				mp.setXsl(xsl);
			} else {
				System.err.println("Error importing xsl: xsl is null");
				addActionError("Mappings import failed: xsl is null");
				return ERROR;
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


	}

	@Action("NewMapping_input")
	@Override
	public String input() throws Exception {

		if ( !user.hasRight(User.SUPER_USER) && !user.hasRight(User.MODIFY_DATA)) {
			addActionError("No mapping rights");
			return ERROR;
		}
		if(user.organization==null){
			Organization o=DB.getDatasetDAO().findById(uploadId, false).getOrganization();
			this.orgId=o.getDbID();

		}
		else{
			Organization o=user.organization;
			this.orgId=user.getOrganization().getDbID();
		}
		Dataset du = DB.getDatasetDAO().findById(uploadId, false);
		if( !du.getItemizerStatus().equals(Dataset.ITEMS_OK)) {

			addActionError("You must first define the Item Level and Item Label by choosing step 1.");
			return ERROR;
		}
		findSchemas();

		return super.input();
	}

}