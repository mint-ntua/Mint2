package gr.ntua.ivml.mint.actions;


import java.io.ByteArrayInputStream;



import java.io.InputStream;

import java.util.Collection;


import java.util.ArrayList;
import java.util.Map;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.Meta;

import gr.ntua.ivml.mint.mapping.MappingSummary;

import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.persistent.XpathHolder;

import gr.ntua.ivml.mint.xml.transform.XMLFormatter;
import gr.ntua.ivml.mint.xml.transform.XSLTGenerator;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;


import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;




@Results( { @Result(name = "input", location = "mappingOptions.jsp"),
		@Result(name = "error", location = "mappingselection.jsp"),
		@Result(name = "success", location = "mappingselection.jsp"),
		@Result(name="download", type="stream", params={"inputName", "stream", "contentType", "application/json", 
				  "contentDisposition", "attachment; filename=${filename}"}),
		@Result(name = "mappingtool",location="${url}", type="redirect" )
})
public class MappingOptions extends GeneralAction {

	protected final Logger log = Logger.getLogger(getClass());
	public String mapName;
	public String selaction;

	private long selectedMapping=-1;
	private long orgId=-1;
	
	private long uploadId;
	private Collection<String> missedMaps = new ArrayList<String>();
   private Mapping selmapping;

    private InputStream stream;
	private String filesize;
	private String filename;
	public String url="successmaptool";
	private boolean lockmap=false;
	
	public long getOrgId() {
		return orgId;
	}

	
	
	
	public InputStream getStream() {
		return stream;
	}

	public void setStream(InputStream stream) {
		this.stream = stream;
	}

	public String getFilesize() {
		return filesize;
	}

	public void setFilesize(String filesize) {
		this.filesize = filesize;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}
	
	public boolean isLockmap(){
		return lockmap;
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
	
	private void downloadMapping(String name, String m) throws Exception {
		downloadMapping(name, m, "mint");
	}

		/**
	 * Download either from attached transformation or an earlier
	 * Annotation content.
	 * @throws Exception
	 */
	private void downloadMapping(String name, String m, String suffix) throws Exception {
		try {
			ByteArrayInputStream bais = new ByteArrayInputStream(m.getBytes());
//			setFilesize( thefilesize );
			
			setFilename( name + "." + suffix);
			
	
			setStream(bais);
		} catch( Exception e ) {
			log.error( "Couldn't download" ,e );
			throw e;
		}
	}

	/**
	 * Download XSL from mapping & dataupload
	 * @throws Exception
	 */
	private void downloadXSL(String name, String mappings) throws Exception {
		Dataset du = DB.getDatasetDAO().findById(uploadId, false);
		XSLTGenerator xslt = new XSLTGenerator();
		XpathHolder itemPath = du.getItemRootXpath();
		
		String result = null;
		
		if((du instanceof DataUpload) && !((DataUpload)du).isDirect()) {
			xslt.setItemLevel(itemPath.getXpathWithPrefix(true));
			xslt.setImportNamespaces(du.getRootHolder().getNamespaces(true));
			
			String xsl = XMLFormatter.format(xslt.generateFromString(mappings));
			
			result = xsl;
		}else if(du instanceof Transformation){
			String xsl=((Transformation)du).getXsl();
			xsl = XMLFormatter.format(xsl);
			result= xsl;
		}
		
		try {
			ByteArrayInputStream bais = new ByteArrayInputStream(result.getBytes());
//			setFilesize( thefilesize );
			
			setFilename( name + ".xsl");
			
	
			setStream(bais);
		} catch( Exception e ) {
			log.error( "Couldn't download" ,e );
			throw e;
		}
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
	
	public boolean getIsXSL() {
		Mapping m = this.getSelmapping();
		if(m != null && m.getXsl() != null) {
			return true;
		}
		
		return false;
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

	
	public void setMapName(String mapName) {
		this.mapName = mapName;
	}


	public String getSelaction() {
		return selaction;
	}

	public void setSelaction(String selaction) {
		this.selaction = selaction;
	}

	@Action(value = "MappingOptions")
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
		if(selectedMapping==-1){
			addActionError("No mapping found");
			return ERROR;
		}
		
		if(this.getSelmapping().isLocked(user, this.getSessionId()) && !isApi()){
			addActionError("The Mappings are in use and locked by another user.");
			this.lockmap=true;
			return super.input();
		}
		else{
		if (!"createtemplatenew".equals(selaction)) {
			//orgId is used to call previous panel that displays mappings by org
			this.orgId=selmapping.getOrganization().getDbID();}
		}
	
		 if ("createtemplatenew".equals(selaction)) {
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
			// mp.setOrganization(user.getOrganization());
			if (this.getSelectedMapping() > 0) {
				long templateId = getSelectedMapping();
				Mapping temp = DB.getMappingDAO().getById(templateId, false);
				mp.setTargetSchema(temp.getTargetSchema());
				mp.setJsonString(temp.getJsonString());
			} else {
				
				addActionError("You must select a mapping to proceed.");

				return ERROR;
			}

			// save mapping name to db and commit

			DB.getMappingDAO().makePersistent(mp);
			DB.commit();

			return "success";
			
		} else if ("editmaps".equals(selaction)) {
			if (this.getSelectedMapping() > 0) {
				
				// check if mapping is locked here
				Mapping em = DB.getMappingDAO().getById(getSelectedMapping(),
						false);
				// check if current user has access to mappings
				if (em.isLocked(getUser(), getSessionId())) {
					
					addActionError("The selected mappings are currently in use by another user. Please try to edit them again later");
					return ERROR;
				}
				// check if this import corresponds to mappings
			/*	if (MappingSummary.getInvalidXPaths(DB.getDataUploadDAO()
						.getById(uploadId, false), em) != null) {
					this.missedMaps = MappingSummary.getInvalidXPaths(DB
							.getDataUploadDAO().getById(uploadId, false), em);
					
				}*/
				if (em.getXsl() != null && em.getXsl().length() > 0) {
					url = "successxsl?selectedMapping="+this.selectedMapping+"&uploadId="+uploadId+"&selaction="+this.getSelaction();
					return "mappingtool";
				} else if (missedMaps.size() == 0) {
					url+="?selectedMapping="+this.selectedMapping+"&uploadId="+uploadId+"&selaction="+this.getSelaction();
					return "mappingtool";
				} else {

					
					JSONObject object = (JSONObject) JSONSerializer.toJSON(em.getJsonString());
					Map<String,String> allmaps=MappingSummary.getMappedXPaths(object );
					Collection<String> allvalues = allmaps.values();

					addActionError("This import does not contain the following xpaths which appear in <i>'"
							+ em.getName()
							+ "'</i> mappings you are trying to use. If you are sure you have chosen the correct mappings for this import you can click on 'Continue anyway'.");
					
					boolean allinvalid=true;
					for(String i:allvalues){
						if(!this.missedMaps.contains(i)){
							allinvalid=false;
							break;
						}
					}
					if(allinvalid==true){
						
						addActionError("<div style='margin-top:5px;font-color:black;'>ALL XPATHS FOUND IN THESE MAPPINGS ARE INVALID FOR THIS IMPORT!</div>");
					}
					
					return ERROR;
				}
			} else {
				
				addActionError("Choose the mappings you want to edit!");
				return ERROR;
			}
		} else if ("sharemaps".equals(selaction)) {
			
		   if (this.getSelectedMapping() > 0) {
				// check if mapping is locked here

				Mapping em = DB.getMappingDAO().findById(getSelectedMapping(),
						false);
				// check if current user has access to mappings
				if (em.isLocked(getUser(), getSessionId())) {
					
					addActionError("The selected mappings are currently locked by another user. Please try to share them again later");
					return ERROR;
				}
				if(em.isShared()==true){
					em.setShared(false);
					
				}else{em.setShared(true);}
				DB.commit();
				refreshUser();
				
				addActionMessage("Mappings share state successfully altered!");
				return "success";

			} else {
				
				addActionError("Choose the mappings you want to share!");
				return ERROR;
			}
		} else if ("deletemaps".equals(selaction)) {
			
			
			if (this.getSelectedMapping() > 0) {
				boolean success = false;
				Mapping mp = DB.getMappingDAO().getById(getSelectedMapping(),
						true);
				if (mp.isLocked(getUser(), getSessionId())) {
					
					addActionError("The selected mappings are currently in use by another user.");
					return ERROR;
				}
				DB.getStatelessSession().beginTransaction();
				Meta.deleteAllProperties(mp);
				success = DB.getMappingDAO().makeTransient(mp);
				DB.commit();
				if (success) {
					
					return SUCCESS;

				} else {
					refreshUser();
					
					addActionError("Unable to delete selected Mappings. Mappings are in use!");
					return ERROR;
				}
			}

			else {
				
				addActionError("Choose the mappings you want to delete!");
				return ERROR;
			}
		} else if ("downloadmaps".equals(selaction)) {
			
			if (this.getSelectedMapping() > 0) {
				Mapping mp = DB.getMappingDAO().getById(getSelectedMapping(),
						true);
				if (mp.isLocked(getUser(), getSessionId())) {
					
					addActionError("The selected mappings are currently in use by another user.");
					return ERROR;
				}
				
				String json = mp.getJsonString();
				if (json != null) {
					downloadMapping(mp.getName(), json);
					return "download";
				} else {
					refreshUser();
					
					addActionError("Unable to donwload selected Mappings. Mappings are empty!");
					return ERROR;
				}
			}
			else {
				addActionError("Choose the mappings you want to download!");
				return ERROR;
			}
		} else if ("downloadxsl".equals(selaction)) {
			
			if (this.getSelectedMapping() > 0) {
				Mapping mp = DB.getMappingDAO().getById(getSelectedMapping(),
						true);
				if (mp.isLocked(getUser(), getSessionId()) &&!isApi()) {
					
					addActionError("The selected mappings are currently in use by another user.");
					return ERROR;
				}
				
				String json = mp.getJsonString();
				String xsl = mp.getXsl();
				
				if (json != null) {
					downloadXSL(mp.getName(), json);
					return "download";
				} else if(xsl != null){
					downloadMapping(mp.getName(), xsl, "xsl");
					return "download";
				} else {
					refreshUser();
					
					addActionError("Unable to donwload selected Mappings. Mappings are empty!");
					return ERROR;
				}
			}
			else {
				addActionError("Choose the mappings you want to download!");
				return ERROR;
			}
		} else {
			log.error("Unknown action");
			addActionError("Specify a mapping action!");
			
			return ERROR;
		}
		

	}

	@Action("MappingOptions_input")
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
			this.orgId=user.getOrganization().getDbID();
		}
		
		Dataset du = DB.getDatasetDAO().findById(uploadId, false);
		if( !du.getItemizerStatus().equals(Dataset.ITEMS_OK)) {
		addActionError("You must first define the Item Level and Item Label by choosing step 1.");
			return ERROR;
		}
		if(selectedMapping==-1){
			addActionError("No mapping found");
			return ERROR;
		}
		
		if(this.getSelmapping().isLocked(user, this.getSessionId())){
			addActionError("The Mappings are in use and locked by another user.");
			this.lockmap=true;
			return super.input();
		}
		
		
		return super.input();
	}

}